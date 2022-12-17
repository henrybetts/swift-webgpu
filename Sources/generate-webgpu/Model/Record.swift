enum TypeConversion {
    case native
    case value
    case valueWithClosure
    case pointerWithClosure
    case array
    case nativeArray
    case length
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
        
        if let annotation = annotation {
            switch annotation {
            case .pointer:
                return type.name == "void" ? "UnsafeRawPointer!" : "UnsafePointer<\(type.cName)>!"
            case .mutablePointer:
                return type.name == "void" ? "UnsafeMutableRawPointer!" : "UnsafeMutablePointer<\(type.cName)>!"
            case .pointerToPointer:
                return type.name == "void" ? "UnsafePointer<UnsafeRawPointer?>!" : "UnsafePointer<UnsafePointer<\(type.cName)>?>!"
            }
        }
        
        return type.cName
    }
    
    var isSwiftString: Bool {
        return annotation == .pointer && length == .string && typeName == "char"
    }
    
    var isSwiftArray: Bool {
        return annotation == .pointer && length != .single && length != .string
    }
    
    var swiftType: String {
        guard let type = self.type else { return typeName }
        
        var swiftType: String
        
        if isSwiftString {
            swiftType = "String"
        
        } else if isSwiftArray {
            swiftType = type.name == "void" ? "UnsafeRawBufferPointer" : "[\(type.swiftName)]"
        
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
        guard let type = self.type else { return .native }
        
        if isSwiftString {
            return .valueWithClosure
        }
        
        if isSwiftArray {
            return type.category == .native ? .nativeArray : .array
        }
        
        if parentMember?.isSwiftArray == true {
            return .length
        }
        
        if type.category == .structure && annotation == .pointer {
            return .pointerWithClosure
        }
        
        if type.category == .structure && annotation == nil {
            return .valueWithClosure
        }
        
        if type.category == .object && annotation == nil {
            return .valueWithClosure
        }
        
        if annotation == nil && type.category != .native {
            return .value
        }
        
        return .native
    }
    
    var defaultSwiftValue: String? {
        if let defaultValue = defaultValue, defaultValue != "nullptr" {
            return type?.swiftValue(from: defaultValue)
        }
        
        if isSwiftArray && lengthMember?.defaultValue == "0" {
            return "[]"
        }
        
        if isOptional {
            return "nil"
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
