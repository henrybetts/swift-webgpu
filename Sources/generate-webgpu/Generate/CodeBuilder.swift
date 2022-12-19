@resultBuilder
struct CodeBuilder {
    static func buildExpression(_ expression: [String]) -> [String] {
        return expression
    }
    
    static func buildExpression(_ expression: String) -> [String] {
        return [expression]
    }
    
    static func buildExpression(_ expression: ()) -> [String] {
        return []
    }
    
    static func buildBlock(_ components: [String]...) -> [String] {
        return components.flatMap { $0 }
    }
    
    static func buildOptional(_ component: [String]?) -> [String] {
        return component ?? []
    }
    
    static func buildEither(first component: [String]?) -> [String] {
        return component ?? []
    }
    
    static func buildEither(second component: [String]?) -> [String] {
        return component ?? []
    }
    
    static func buildArray(_ components: [[String]]) -> [String] {
        return components.flatMap { $0 }
    }
}

func code(@CodeBuilder builder: () -> [String]) -> String {
    return builder().joined(separator: "\n")
}

func indented(size: Int = 4, @CodeBuilder builder: () -> [String]) -> [String] {
    let indent = String(repeating: " ", count: size)
    return builder().flatMap { $0.split(separator: "\n", omittingEmptySubsequences: false).map { indent + $0 } }
}

func block(_ prefix: String? = nil, _ suffix: String? = nil, condition: Bool = true, @CodeBuilder builder: () -> [String]) -> String {
    guard condition else { return code(builder: builder) }
    return code {
        line {
            if let prefix = prefix {
                prefix
                " "
            }
            "{"
            if let suffix = suffix {
                " "
                suffix
            }
        }
        indented(builder: builder)
        "}"
    }
}

func commaSeparated(@CodeBuilder builder: () -> [String]) -> String {
    return builder().joined(separator: ", ")
}

func line(@CodeBuilder builder: () -> [String]) -> String {
    return builder().joined()
}

extension String {
    func swiftSafe() -> String {
        if (["repeat", "internal"].contains(self)) {
            return "`\(self)`"
        }
        return self
    }
}
