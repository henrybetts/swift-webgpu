class EnumType: Type {
    struct Entry {
        let name: String
        let value: Int
        let requiresPrefix: Bool
        
        var swiftName: String {
            let name = requiresPrefix ? "type_" + self.name : self.name
            return name.camelCased()
        }
    }

    let requiresPrefix: Bool
    let entries: [Entry]
    
    init(data: WebGPUData.Enum) {
        // We can't have enum cases that start with a number, so if any do, we add a prefix to all cases for consistency.
        let requiresPrefix = data.entries.contains { $0?.name.first!.isNumber ?? false }
        self.requiresPrefix = requiresPrefix
        
        self.entries = data.entries.enumerated().compactMap { index, entry in
            guard let entry = entry else { return nil }
            return Entry(name: entry.name, value: entry.value ?? index, requiresPrefix: requiresPrefix)
        }
        
        super.init(name: data.name)
    }

    var hasUndefinedEntry: Bool {
        return entries.contains { $0.name == "undefined" }
    }
    
    var isStatus: Bool {
        return entries.contains { $0.name == "success" }
    }
    
    override func swiftValue(from value: String) -> String? {
        let name = requiresPrefix ? "type_" + value : value
        return "." + name.camelCased()
    }
}
