@resultBuilder
struct CodeBuilder {
    static func buildExpression(_ expression: String?) -> [String] {
        guard let expression = expression else { return [] }
        return [expression]
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

func indented(@CodeBuilder builder: () -> [String]) -> String {
    return builder()
        .flatMap { $0.split(separator: "\n", omittingEmptySubsequences: false).map { "    " + $0 } }
        .joined(separator: "\n")
}

func block(_ prefix: String? = nil, _ suffix: String? = nil, @CodeBuilder builder: () -> [String]) -> String {
    code {
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
