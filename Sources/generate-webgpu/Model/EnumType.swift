struct EnumValue {
    let name: String
    let value: Int
    let requiresPrefix: Bool
    
    var swiftName: String {
        let name = requiresPrefix ? "type " + self.name : self.name
        return name.camelCased()
    }
}


class EnumType: Type {
    let requiresPrefix: Bool
    let values: [EnumValue]
    
    init(name: String, data: EnumTypeData) {
        let values = data.values.filter { !$0.tags.contains("upstream") }
        
        let requiresPrefix = values.contains { $0.name.first!.isNumber }
        self.requiresPrefix = requiresPrefix
        
        self.values = values.map { EnumValue(name: $0.name, value: $0.value, requiresPrefix: requiresPrefix) }
        super.init(name: name, data: data)
    }
    
    override func swiftValue(from value: Any) -> String {
        if let value = value as? String {
            let name = requiresPrefix ? "type " + value : value
            return "." + name.camelCased()
        }
        return super.swiftValue(from: value)
    }
    
    var isStatus: Bool {
        return values.contains { $0.name == "success" }
    }
}
