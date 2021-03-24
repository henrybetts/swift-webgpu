var indent = 0

func print(_ line: String) {
    Swift.print(String(repeating: " ", count: indent) + line)
}

func withIndent(_ body: () -> ()) {
    indent += 2
    body()
    indent -= 2
}

func print(title: String) {
    print(title)
    print(String(repeating: "=", count: title.count))
}

func print(subtitle: String) {
    print(subtitle)
    print(String(repeating: "-", count: subtitle.count))
}

func print(key: String, value: Any) {
    print("\(key): \(value)")
}

func hex<T: BinaryInteger>(_ value: T) -> String {
    return "0x" + String(value, radix: 16, uppercase: false)
}
