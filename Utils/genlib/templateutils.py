from typing import Iterable
from .model import Member


def cond(condition: bool, value: str, not_value: str = '') -> str:
    return value if condition else not_value


class Loop:
    def __init__(self, iterable: Iterable):
        list_ = list(iterable)
        self.iterator = iter(list_)
        self.length = len(list_)
        self.index = -1

    @property
    def first(self) -> bool:
        return self.index == 0

    @property
    def last(self) -> bool:
        return self.index == self.length - 1

    def sep(self, sep: str = ',', last_sep: str = '') -> str:
        return cond(not self.last, sep, last_sep)

    def __iter__(self):
        return self

    def __next__(self):
        self.index += 1
        return next(self.iterator), self


def swift_function_params(members: Iterable[Member], hide_first_label: bool = False) -> Iterable[str]:
    first = True
    for member in members:
        result = ''
        if hide_first_label and first:
            result += '_ '
            first = False
        result += f'{member.swift_name}: {member.swift_type}'
        if member.default_swift_value:
            result += f' = {member.default_swift_value}'
        yield result
