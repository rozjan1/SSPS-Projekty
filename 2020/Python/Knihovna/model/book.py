
class Book:
    col_names = ["name", "author"]

    def __init__(self, init_list, driver, id=None):
        self.name = init_list[0]
        self.author_id = init_list[1]

        self.id = id

        self.driver = driver

    def get_author(self):
        return self.driver.get_author_by_id(self.author_id)

    def to_list(self):
        return [self.name, self.author_id]

    def __str__(self):
        return "{} - {}".format(self.name, self.get_author())

    def __eq__(self, o: object) -> bool:
        if type(o) != Book:
            return False
        o: Book = o
        return self.name == o.name and self.author_id == o.author_id and self.id == o.id

