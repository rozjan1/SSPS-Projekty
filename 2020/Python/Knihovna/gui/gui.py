import tkinter
from tkinter import ttk

from gui.authors_frame import AuthorsFrame
from gui.books_frame import BooksFrame
from gui.checkouts_frame import CheckoutsFrame
from gui.return_frame import ReturnFrame
from gui.users_frame import UsersFrame



class GUI(tkinter.Tk):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.title("GUI")

        self.notebook = ttk.Notebook(self)

        self.authors_tab = AuthorsFrame(self.notebook, self)
        self.users_tab = UsersFrame(self.notebook, self)
        self.books_tab = BooksFrame(self.notebook, self)
        self.checkouts_tab = CheckoutsFrame(self.notebook, self)
        self.return_frame = ReturnFrame(self.notebook, self)

        self.tabs = [
            self.authors_tab,
            self.users_tab,
            self.books_tab,
            self.checkouts_tab,
            self.return_frame
        ]

        self.notebook.add(self.authors_tab, text="Authors")
        self.notebook.add(self.users_tab, text="Users")
        self.notebook.add(self.books_tab, text="Books")
        self.notebook.add(self.checkouts_tab, text="Checkout")
        self.notebook.add(self.return_frame, text="Return")

        self.notebook.pack(expand=1, fill="both")

        self.notebook.bind('<<NotebookTabChanged>>', self.on_tab_change)

    def on_tab_change(self, _):
        for tab in self.tabs:
            tab.do_update()


if __name__ == "__main__":
    win = GUI()
    win.mainloop()
