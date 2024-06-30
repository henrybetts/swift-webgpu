class StructureType: Type {
    let extensible: Extensibility
    let chained: Extensibility
    let members: Record
    
    init(name: String, data: StructureTypeData) {
        extensible = data.extensible
        chained = data.chained
        members = Record(data: data.members.filter { !$0.isUpstream }, context: .structure)
        super.init(name: name, data: data)
    }
    
    override func link(model: Model) {
        members.link(model: model)
    }
    
    var sType: String {
        return "WGPUSType_" + name.pascalCased(preservingCasing: true)
    }
    
    var hasDefaultSwiftInitializer: Bool {
        return members.removingHidden.allSatisfy { $0.defaultSwiftValue != nil }
    }
    
    override func swiftValue(from value: Any) -> String {
        if let value = value as? String {
            let values = value.trimmingCharacters(in: .init(charactersIn: "{}")).split(separator: ",")
            let params = zip(members, values).map { (member, value) -> String in
                let value = value.trimmingCharacters(in: .whitespaces)
                return "\(member.swiftName): \(member.type?.swiftValue(from: value) ?? value)"
            }
            return ".init(\(params.joined(separator: ", ")))"
        }
        return super.swiftValue(from: value)
    }
}
