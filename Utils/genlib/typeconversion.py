from . import gyb
from typing import Tuple, Union


def _parse_template(text: str):
    return gyb.parse_template(__file__, text)


def _render_template(template, **kwargs):
    return gyb.execute_template(template, line_directive='', **kwargs)


class Conversion:
    def __init__(self, c_value_template: str, closure_template: Tuple[str, str] = None,
                 swift_value_template: str = None):
        self.c_value_template = _parse_template(c_value_template)
        self.closure_template = (_parse_template(closure_template[0]),
                                 _parse_template(closure_template[1])) if closure_template else None
        self.swift_value_template = _parse_template(swift_value_template) if swift_value_template else None

    @staticmethod
    def _render(template, name: str, value: str = None, prefix: str = None):
        if not value:
            value = prefix + name if prefix else name
        return _render_template(template, name=name, value=value)

    def get_c_value(self, name: str, value: str = None, prefix: str = None) -> str:
        return self._render(self.c_value_template, name, value, prefix)

    def get_closure_head(self, name: str, value: str = None, prefix: str = None) -> str:
        return self._render(self.closure_template[0], name, value, prefix)

    def get_closure_tail(self, name: str, value: str = None, prefix: str = None) -> str:
        return self._render(self.closure_template[1], name, value, prefix)

    @property
    def requires_closure(self) -> bool:
        return self.closure_template is not None

    def get_swift_value(self, value: str, length: Union[str, int] = None) -> str:
        return _render_template(self.swift_value_template, value=value, length=length)


implicit_conversion = Conversion('${value}', None, '${value}')

implicit_array_conversion = Conversion('buffer_${name}.baseAddress',
                                       ('${value}.withUnsafeBufferPointer { buffer_${name} in', '}'),
                                       'Array(UnsafeBufferPointer(start: ${value}, count: Int(${length})))')

optional_implicit_array_conversion =\
    Conversion('buffer_${name}.baseAddress',
               ('${value}.withOptionalUnsafeBufferPointer { buffer_${name} in', '}'),
               '${value} != nil ? Array(UnsafeBufferPointer(start: ${value}, count: Int(${length}))) : nil')

enum_conversion = Conversion('${value}.cValue', None, '.init(cValue: ${value})')

enum_array_conversion =\
    Conversion('buffer_${name}.baseAddress',
               ('${value}.map { $0.cValue }.withUnsafeBufferPointer { buffer_${name} in', '}'),
               'UnsafeBufferPointer(start: ${value}, count: Int(${length})).map { .init(cValue: $0) }')

bitmask_conversion = Conversion('${value}.rawValue', None, '.init(rawValue: ${value})')

string_conversion = Conversion('cString_${name}',
                               ('${value}.withCString { cString_${name} in', '}'),
                               'String(cString: ${value})')

optional_string_conversion = Conversion('cString_${name}',
                                        ('${value}.withOptionalCString { cString_${name} in', '}'),
                                        '${value} != nil ? String(cString: ${value}) : nil')

string_array_conversion =\
    Conversion('buffer_${name}.baseAddress',
               ('${value}.withCStringBufferPointer { buffer_${name} in', '}'),
               'UnsafeBufferPointer(start: ${value}, count: Int(${length})).map { String(cString: $0!) }')

struct_conversion = Conversion('cStruct_${name}.pointee',
                               ('${value}.withCStruct { cStruct_${name} in', '}'),
                               '.init(cStruct: ${value})')

struct_pointer_conversion = Conversion('cStruct_${name}',
                                       ('${value}.withCStruct { cStruct_${name} in', '}'),
                                       '.init(cStruct: ${value}.pointee)')

optional_struct_conversion = Conversion('cStruct_${name}',
                                        ('${value}.withOptionalCStruct { cStruct_${name} in', '}'),
                                        '${value} != nil ? .init(cStruct: ${value}.pointee) : nil')

struct_array_conversion =\
    Conversion('buffer_${name}.baseAddress',
               ('${value}.withCStructBufferPointer { buffer_${name} in', '}'),
               'UnsafeBufferPointer(start: ${value}, count: Int(${length})).map { .init(cStruct: $0) }')

object_conversion = Conversion('handle_${name}',
                               ('${value}.withUnsafeHandle { handle_${name} in', '}'),
                               '.init(handle: ${value})')

optional_object_conversion = Conversion('handle_${name}',
                                        ('${value}.withOptionalHandle { handle_${name} in', '}'),
                                        '${value} != nil ? .init(handle: ${value}) : nil')

object_array_conversion =\
    Conversion('buffer_${name}.baseAddress',
               ('${value}.withHandleBufferPointer { buffer_${name} in', '}'),
               'UnsafeBufferPointer(start: ${value}, count: Int(${length})).map { .init(handle: $0) }')

array_length_conversion = Conversion('.init(buffer_${name}.count)')

buffer_conversion = Conversion('${name}.baseAddress')
buffer_length_conversion = Conversion('.init(${name}.count)')

userdata_conversion = Conversion('UserData.passRetained(callback)')
