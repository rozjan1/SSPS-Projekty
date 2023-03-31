import os
import sqlite3

import database_creator
from database_driver import DatabaseDriver
from gui.gui import GUI

DATABASE_FILENAME = "database.db"

print("Starting library...")

database_is_new = not os.path.exists(DATABASE_FILENAME)

with sqlite3.connect(DATABASE_FILENAME) as conn:
    if database_is_new:
        # We have to create tables
        database_creator.create(DATABASE_FILENAME)

    DatabaseDriver.instance = DatabaseDriver(DATABASE_FILENAME)

    win = GUI()
    win.mainloop()

