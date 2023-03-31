import datetime
import tkinter
from tkinter import ttk

from database_driver import DatabaseDriver
from model import Checkout


class CheckoutsFrame(tkinter.Frame):
    def __init__(self, parent, controller, *args, **kwargs):
        super().__init__(parent, *args, **kwargs)

        self.controller = controller
        self.parent = parent

        self.boxes_frame = tkinter.Frame(self)

        self.lbl_book = tkinter.Label(self.boxes_frame, text="Book: ")
        self.lbl_book.grid(row=1, column=0)

        self.loaded_books = []
        self.cmb_book = ttk.Combobox(self.boxes_frame)
        self.cmb_book.grid(row=1, column=1)

        self.lbl_user = tkinter.Label(self.boxes_frame, text="User: ")
        self.lbl_user.grid(row=2, column=0)

        self.loaded_users = []
        self.cmb_user = ttk.Combobox(self.boxes_frame)
        self.cmb_user.grid(row=2, column=1)

        self.boxes_frame.grid(row=0, column=0, padx=(5, 5), pady=(5, 5))

        self.buttons_frame = tkinter.Frame(self)

        self.btn_add = tkinter.Button(self.buttons_frame, text="Pujcit", command=self.btn_pujcit_clicked)
        self.btn_add.grid(row=2, column=0, padx=(5, 0))

        self.buttons_frame.grid(row=1, column=0, padx=(5, 5), pady=(5, 5))

        # Load gui
        self.loaded_books = []
        self.loaded_users = []
        self.refresh_list()

    def btn_pujcit_clicked(self):
        init_list = [
            datetime.datetime.now(),
            None,
            self.loaded_users[self.cmb_user.current()].id,
            self.loaded_books[self.cmb_book.current()].id
        ]

        checkout = Checkout(init_list, DatabaseDriver.instance)
        DatabaseDriver.instance.save_checkout(checkout)

        self.refresh_list()

    def refresh_list(self):
        self.loaded_books = DatabaseDriver.instance.get_all_present_books()
        self.loaded_users = DatabaseDriver.instance.get_all_users()

        self.cmb_user["values"] = [str(i) for i in self.loaded_users]
        self.cmb_book["values"] = [str(i) for i in self.loaded_books]

    def do_update(self):
        self.refresh_list()
