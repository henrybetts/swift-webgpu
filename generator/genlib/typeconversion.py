from jinja2 import Template


class Conversion:
    def __init__(self, c_value_template: str):
        self.c_value_template = Template(c_value_template)

    def get_c_value(self, swift_value: str) -> str:
        return self.c_value_template.render(value=swift_value)


implicit_conversion = Conversion('{{ value }}')

enum_conversion = Conversion('{{ value }}.cValue')

bitmask_conversion = Conversion('{{ value }}.rawValue')
