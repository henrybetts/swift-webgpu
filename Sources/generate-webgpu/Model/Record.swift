enum TypeConversion {
    case implicit
    case explicit
    case array
}

class RecordMember {
    let name: String
    let typeName: String
    let annotation: Annotation?
    let length: Length
    let defaultValue: String?
    let isOptional: Bool
    
    weak var type: Type?
    
    weak var lengthMember: RecordMember?
    weak var parentMember: RecordMember?
    
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
        
        if annotation == .pointer {
            return type.name == "void" ? "UnsafeRawPointer!" : "UnsafePointer<\(type.cName)>!"
        }
        
        if annotation == .mutablePointer {
            return type.name == "void" ? "UnsafeMutableRawPointer!" : "UnsafeMutablePointer<\(type.cName)>!"
        }
        
        return type.cName
    }
    
    var swiftType: String {
        guard let type = self.type else { return typeName }
        
        var swiftType: String
        
        if annotation == .pointer && length != .single {
            if type.name == "char" && length == .string {
                swiftType = "String"
            } else {
                swiftType = type.name == "void" ? "UnsafeRawBufferPointer" : "[\(type.swiftName)]"
            }
        
        } else if annotation == nil || (annotation == .pointer && type.category == .structure) {
            swiftType = type.swiftName
        
        } else {
            return cType
        }
        
        if isOptional {
            swiftType += "?"
        }
        
        return swiftType
        
    }
    
    var typeConversion: TypeConversion {
        guard let type = self.type else { return .implicit }
        
        if annotation == .pointer && length != .single {
            if type.name == "char" && length == .string {
                return .explicit
            } else {
                return .array
            }
        }
        
        if annotation == .pointer && type.category == .structure {
            return .explicit
        }
        
        if annotation == nil && type.category != .native {
            return .explicit
        }
        
        return .implicit
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
        
        for member in self {
            if case .member(let length) = member.length {
                if let lengthMember = self.first(where: { $0.name == length }) {
                    member.lengthMember = lengthMember
                    lengthMember.parentMember = member
                }
            }
        }
    }
    
    func link(model: Model) {
        for member in self {
            member.link(model: model)
        }
    }
}
