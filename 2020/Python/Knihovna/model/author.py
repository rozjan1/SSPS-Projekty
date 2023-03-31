class Author:
    col_names = ["name", "surname", "birthdate"]

    def __init__(self, init_list, driver, id=None):
        self.name = init_list[0]
        self.surname = init_list[1]
        self.birthdate = init_list[2]

        self.id = id

        self.driver = driver

    def to_list(self):
        return [self.name, self.surname, self.birthdate]

    def __str__(self) -> str:
        return "{} {}".format(self.name, self.surname)

    def __eq__(self, o: object) -> bool:
        if type(o) != Author:
            return False
        o: Author = o
        return self.name == o.name and self.surname == o.surname and self.birthdate == o.birthdate and self.id == o.id





