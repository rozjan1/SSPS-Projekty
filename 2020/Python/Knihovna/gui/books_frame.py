import datetime
import sys
import tkinter
from tkinter import ttk

from database_driver import DatabaseDriver
from model import User, Book

class BooksFrame(tkinter.Frame):
    def __init__(self, parent, controller, *args, **kwargs):
        super().__init__(parent, *args, **kwargs)

        self.controller = controller
        self.parent = parent

        self.boxes_frame = tkinter.Frame(self)

        self.lbl_name = tkinter.Label(self.boxes_frame, text="Name: ")
        self.lbl_name.grid(row=1, column=0)

        self.txt_name_var = tkinter.StringVar()
        self.txt_name = tkinter.Entry(self.boxes_frame, textvariable=self.txt_name_var)
        self.txt_name.grid(row=1, column=1)

        self.lbl_author = tkinter.Label(self.boxes_frame, text="Author: ")
        self.lbl_author.grid(row=2, column=0)

        self.loaded_authors = []
        self.cmb_author = ttk.Combobox(self.boxes_frame)
        self.cmb_author.grid(row=2, column=1)

        self.boxes_frame.grid(row=0, column=0, padx=(5, 5), pady=(5, 5))

        self.buttons_frame = tkinter.Frame(self)

        self.btn_add = tkinter.Button(self.buttons_frame, text="Add", command=self.btn_add_clicked)
        self.btn_add.grid(row=2, column=0, padx=(5, 0))
        self.btn_delete = tkinter.Button(self.buttons_frame, text="Delete", command=self.btn_delete_clicked)
        self.btn_delete.grid(row=2, column=1, padx=(5, 0))

        self.buttons_frame.grid(row=1, column=0, padx=(5, 5), pady=(5, 5))

        self.list_frame = tkinter.Frame(self)

        self.list_scroll = tkinter.Scrollbar(self.list_frame, orient=tkinter.VERTICAL)
        self.list_box = tkinter.Listbox(self.list_frame, yscrollcommand=self.list_scroll.set)
        self.list_scroll.config(command=self.list_box.yview)
        self.list_scroll.grid(row=3, column=3)
        self.list_box.grid(row=3, column=2)
        self.list_box.bind("<<ListboxSelect>>", self.list_box_on_selected)

        self.list_frame.grid(row=2, column=0, padx=(5, 5), pady=(5, 5))

        # Load gui
        self.loaded_books = []
        self.refresh_list()

    def btn_add_clicked(self):
        # 14-3-1558

        init_list = [
            self.txt_name_var.get(),
            self.loaded_authors[self.cmb_author.current()].id
        ]
        book = Book(init_list, DatabaseDriver.instance)
        DatabaseDriver.instance.save_book(book)

        self.refresh_list()

    def list_box_on_selected(self, evt):
        selected_book = self.get_list_selected()
        if selected_book is None:
            return
        self.txt_name_var.set(selected_book.name)
        index = self.loaded_authors.index(selected_book.get_author())
        self.cmb_author.current(index)

    def btn_delete_clicked(self):
        book = self.get_list_selected()
        DatabaseDriver.instance.delete_book(book)
        self.refresh_list()
        self.txt_name_var.set("")

    def get_list_selected(self):
        ret = self.list_box.curselection()
        if len(ret) == 0:
            print("Nothing is selected!", file=sys.stderr)
            return None
        index = ret[0]
        return self.loaded_books[index]

    def refresh_list(self):
        self.loaded_books = DatabaseDriver.instance.get_all_books()
        self.list_box.delete(0, tkinter.END)
        for i in self.loaded_books:
            self.list_box.insert(tkinter.END, str(i))

        self.loaded_authors = DatabaseDriver.instance.get_all_authors()

        self.cmb_author["values"] = [str(i) for i in self.loaded_authors]

    def do_update(self):
        self.refresh_list()