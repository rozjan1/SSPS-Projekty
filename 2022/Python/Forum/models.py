from app import db


class User(db.Model):
    __tablename__ = "tbl_users"

    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String, nullable=False)
    password = db.Column(db.String, nullable=False)

    def __init__(self, username: str, password: str):
        self.username = username
        self.password = password

    def __repr__(self):
        return f"<User {self.username};{self.password}>"


class Post(db.Model):
    __tablename__ = "tbl_posts"

    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String, nullable=False)
    body = db.Column(db.String, nullable=False)
    date = db.Column(db.String, nullable=False)

    author_id = db.Column(db.Integer, db.ForeignKey("tbl_users.id"))
    author = db.relationship("User", backref="posts")

    def __init__(self, title: str, body: str, author: User, date: str):
        self.body = body
        self.author = author
        self.title = title
        self.date = date
