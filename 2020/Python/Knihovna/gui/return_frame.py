import datetime
import tkinter
from tkinter import ttk

from database_driver import DatabaseDriver


class ReturnFrame(tkinter.Frame):
    def __init__(self, parent, controller, *args, **kwargs):
        super().__init__(parent, *args, **kwargs)

        self.controller = controller
        self.parent = parent

        self.boxes_frame = tkinter.Frame(self)

        self.lbl_time_var = tkinter.StringVar(self.boxes_frame)
        self.lbl_time = tkinter.Label(self.boxes_frame, textvariable=self.lbl_time_var)
        self.lbl_time.grid(row=4,  column=0, columnspan=2)

        self.lbl_book = tkinter.Label(self.boxes_frame, text="Book: ")
        self.lbl_book.grid(row=1, column=0)

        self.loaded_books = []
        self.cmb_book = ttk.Combobox(self.boxes_frame)
        self.cmb_book.bind("<<ComboboxSelected>>", self.on_book_changed)
        self.cmb_book.grid(row=1, column=1)

        self.lbl_user = tkinter.Label(self.boxes_frame, text="User: ")
        self.lbl_user.grid(row=2, column=0)

        self.loaded_users = []
        self.cmb_user = ttk.Combobox(self.boxes_frame)
        self.cmb_user.bind("<<ComboboxSelected>>", self.on_user_changed)
        self.cmb_user.grid(row=2, column=1)

        self.boxes_frame.grid(row=0, column=0, padx=(5, 5), pady=(5, 5))

        self.buttons_frame = tkinter.Frame(self)

        self.btn_add = tkinter.Button(self.buttons_frame, text="Vratit", command=self.btn_vratit_clicked)
        self.btn_add.grid(row=2, column=0, padx=(5, 0))

        self.buttons_frame.grid(row=1, column=0, padx=(5, 5), pady=(5, 5))

        # Load gui
        self.loaded_books = []
        self.loaded_users = []
        self.currently_selected_checkout = None
        self.refresh_list()

    def btn_vratit_clicked(self):
        book = self.get_selected_book()
        print(DatabaseDriver.instance.is_book_borrowed(book))

        checkouts = DatabaseDriver.instance.get_all_checkouts()

        user_id = self.get_selected_user().id

        for checkout in checkouts:
            if checkout.book_id == book.id and checkout.user_id == user_id and checkout.when_returned is None:
                checkout.when_returned = datetime.datetime.now()
                DatabaseDriver.instance.save_checkout(checkout)
                break

        self.refresh_list()

    def refresh_list(self):
        self.loaded_books = DatabaseDriver.instance.get_all_borrowed_books()
        self.loaded_users = []
        if self.loaded_books:
            self.loaded_users = DatabaseDriver.instance.get_users_who_borrowed_book(self.loaded_books[self.cmb_book.current()])

        self.cmb_user["values"] = [str(i) for i in self.loaded_users]
        self.cmb_book["values"] = [str(i) for i in self.loaded_books]

    def do_update(self):
        self.refresh_list()

    def on_book_changed(self, *args):
        self.loaded_users = DatabaseDriver.instance.get_users_who_borrowed_book(self.loaded_books[self.cmb_book.current()])
        self.cmb_user["values"] = [str(i) for i in self.loaded_users]

    def on_user_changed(self, *args):
        book = self.get_selected_book()
        user = self.get_selected_user()
        if book is None or user is None:
            return
        self.currently_selected_checkout = DatabaseDriver.instance.get_checkout_for(book, user)
        self.borrowed_for_how_long(self.currently_selected_checkout)

    def get_selected_user(self):
        if self.cmb_user.current() < 0:
            return None
        return self.loaded_users[self.cmb_user.current()]

    def get_selected_book(self):
        if self.cmb_book.current() < 0:
            return None
        return self.loaded_books[self.cmb_book.current()]

    def borrowed_for_how_long(self, checkout):
        difference = datetime.datetime.now() - checkout.when_borrowed
        self.lbl_time_var.set("Time since checkout: {}".format(difference))
