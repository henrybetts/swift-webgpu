from typing import Dict, Iterable, Optional, List, Any
from .nameutils import camel_case, pascal_case, swift_safe
from . import typeconversion


def _is_enabled(data: Dict, enabled_tags: Optional[List[str]]):
    tags = data.get('tags')

    if not tags or enabled_tags is None:
        return True

    return any(tag in enabled_tags for tag in tags)


class Base:
    def __init__(self, data: Dict):
        self.data = data

    @property
    def tags(self) -> List[str]:
        return self.data.get('tags', [])


class Type(Base):
    def __init__(self, name: str, data: Dict):
        super().__init__(data)
        self.name = name

    @property
    def category(self) -> str:
        return self.data['category']

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


class EnumValue(Base):
    def __init__(self, data: Dict, requires_prefix: bool):
        super().__init__(data)
        self.requires_prefix = requires_prefix

    @property
    def name(self) -> str:
        return self.data['name']

    @property
    def value(self) -> int:
        return self.data['value']

    @property
    def swift_name(self) -> str:
        name = 'type ' + self.name if self.requires_prefix else self.name
        return swift_safe(camel_case(name.lower()))


class EnumType(Type):
    def __init__(self, name: str, data: Dict, enabled_tags: List[str]):
        super().__init__(name, data)
        values = [value for value in data['values'] if _is_enabled(value, enabled_tags)]
        self.requires_prefix = any((value['name'][0].isdigit() for value in values))
        self.values = [EnumValue(value, self.requires_prefix) for value in values]

    def get_swift_value(self, value: Any) -> str:
        name = 'type ' + value if self.requires_prefix else value
        return '.' + camel_case(name.lower())


class BitmaskType(EnumType):
    @property
    def c_name(self) -> str:
        return super().c_name + 'Flags'


class Member(Base):
    def __init__(self, data: Dict):
        super().__init__(data)
        self.type: Type = None
        self.length_member: Optional[Member] = None
        self.length_of: Optional[Member] = None

    @property
    def name(self) -> str:
        return self.data['name']

    @property
    def annotation(self) -> Optional[str]:
        return self.data.get('annotation')

    @property
    def length(self) -> Optional[str]:
        return self.data.get('length')

    @property
    def default(self) -> Optional[Any]:
        return self.data.get('default')

    @property
    def optional(self) -> bool:
        return self.data.get('optional', False)

    @property
    def c_name(self) -> str:
        return camel_case(self.name)

    @property
    def swift_name(self) -> str:
        if ' ' in self.name:
            return swift_safe(camel_case(self.name.lower()))
        else:
            return swift_safe(self.name)

    @property
    def nullable(self) -> bool:
        return self.optional or self.default == 'nullptr'

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

        if self.nullable:
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
            return typeconversion.optional_string_conversion if self.nullable else typeconversion.string_conversion

        if self.annotation == 'const*' and self.length:
            if self.type.name == 'void':
                return typeconversion.buffer_conversion

            if self.type.category == 'enum':
                return typeconversion.enum_array_conversion

            if self.type.category == 'structure':
                return typeconversion.struct_array_conversion

            if self.type.category == 'object':
                return typeconversion.object_array_conversion

            if self.nullable:
                return typeconversion.optional_implicit_array_conversion

            return typeconversion.implicit_array_conversion

        if self.type.category == 'enum':
            return typeconversion.enum_conversion

        if self.type.category == 'bitmask':
            return typeconversion.bitmask_conversion

        if self.type.category == 'structure':
            if self.nullable:
                return typeconversion.optional_struct_conversion
            if self.annotation == 'const*':
                return typeconversion.struct_pointer_conversion
            return typeconversion.struct_conversion

        if self.type.category == 'object':
            return typeconversion.optional_object_conversion if self.nullable else typeconversion.object_conversion

        if isinstance(self.type, CallbackType):
            return typeconversion.Conversion(self.type.function_name)

        return typeconversion.implicit_conversion

    @property
    def target_swift_name(self) -> str:
        return self.length_of.swift_name if self.length_of else self.swift_name

    @property
    def default_swift_value(self) -> Optional[str]:
        if self.nullable:
            return 'nil'

        if self.default:
            return self.type.get_swift_value(self.default)

        if isinstance(self.type, StructureType) and not self.annotation and self.type.has_default_swift_initializer:
            return f'{self.type.swift_name}()'

    def link(self, types: Dict[str, Type]):
        self.type = types[self.data['type']]


