protocol Taggable {
    var tags: Set<String> { get }
}

extension Taggable {
    var isEnabled: Bool {
        if tags.isEmpty {
            return true
        }
        // TODO: This could be configurable
        return !tags.isDisjoint(with: ["dawn", "native", "deprecated"])
    }
    
    var isDeprecated: Bool {
        return tags.contains("deprecated")
    }
}
