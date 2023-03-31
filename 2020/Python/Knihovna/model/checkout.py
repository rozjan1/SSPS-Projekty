import datetime


class Checkout:
    col_names = ["when_borrowed", "when_returned", "who", "book"]

    def __init__(self, init_list, driver, id=None):
        when_borrowed = init_list[0]
        when_returned = init_list[1]
        if type(init_list[0]) == str:
            when_borrowed = datetime.datetime.fromisoformat(init_list[0])
        if type(init_list[1]) == str:
            when_returned = datetime.datetime.fromisoformat(init_list[1])

        self.when_borrowed = when_borrowed
        self.when_returned = when_returned
        self.user_id = init_list[2]
        self.book_id = init_list[3]

        self.id = id

        self.driver = driver

    def get_user(self):
        return self.driver.get_user_by_id(self.user_id)

    def get_book(self):
        return self.driver.get_book_by_id(self.book_id)

    def is_active(self):
        return self.when_returned is None

    def to_list(self):
        return [self.when_borrowed, self.when_returned, self.user_id, self.book_id]

    def __eq__(self, o: object) -> bool:
        if type(o) != Checkout:
            return False
        o: Checkout = o
        return self.when_borrowed == o.when_borrowed \
               and self.when_returned == o.when_returned \
               and self.user_id == o.user_id \
               and self.book_id == o.book_id \
               and self.id == o.id
