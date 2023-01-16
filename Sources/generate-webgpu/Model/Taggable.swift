protocol Taggable {
    var tags: [String] { get }
}

extension Taggable {
    var isDeprecated: Bool {
        return tags.contains { $0 == "deprecated" }
    }
}
