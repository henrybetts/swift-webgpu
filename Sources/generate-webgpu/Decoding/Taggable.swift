protocol Taggable {
    var tags: Set<String> { get }
}

extension Taggable {
    var isEnabled: Bool {
        if tags.isEmpty {
            return true
        }
        // TODO: This could be configurable
        return tags.isSubset(of: ["native", "deprecated"])
    }
    
    var isUpstream: Bool {
        return tags.contains("upstream")
    }
    
    var isDeprecated: Bool {
        return tags.contains("deprecated")
    }
}
