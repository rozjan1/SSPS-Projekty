import sqlite3
from typing import List

import model


class DatabaseDriver:
    instance = None

    def __init__(self, path):
        self.path = path
        self.conn = sqlite3.connect(self.path)
        self.cursor = self.conn.cursor()

    def __del__(self):
        self.conn.close()

    def _get_all(self, object_class, table_name):
        self.cursor.execute("SELECT id,{} FROM {}".format(",".join(object_class.col_names), table_name))
        res = self.cursor.fetchall()
        return [object_class(i[1:], self, i[0]) for i in res]

    def get_all_authors(self) -> List[model.author.Author]:
        return self._get_all(model.author.Author, "authors")

    def get_all_books(self) -> List[model.book.Book]:
        return self._get_all(model.book.Book, "books")

    def get_all_users(self) -> List[model.user.User]:
        return self._get_all(model.user.User, "users")

    def get_all_checkouts(self) -> List[model.checkout.Checkout]:
        return self._get_all(model.checkout.Checkout, "checkouts")

    def _get_by_id(self, class_name, table_name, id):
        self.cursor.execute('SELECT {} FROM {} WHERE id = ?'.format(",".join(class_name.col_names), table_name), (id,))
        res = self.cursor.fetchone()
        return class_name(res, self, id)

    def get_user_by_id(self, id):
        return self._get_by_id(model.user.User, "users", id)

    def get_author_by_id(self, id):
        return self._get_by_id(model.author.Author, "authors", id)

    def get_book_by_id(self, id):
        return self._get_by_id(model.book.Book, "books", id)

    def get_checkout_by_id(self, id):
        return self._get_by_id(model.checkout.Checkout, "checkouts", id)

    def _save(self, obj, object_class, table_name):
        if obj.id is None:
            self._save_new(obj, object_class, table_name)
        else:
            col_names = object_class.col_names
            result = "=?, ".join(col_names) + "=?"
            query = "UPDATE {} SET {} WHERE id=?".format(table_name, result)

            values = obj.to_list()
            values.append(obj.id)
            self.cursor.execute(query, values)
            self.conn.commit()

    def _save_new(self, obj, object_class, table_name):
        question_marks = "?, " * len(object_class.col_names)
        # Remove last comma
        question_marks = question_marks[:-2]

        query = "INSERT INTO {} ({}) VALUES ({})".format(table_name, ",".join(object_class.col_names), question_marks)

        self.cursor.execute(query, obj.to_list())

        self.conn.commit()

        obj.id = self.cursor.lastrowid

    def save_user(self, user):
        self._save(user, model.user.User, "users")

    def save_author(self, author):
        self._save(author, model.author.Author, "authors")

    def save_checkout(self, checkout):
        self._save(checkout, model.checkout.Checkout, "checkouts")

    def save_book(self, book):
        self._save(book, model.book.Book, "books")

    def _delete(self, obj, obj_class, table_name):
        query = "DELETE FROM {} WHERE id=?".format(table_name)
        self.cursor.execute(query, (obj.id,))
        self.conn.commit()

    def delete_user(self, user):
        self._delete(user, model.user.User, "users")

    def delete_checkout(self, checkout):
        self._delete(checkout, model.checkout.Checkout, "checkouts")

    def delete_book(self, book):
        self._delete(book, model.book.Book, "books")

    def delete_author(self, author):
        self._delete(author, model.author.Author, "authors")

    def is_book_borrowed(self, book):
        query = "SELECT id FROM checkouts WHERE when_returned = null AND book = ?"
        self.cursor.execute(query, (book.id,))
        return len(self.cursor.fetchall()) > 0

    def _all_borrowed_ids(self):
        query = "SELECT book FROM checkouts WHERE when_returned IS null"
        self.cursor.execute(query)
        book_ids = self.cursor.fetchall()
        if len(book_ids) == 0:
            return []
        return [book_id[0] for book_id in book_ids]

    def get_all_borrowed_books(self):
        ids = self._all_borrowed_ids()
        return [self.get_book_by_id(id) for id in ids]

    def get_all_present_books(self):
        ids = self._all_borrowed_ids()
        books = self.get_all_books()
        result = []
        for book in books:
            if book.id not in ids:
                result.append(book)
        return result

    def get_users_who_borrowed_book(self, book):
        query = "SELECT who FROM checkouts WHERE when_returned IS null AND book = ?"
        self.cursor.execute(query, (book.id,))
        user_ids = [i[0] for i in self.cursor.fetchall()]
        return [self.get_user_by_id(id) for id in user_ids]

    def get_checkout_for(self, book, user):
        query = "SELECT id FROM checkouts WHERE when_returned IS null AND who = ? AND book = ?"
        self.cursor.execute(query, (user.id, book.id,))
        res = self.cursor.fetchone()
        if len(res) == 0:
            return None
        id = res[0]
        return self.get_checkout_by_id(id)