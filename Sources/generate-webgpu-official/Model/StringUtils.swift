extension String {
    func camelCased(preservingCasing: Bool = false) -> String {
        let string = preservingCasing ? self : self.lowercased()
        let words = string.split(separator: "_")
        let transformedWords = words.prefix(1) + words.dropFirst().map { $0.first!.uppercased() + $0.dropFirst() }
        return transformedWords.joined()
    }

    func pascalCased(preservingCasing: Bool = false) -> String {
        let string = preservingCasing ? self : self.lowercased()
        let words = string.split(separator: "_")
        let transformedWords = words.map { $0.first!.uppercased() + $0.dropFirst() }
        return transformedWords.joined()
    }

    var singularForm: String {
        if self.hasSuffix("ies") {
            return String(self.dropLast(3)) + "y"
        } else if self.hasSuffix("s") {
            return String(self.dropLast(1))
        } else {
            return self
        }
    }
}
