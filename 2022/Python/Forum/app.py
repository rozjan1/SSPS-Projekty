import os.path

from flask import Flask, render_template, redirect, url_for, request, session, flash, g

from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)

app.secret_key = "ahoj"
app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///database.db"

database_is_new = not os.path.exists("database.db")

db = SQLAlchemy(app)

# This is not an accident! It has to be here, only after the database is initialized
from models import *


def initialize_database():
    if __name__ != "__main__":
        return

    print("Initializing database...")
    # Create database
    db.create_all()

    if database_is_new:
        print("Populating with dummy data...")
        # Populate with dummy data
        u = User("admin", "admin")
        db.session.add(u)
        db.session.add(Post("Title 1", "This is the first message", u, "January 1, 2014"))
        db.session.add(Post("Title 2", "This is the second message", u, "May 15, 2022"))
        # Commit
        db.session.commit()


initialize_database()


def is_logged_in(session) -> bool:
    return "logged_in" in session and session["logged_in"] is not None


@app.route("/", methods=["GET", "POST", "PUT"])
def home():
    error = None

    if request.method == "POST":
        if not is_logged_in(session):
            username = request.form["username"]
            password = request.form["password"]

            users = User.query.filter((User.username == username) & (User.password == password)).all()

            if len(users) > 0:
                session["logged_in"] = username
                return redirect(url_for("home"))
            else:
                error = "Invalid credentials!"
        else:
            session.pop("logged_in", None)
            return redirect(url_for("home"))

    logged_in_user = get_logged_in_user(session)
    posts = Post.query.all()
    return render_template("index.html", error_msg=error, is_logged_in=is_logged_in(session), curr_user=logged_in_user,
                           reg_users=get_registered_users(), posts=posts)


@app.route("/register", methods=["GET", "POST"])
def register():
    error = None
    if request.method == "POST":
        username = request.form["username"]
        password = request.form["password"]
        print(f"User entered username: {username}, password: {password}")

        # Does the user already exist?
        res_username = User.query.filter(User.username == username).all()

        if len(res_username) > 0:
            error = "User already exists!"
        else:
            db.session.add(User(username, password))
            db.session.commit()

            session["register"] = True
            flash("Register successful...")
            return redirect(url_for("home"))

    return render_template("register.html", error_msg=error)


@app.route("/add_post", methods=["POST"])
def add_post():
    if not is_logged_in(session):
        raise RuntimeError("Not logged in!")
    title = request.form["title"]
    message = request.form["message"]

    add_post_to_database(session, title, message)

    return redirect(url_for("home"))


@app.route("/delete_post/<id>", methods=["POST"])
def delete_post(id):
    if not is_logged_in(session):
        raise RuntimeError("Not logged in!")
    logged_user = get_user_by_name(session["logged_in"])
    posts = Post.query.filter((Post.id == id) & (Post.author == logged_user)).all()
    if len(posts) == 0:
        raise RuntimeError("Invalid post id or user")
    db.session.delete(posts[0])
    db.session.commit()

    return redirect(url_for("home"))


def add_post_to_database(session, title, message):
    import datetime
    time = datetime.date.today()
    month = datetime.datetime.now().strftime("%B")
    final_time = month + " " + str(time.day) + ", " + str(time.year)

    db.session.add(Post(title, message, get_user_by_name(session["logged_in"]), final_time))
    db.session.commit()


def get_registered_users():
    users = User.query.all()
    all_users = [user for user in users]
    users_names = ""
    for user in all_users:
        users_names += str(user.username) + " "
    return users_names


def get_user_by_name(name):
    return User.query.filter(User.username == name).first()


def get_logged_in_user(session):
    if "logged_in" not in session:
        return None

    return get_user_by_name(session["logged_in"])


if __name__ == "__main__":
    app.run(debug=True, use_reloader=False)
