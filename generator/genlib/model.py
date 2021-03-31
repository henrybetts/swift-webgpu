from typing import Dict, Iterable, Optional, List, Any
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

    def get_swift_value(self, value: Any) -> str:
        return str(value)

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

    def get_swift_value(self, value: Any) -> str:
        if isinstance(value, str) and value.startswith('WGPU_'):
            return f'{self.swift_name}({value})'

        if self.name == 'float' and isinstance(value, str):
            return value.rstrip('f')

        return super().get_swift_value(value)


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

    def get_swift_value(self, value: Any) -> str:
        name = 'type ' + value if self.requires_prefix else value
        return '.' + camel_case(name.lower())


class BitmaskType(EnumType):
    @property
    def c_name(self) -> str:
        return super().c_name + 'Flags'


class Member:
    def __init__(self, name: str, type_: Type, annotation: Optional[str], length: Optional[str],
                 default: Optional[Any], optional: bool):
        self.name = name
        self.type = type_
        self.annotation = annotation
        self.length = length
        self.default = default
        self.optional = optional
        self.length_of: Optional[Member] = None

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
            if self.type.name == 'void':
                swift_type = 'UnsafeRawBufferPointer'
            else:
                swift_type = f'[{self.type.swift_name}]'

        elif not self.annotation or (self.annotation == 'const*' and self.type.category == 'structure'):
            swift_type = self.type.swift_name

        else:
            return self.c_type

        if self.type.category == 'callback':
            swift_type = '@escaping ' + swift_type

        if self.optional:
            swift_type += '?'

        return swift_type

    @property
    def conversion(self) -> typeconversion.Conversion:
        if self.length_of:
            if self.length_of.type.name == 'void':
                return typeconversion.buffer_length_conversion
            return typeconversion.array_length_conversion

        if self.name == 'userdata':
            return typeconversion.userdata_conversion

        if self.type.name == 'char' and self.annotation == 'const*':
            return typeconversion.optional_string_conversion if self.optional else typeconversion.string_conversion

        if self.annotation == 'const*' and self.length:
            if self.type.name == 'void':
                return typeconversion.buffer_conversion

            if self.type.category == 'enum':
                return typeconversion.enum_array_conversion

            if self.type.category == 'structure':
                return typeconversion.struct_array_conversion

            if self.type.category == 'object':
                return typeconversion.object_array_conversion

            if self.optional:
                return typeconversion.optional_implicit_array_conversion

            return typeconversion.implicit_array_conversion

        if self.type.category == 'enum':
            return typeconversion.enum_conversion

        if self.type.category == 'bitmask':
            return typeconversion.bitmask_conversion

        if self.type.category == 'structure':
            if self.optional:
                return typeconversion.optional_struct_conversion
            if self.annotation == 'const*':
                return typeconversion.struct_pointer_conversion
            return typeconversion.struct_conversion

        if self.type.category == 'object':
            return typeconversion.optional_object_conversion if self.optional else typeconversion.object_conversion

        if isinstance(self.type, CallbackType):
            return typeconversion.Conversion(self.type.function_name)

        return typeconversion.implicit_conversion

    @property
    def target_swift_name(self) -> str:
        return self.length_of.swift_name if self.length_of else self.swift_name

    @property
    def default_swift_value(self) -> Optional[str]:
        if self.optional:
            return 'nil'

        if self.default:
            return self.type.get_swift_value(self.default)


class StructureType(Type):
    def __init__(self, name: str, data: Dict):
        super().__init__(name, data)
        self.extensible = data.get('extensible', False)
        self.chained = data.get('chained', False)
        self.members: List[Member] = []

    @property
    def s_type(self) -> str:
        return 'WGPUSType_' + pascal_case(self.name)

    @property
    def swift_members(self) -> List[Member]:
        return [member for member in self.members if not member.length_of]

    def link(self, types: Dict[str, Type]):
        self.members = [
            Member(m['name'], types[m['type']], m.get('annotation'), m.get('length'),
                   m.get('default'), m.get('optional', False))
            for m in self.data['members']
        ]
        members_by_length = {member.length: member for member in self.members if member.length}
        for member in self.members:
            member.length_of = members_by_length.get(member.name)


class Method:
    def __init__(self, object_name: str, name: str, args: List[Member], return_type: Optional[Type]):
        self.object_name = object_name
        self.name = name
        self.args = args
        self.return_type = return_type

    @property
    def is_getter(self) -> bool:
        return self.return_type and not self.args and self.name.startswith('get ')

    @property
    def c_name(self) -> str:
        return 'wgpu' + pascal_case(self.object_name) + pascal_case(self.name)

    @property
    def swift_name(self) -> str:
        name = self.name
        if self.is_getter:
            name = name[4:]
        return camel_case(name.lower())

    @property
    def swift_args(self) -> List[Member]:
        return [arg for arg in self.args if not arg.length_of and arg.name != 'userdata']

    @property
    def return_conversion(self) -> Optional[typeconversion.Conversion]:
        if not self.return_type:
            return None

        if self.return_type.category == 'object':
            return typeconversion.object_conversion

        return typeconversion.implicit_conversion

    @property
    def hide_first_arg_label(self) -> bool:
        return self.args and self.name.endswith(' ' + self.args[0].name)


class ObjectType(Type):
    def __init__(self, name: str, data: Dict):
        super().__init__(name, data)
        self.methods: List[Method] = []

    @property
    def reference_method_name(self) -> str:
        return 'wgpu' + pascal_case(self.name) + 'Reference'

    @property
    def release_method_name(self) -> str:
        return 'wgpu' + pascal_case(self.name) + 'Release'

    def link(self, types: Dict[str, Type]):
        for method in self.data.get('methods', []):
            args = [
                Member(arg['name'], types[arg['type']], arg.get('annotation'), arg.get('length'),
                       arg.get('default'), arg.get('optional', False))
                for arg in method.get('args', [])
            ]
            args_by_length = {arg.length: arg for arg in args if arg.length}
            for arg in args:
                arg.length_of = args_by_length.get(arg.name)

            returns = method.get('returns')
            return_type = types[returns] if returns and returns != 'void' else None

            self.methods.append(Method(self.name, method['name'], args, return_type))


class CallbackType(Type):
    def __init__(self, name: str, data: Dict):
        super().__init__(name, data)
        self.args: List[Member] = []

    @property
    def function_name(self) -> str:
        return camel_case(self.name.lower())

    @property
    def swift_args(self) -> List[Member]:
        return [arg for arg in self.args if not arg.length_of and arg.name != 'userdata']

    def link(self, types: Dict[str, Type]):
        self.args = [
            Member(m['name'], types[m['type']], m.get('annotation'), m.get('length'),
                   m.get('default'), m.get('optional', False))
            for m in self.data['args']
        ]
        args_by_length = {arg.length: arg for arg in self.args if arg.length}
        for arg in self.args:
            arg.length_of = args_by_length.get(arg.name)


class Model:
    def __init__(self, data: Dict):
        self.types: Dict[str, Type] = {}

        category_types = {
            'native': NativeType,
            'enum': EnumType,
            'bitmask': BitmaskType,
            'structure': StructureType,
            'object': ObjectType,
            'callback': CallbackType,
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
