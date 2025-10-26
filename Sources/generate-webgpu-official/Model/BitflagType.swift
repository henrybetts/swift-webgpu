class BitflagType: Type {    
    struct Entry {
        let name: String
        let requiresPrefix: Bool
        
        var swiftName: String {
            let name = requiresPrefix ? "type_" + self.name : self.name
            return name.camelCased()
        }
    }

    let requiresPrefix: Bool
    let entries: [Entry]
    
    init(data: WebGPUData.Bitflag) {
        // We can't have entries that start with a number, so if any do, we add a prefix to all entries for consistency.
        let requiresPrefix = data.entries.contains { $0.name.first!.isNumber }
        self.requiresPrefix = requiresPrefix

        self.entries = data.entries.map { Entry(name: $0.name, requiresPrefix: requiresPrefix) }
        super.init(name: data.name)
    }
    
    func cName(of entry: Entry) -> String {
        return cName + "_" + entry.name.pascalCased(preservingCasing: true)
    }
}
