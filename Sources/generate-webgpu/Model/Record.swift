class RecordMember {
    let name: String
    let typeName: String
    let annotation: Annotation?
    let length: Length
    let defaultValue: String?
    let isOptional: Bool
    
    weak var type: Type?
    
    init(data: RecordMemberData) {
        name = data.name
        typeName = data.type
        annotation = data.annotation
        length = data.length
        defaultValue = data.default
        isOptional = data.optional
    }
    
    func link(model: Model) {
        type = model.types[typeName]
    }
    
    var cName: String {
        return name.camelCased(preservingCasing: true)
    }
    
    var swiftName: String {
        return name.camelCased()
    }
    
    var cType: String {
        guard let type = self.type else { return typeName }
        return type.cName
    }
    
    var swiftType: String {
        guard let type = self.type else { return typeName }
        return type.swiftName
    }
    
    var defaultSwiftValue: String? {
        if let defaultValue = self.defaultValue {
            return type?.swiftValue(from: defaultValue)
        }
        return nil
    }
}


typealias Record = [RecordMember]

extension Record {
    init(data: RecordData) {
        self = data.map { RecordMember(data: $0) }
    }
    
    func link(model: Model) {
        for member in self {
            member.link(model: model)
        }
    }
}
