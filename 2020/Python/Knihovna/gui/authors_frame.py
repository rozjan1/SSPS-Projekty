import datetime
import sys
import tkinter

from database_driver import DatabaseDriver
from model import Author


class AuthorsFrame(tkinter.Frame):
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

        self.lbl_surname = tkinter.Label(self.boxes_frame, text="Surname: ")
        self.lbl_surname.grid(row=2, column=0)

        self.txt_surname_var = tkinter.StringVar()
        self.txt_surname = tkinter.Entry(self.boxes_frame, textvariable=self.txt_surname_var)
        self.txt_surname.grid(row=2, column=1)

        self.lbl_birthday = tkinter.Label(self.boxes_frame, text="Birthday: ")
        self.lbl_birthday.grid(row=3, column=0)

        self.txt_birthday_var = tkinter.StringVar()
        self.txt_birthday = tkinter.Entry(self.boxes_frame, textvariable=self.txt_birthday_var)
        self.txt_birthday.grid(row=3, column=1)

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
        self.loaded_authors = []
        self.refresh_list()

    def btn_add_clicked(self):
        # 14-3-1558

        birthday_str = self.txt_birthday_var.get()

        try:
            birthday = datetime.datetime.strptime(birthday_str, "%d-%m-%Y").date()
        except ValueError:
            print("Bad date format!")
            return

        init_list = [
            self.txt_name_var.get(),
            self.txt_surname_var.get(),
            birthday
        ]
        author = Author(init_list, DatabaseDriver.instance)
        DatabaseDriver.instance.save_author(author)

        self.refresh_list()

    def list_box_on_selected(self, evt):
        selected_author = self.get_list_selected()
        if selected_author is None:
            return
        self.txt_name_var.set(selected_author.name)
        self.txt_surname_var.set(selected_author.surname)
        self.txt_birthday_var.set(selected_author.birthdate)

    def btn_delete_clicked(self):
        author = self.get_list_selected()
        DatabaseDriver.instance.delete_author(author)
        self.refresh_list()
        self.txt_birthday_var.set("")
        self.txt_surname_var.set("")
        self.txt_name_var.set("")

    def get_list_selected(self):
        ret = self.list_box.curselection()
        if len(ret) == 0:
            print("Nothing is selected!", file=sys.stderr)
            return None
        index = ret[0]
        return self.loaded_authors[index]

    def refresh_list(self):
        self.loaded_authors = DatabaseDriver.instance.get_all_authors()
        self.list_box.delete(0, tkinter.END)
        for i in self.loaded_authors:
            self.list_box.insert(tkinter.END, str(i))

    def do_update(self):
        self.refresh_list()

