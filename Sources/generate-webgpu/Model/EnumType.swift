struct EnumValue: Taggable {
    let name: String
    let swiftName: String
    let tags: Set<String>
    let value: Int
    
    init(data: EnumValueData, requiresPrefix: Bool) {
        name = data.name
        swiftName = (requiresPrefix ? "type " + name : name).camelCased()
        
        tags = data.tags
        
        let prefix = tags.contains("native") ? 0x0001_0000 : 0
        value = prefix + data.value
    }
}


class EnumType: Type {
    let requiresPrefix: Bool
    let values: [EnumValue]
    
    init(name: String, data: EnumTypeData) {
        let values = data.values.filter { $0.isEnabled }
        
        let requiresPrefix = values.contains { $0.name.first!.isNumber }
        self.requiresPrefix = requiresPrefix
        
        self.values = values.map { EnumValue(data: $0, requiresPrefix: requiresPrefix) }
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
