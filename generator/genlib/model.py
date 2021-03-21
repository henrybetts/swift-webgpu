from typing import Dict, Iterable, Optional, List
from .nameutils import camel_case, pascal_case, swift_safe
from . import typeconversion


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

    def link(self, types: Dict[str, 'Type']):
        pass


class NativeType(Type):
    def __init__(self, name: str, data: Dict):
        super().__init__(name, data)

    @property
    def c_name(self) -> str:
        return {
            'void': 'Void',
            'void *': 'UnsafeMutableRawPointer!',
            'void const *': 'UnsafeRawPointer!',
            'char': 'CChar',
            'float': 'Float',
            'double': 'Double',
            'uint8_t': 'UInt8',
            'uint16_t': 'UInt16',
            'uint32_t': 'UInt32',
            'uint64_t': 'UInt64',
            'int32_t': 'Int32',
            'int64_t': 'Int64',
            'size_t': 'Int',
            'int': 'Int32',
            'bool': 'Bool'
        }[self.name]

    @property
    def swift_name(self) -> str:
        return self.c_name


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


class BitmaskType(EnumType):
    @property
    def c_name(self) -> str:
        return super().c_name + 'Flags'


class Member:
    def __init__(self, name: str, type_: Type, annotation: Optional[str], length: Optional[str], optional: bool):
        self.name = name
        self.type = type_
        self.annotation = annotation
        self.length = length
        self.optional = optional

    @property
    def c_name(self) -> str:
        return camel_case(self.name)

    @property
    def swift_name(self) -> str:
        return swift_safe(camel_case(self.name.lower()))

    @property
    def c_type(self) -> str:
        if self.type.name == 'void' and self.annotation == 'const*':
            return 'UnsafeRawPointer!'

        if self.type.name == 'void' and self.annotation == '*':
            return 'UnsafeMutableRawPointer!'

        if self.annotation == 'const*' and self.type.category == 'object':
            return f'UnsafePointer<{self.type.c_name}?>!'

        if self.annotation == 'const*':
            return f'UnsafePointer<{self.type.c_name}>!'

        if self.annotation == '*':
            return f'UnsafeMutablePointer<{self.type.c_name}>!'

        if self.type.category == 'object':
            return f'{self.type.c_name}!'

        return self.type.c_name

    @property
    def swift_type(self) -> str:
        if self.type.name == 'char' and self.annotation == 'const*':
            swift_type = 'String'

        elif self.annotation == 'const*' and self.length:
            swift_type = f'[{self.type.swift_name}]'

        elif not self.annotation or (self.annotation == 'const*' and self.type.category == 'structure'):
            swift_type = self.type.swift_name

        else:
            return self.c_type

        if self.optional:
            swift_type += '?'

        return swift_type

    @property
    def conversion(self) -> typeconversion.Conversion:
        if self.type.name == 'char' and self.annotation == 'const*':
            return typeconversion.optional_string_conversion if self.optional else typeconversion.string_conversion

        if self.annotation == 'const*' and self.length:
            return typeconversion.implicit_conversion

        if self.type.category == 'enum':
            return typeconversion.enum_conversion

        if self.type.category == 'bitmask':
            return typeconversion.bitmask_conversion

        return typeconversion.implicit_conversion


class StructureType(Type):
    def __init__(self, name: str, data: Dict):
        super().__init__(name, data)
        self.extensible = data.get('extensible', False)
        self.chained = data.get('chained', False)
        self.members: List[Member] = []

    def link(self, types: Dict[str, Type]):
        self.members = [
            Member(m['name'], types[m['type']], m.get('annotation'), m.get('length'), m.get('optional', False))
            for m in self.data['members']
        ]


class ObjectType(Type):
    def __init__(self, name: str, data: Dict):
        super().__init__(name, data)


class Model:
    def __init__(self, data: Dict):
        self.types: Dict[str, Type] = {}

        category_types = {
            'native': NativeType,
            'enum': EnumType,
            'bitmask': BitmaskType,
            'structure': StructureType,
            'object': ObjectType,
        }

        for name, type_data in data.items():
            if name.startswith('_'):
                continue

            type_ = category_types.get(type_data['category'])

            if type_:
                self.types[name] = type_(name, type_data)

        for type_ in self.types.values():
            type_.link(self.types)

    def types_by_category(self, category: str) -> Iterable[Type]:
        return filter(lambda t: t.category == category, self.types.values())