class StructureType(Type):
    def __init__(self, name: str, data: Dict, enabled_tags: List[str]):
        super().__init__(name, data)

        self.members = [Member(m) for m in data['members'] if _is_enabled(m, enabled_tags)]
        members_by_name = {member.name: member for member in self.members}
        members_by_length = {member.length: member for member in self.members if member.length}
        for member in self.members:
            member.length_member = members_by_name.get(member.length)
            member.length_of = members_by_length.get(member.name)

    @property
    def extensible(self) -> bool:
        return self.data.get('extensible', False)

    @property
    def chained(self) -> bool:
        return self.data.get('chained', False)

    @property
    def s_type(self) -> str:
        return 'WGPUSType_' + pascal_case(self.name)

    @property
    def swift_members(self) -> List[Member]:
        return [member for member in self.members if not member.length_of]

    @property
    def has_default_swift_initializer(self) -> bool:
        return all(member.default_swift_value for member in self.swift_members)

    def link(self, types: Dict[str, Type]):
        for member in self.members:
            member.link(types)


class Method(Base):
    def __init__(self, data: Dict, object_name: str, enabled_tags: List[str]):
        super().__init__(data)
        self.object_name = object_name
        self.return_type: Optional[Type] = None

        self.args = [Member(arg) for arg in data.get('args', []) if _is_enabled(arg, enabled_tags)]
        args_by_name = {arg.name: arg for arg in self.args}
        args_by_length = {arg.length: arg for arg in self.args if arg.length}
        for arg in self.args:
            arg.length_member = args_by_name.get(arg.length)
            arg.length_of = args_by_length.get(arg.name)

    @property
    def name(self) -> str:
        return self.data['name']

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

    @property
    def is_callback_setter(self) -> bool:
        return self.name.startswith('set ') and self.name.endswith(' callback')

    def link(self, types: Dict[str, Type]):
        returns = self.data.get('returns')
        self.return_type = types[returns] if returns and returns != 'void' else None

        for arg in self.args:
            arg.link(types)


class ObjectType(Type):
    def __init__(self, name: str, data: Dict, enabled_tags: List[str]):
        super().__init__(name, data)
        self.methods = [Method(m, name, enabled_tags) for m in data.get('methods', []) if _is_enabled(m, enabled_tags)]

    @property
    def access_level(self) -> str:
        if self.name == 'instance':
            return 'open'
        return 'public'

    @property
    def reference_method_name(self) -> str:
        return 'wgpu' + pascal_case(self.name) + 'Reference'

    @property
    def release_method_name(self) -> str:
        return 'wgpu' + pascal_case(self.name) + 'Release'

    def link(self, types: Dict[str, Type]):
        for method in self.methods:
            method.link(types)


class CallbackType(Type):
    def __init__(self, name: str, data: Dict, enabled_tags: List[str]):
        super().__init__(name, data)

        self.args = [Member(m) for m in data['args'] if _is_enabled(m, enabled_tags)]
        args_by_length = {arg.length: arg for arg in self.args if arg.length}
        for arg in self.args:
            arg.length_of = args_by_length.get(arg.name)

    @property
    def function_name(self) -> str:
        return camel_case(self.name.lower())

    @property
    def swift_args(self) -> List[Member]:
        return [arg for arg in self.args if not arg.length_of and arg.name != 'userdata']

    def link(self, types: Dict[str, Type]):
        for arg in self.args:
            arg.link(types)


class TypedefType(Type):
    def __init__(self, name: str, data: Dict):
        super().__init__(name, data)
        self.type: Type = None

    def link(self, types: Dict[str, Type]):
        self.type = types[self.data['type']]


class Model:
    def __init__(self, data: Dict, enabled_tags: List[str] = None):
        self.types: Dict[str, Type] = {}

        def needs_tags(type_):
            return lambda *args: type_(*args, enabled_tags=enabled_tags)

        category_types = {
            'native': NativeType,
            'enum': needs_tags(EnumType),
            'bitmask': needs_tags(BitmaskType),
            'structure': needs_tags(StructureType),
            'object': needs_tags(ObjectType),
            'callback': needs_tags(CallbackType),
            'typedef': TypedefType,
        }

        for name, type_data in data.items():
            if name.startswith('_'):
                continue

            if not _is_enabled(type_data, enabled_tags):
                continue

            type_ = category_types.get(type_data['category'])

            if type_:
                self.types[name] = type_(name, type_data)

        for type_ in self.types.values():
            type_.link(self.types)

    def types_by_category(self, category: str) -> Iterable[Type]:
        return filter(lambda t: t.category == category, self.types.values())
