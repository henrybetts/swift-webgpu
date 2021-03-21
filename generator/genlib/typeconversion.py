from jinja2 import Template
from typing import Tuple


class Conversion:
    def __init__(self, c_value_template: str, closure_template: Tuple[str, str] = None):
        self.c_value_template = Template(c_value_template)
        self.closure_template = (Template(closure_template[0]),
                                 Template(closure_template[1])) if closure_template else None

    @staticmethod
    def _render(template: Template, name: str, value: str = None, prefix: str = None):
        if not value:
            value = prefix + name if prefix else name
        return template.render(name=name, value=value)

    def get_c_value(self, name: str, value: str = None, prefix: str = None) -> str:
        return self._render(self.c_value_template, name, value, prefix)

    def get_closure_head(self, name: str, value: str = None, prefix: str = None) -> str:
        return self._render(self.closure_template[0], name, value, prefix)

    def get_closure_tail(self, name: str, value: str = None, prefix: str = None) -> str:
        return self._render(self.closure_template[1], name, value, prefix)

    @property
    def requires_closure(self) -> bool:
        return self.closure_template is not None


implicit_conversion = Conversion('{{ value }}')

implicit_array_conversion = Conversion('buffer_{{ name }}.baseAddress',
                                       ('{{ value }}.withUnsafeBufferPointer { buffer_{{ name }} in', '}'))

enum_conversion = Conversion('{{ value }}.cValue')

enum_array_conversion = Conversion('buffer_{{ name }}.baseAddress',
                                   ('{{ value }}.map { $0.cValue }.withUnsafeBufferPointer { buffer_{{ name }} in',
                                    '}'))

bitmask_conversion = Conversion('{{ value }}.rawValue')

string_conversion = Conversion('cString_{{ name }}',
                               ('{{ value }}.withCString { cString_{{ name }} in', '}'))

optional_string_conversion = Conversion('cString_{{ name }}',
                                        ('{{ value }}.withOptionalCString { cString_{{ name }} in', '}'))

struct_conversion = Conversion('cStruct_{{ name }}.pointee',
                               ('{{ value }}.withCStruct { cStruct_{{ name }} in', '}'))

optional_struct_conversion = Conversion('cStruct_{{ name }}',
                                        ('{{ value }}.withOptionalCStruct { cStruct_{{ name }} in', '}'))

struct_array_conversion = Conversion('buffer_{{ name }}.baseAddress',
                                     ('{{ value }}.withCStructBufferPointer { buffer_{{ name }} in', '}'))

object_conversion = Conversion('{{ value }}.object')

optional_object_conversion = Conversion('{{ value }}?.object')

object_array_conversion = Conversion('buffer_{{ name }}.baseAddress',
                                     ('{{ value }}.map { $0.object }.withUnsafeBufferPointer { buffer_{{ name }} in ',
                                      '}'))
