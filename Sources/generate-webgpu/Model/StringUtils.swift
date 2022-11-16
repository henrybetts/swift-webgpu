extension String {
    func camelCased(preservingCasing: Bool = false) -> String {
        let string = preservingCasing ? self : self.lowercased()
        let words = string.split(separator: " ")
        let transformedWords = words.prefix(1) + words.dropFirst().map { $0.first!.uppercased() + $0.dropFirst() }
        return transformedWords.joined()
    }

    func pascalCased(preservingCasing: Bool = false) -> String {
        let string = preservingCasing ? self : self.lowercased()
        let words = string.split(separator: " ")
        let transformedWords = words.map { $0.first!.uppercased() + $0.dropFirst() }
        return transformedWords.joined()
    }
}
