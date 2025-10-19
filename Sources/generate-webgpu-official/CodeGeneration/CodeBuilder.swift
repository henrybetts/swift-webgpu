/// A result builder for building arrays of strings, which can then be joined by an appropriate seperator.
@resultBuilder
struct CodeBuilder {
    static func buildExpression(_ expression: [String]) -> [String] {
        return expression
    }
    
    static func buildExpression(_ expression: String) -> [String] {
        return [expression]
    }
    
    static func buildExpression(_ expression: String?) -> [String] {
        guard let expression = expression else { return [] }
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

/// Builds code that is separated by new lines.
func code(@CodeBuilder builder: () -> [String]) -> String {
    return builder().joined(separator: "\n")
}

/// Builds code that is indented by a given number of spaces.
func indented(size: Int = 4, @CodeBuilder builder: () -> [String]) -> [String] {
    let indent = String(repeating: " ", count: size)
    return builder().flatMap { $0.split(separator: "\n", omittingEmptySubsequences: false).map { indent + $0 } }
}

/// Builds a code block in the form of:
/// <outerPrefix> { <innerPrefix>
///     <innerCode>
/// }
/// 
/// If condition is false, just builds the inner code without the surrounding block.
func block(_ outerPrefix: String? = nil, _ innerPrefix: String? = nil, condition: Bool = true, @CodeBuilder innerCode: () -> [String]) -> String {
    guard condition else { return code(builder: innerCode) }
    return code {
        line {
            if let outerPrefix = outerPrefix {
                outerPrefix
                " "
            }
            "{"
            if let innerPrefix = innerPrefix {
                " "
                innerPrefix
            }
        }
        indented(builder: innerCode)
        "}"
    }
}

/// Builds a comma-separated list of strings.
func commaSeparated(@CodeBuilder builder: () -> [String]) -> String {
    return builder().joined(separator: ", ")
}

/// Builds a single line from multiple strings.
func line(@CodeBuilder builder: () -> [String]) -> String {
    return builder().joined()
}

extension String {
    /// Returns a string that is safe to use as a Swift identifier by escaping reserved keywords.
    var escaped: String {
        if (["repeat", "internal", "false", "true"].contains(self)) {
            return "`\(self)`"
        }
        return self
    }
}
