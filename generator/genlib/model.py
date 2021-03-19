from typing import Dict, Iterable
from .nameutils import camel_case, pascal_case, swift_safe


class Type:
    def __init__(self, name: str, data: Dict):
        self.name = name
        self.data = data
        self.category = data['category']

    @property
    def c_name(self) -> str:
        return 'WGPU' + pascal_case(self.name)

    @property
    def swift_name(self) -> str:
        return pascal_case(self.name.lower())


class EnumValue:
    def __init__(self, name: str, value: int, requires_prefix: bool):
        self.name = name
        self.value = value
        self.requires_prefix = requires_prefix

    @property
    def swift_name(self) -> str:
        name = 'type ' + self.name if self.requires_prefix else self.name
        return swift_safe(camel_case(name.lower()))


class EnumType(Type):
    def __init__(self, name: str, data: Dict):
        super().__init__(name, data)
        self.requires_prefix = any((value['name'][0].isdigit() for value in data['values']))
        self.values = [EnumValue(value['name'], value['value'], self.requires_prefix) for value in data['values']]


class Model:
    def __init__(self, data: Dict):
        self.types: Dict[str, Type] = {}

        category_types = {
            'enum': EnumType,
            'bitmask': EnumType,
        }

        for name, type_data in data.items():
            if name.startswith('_'):
                continue

            type_ = category_types.get(type_data['category'])

            if type_:
                self.types[name] = type_(name, type_data)

    def types_by_category(self, category: str) -> Iterable[Type]:
        return filter(lambda t: t.category == category, self.types.values())
