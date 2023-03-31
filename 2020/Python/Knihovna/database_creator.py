import sqlite3


def create(path):
    conn = sqlite3.connect(path)
    db = conn.cursor()
    command = '''
    CREATE TABLE authors
    (
        id INTEGER NOT NULL UNIQUE,
        name TEXT NOT NULL,
        surname TEXT NOT NULL,
        birthdate DATE NOT NULL,

        PRIMARY KEY("id" AUTOINCREMENT)
    );
    '''
    db.execute(command)
    command = '''
    CREATE TABLE books
    (
        id INTEGER NOT NULL UNIQUE,
        name TEXT NOT NULL,
        author INTEGER NOT NULL,

        PRIMARY KEY("id" AUTOINCREMENT)
        FOREIGN KEY(author) REFERENCES authors(id)
    );
            '''
    db.execute(command)

    command = '''
    CREATE TABLE users
    (
        id INTEGER NOT NULL UNIQUE,
        name TEXT NOT NULL,
        surname TEXT NOT NULL,
        birthdate DATE NOT NULL,

        PRIMARY KEY("id" AUTOINCREMENT)
    );
            '''
    db.execute(command)

    command = '''
    CREATE TABLE checkouts
    (
        id INTEGER NOT NULL UNIQUE,
        when_borrowed DATE NOT NULL,
        when_returned DATE,
        who INTEGER NOT NULL,
        book INTEGER NOT NULL,

        PRIMARY KEY("id" AUTOINCREMENT)
        FOREIGN KEY(who) REFERENCES users(id)
        FOREIGN KEY(book) REFERENCES books(id)
    );
            '''
    db.execute(command)

    conn.commit()
    conn.close()
