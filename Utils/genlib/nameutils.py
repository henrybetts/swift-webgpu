def camel_case(name: str) -> str:
    words = name.split()
    return ''.join([words[0]] + [word[0].upper() + word[1:] for word in words[1:]])


def pascal_case(name: str) -> str:
    words = name.split()
    return ''.join([word[0].upper() + word[1:] for word in words])


def swift_safe(name: str) -> str:
    if name in ('repeat', 'internal'):
        return f'`{name}`'
    return name
