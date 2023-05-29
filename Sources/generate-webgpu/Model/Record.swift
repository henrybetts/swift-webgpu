enum TypeConversion {
    case native
    case value
    case valueWithClosure
    case pointerWithClosure
    case array
    case nativeArray
    case length
    case callback
    case userData
}

class RecordMember {
    let name: String
    let typeName: String
    let annotation: Annotation?
    let length: Length
    let defaultValue: String?
    let isOptional: Bool
    
    weak var type: Type!
    
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
        type = model.type(named: typeName)
    }
    
    var cName: String {
        return name.camelCased(preservingCasing: true)
    }
    
    var swiftName: String {
        return name.camelCased()
    }
    
    var cType: String {
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
        
        if type.category == .object || type.category == .functionPointer {
            return type.cName + "!"
        }
        
        return type.cName
    }
    
    var isString: Bool {
        // TODO: Should check if length == .string, but dawn.json does not always specify this currently
        return annotation == .pointer && typeName == "char"
    }
    
    var isArray: Bool {
        return annotation == .pointer && length != .single && length != .string
    }
    
    var isUserData: Bool {
        return name == "userdata" && typeName == "void" && annotation == .mutablePointer
    }
    
    var isCallback: Bool {
        return name == "callback" && (type as? FunctionPointerType)?.isCallback == true
    }
    
    var isHidden: Bool {
        return (parentMember?.isArray ?? false) || isUserData
    }
    
    var swiftType: String {
        var swiftType: String
        
        if isString {
            swiftType = "String"
        
        } else if isArray {
            swiftType = type.name == "void" ? "UnsafeRawBufferPointer" : "[\(type.swiftName)]"
            
        } else if annotation == .pointer && type.category == .structure {
            swiftType = type.swiftName
            
        } else if annotation == nil && !(type.category == .functionPointer && !isCallback) {
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
        if isString {
            return .valueWithClosure
        }
        
        if isArray {
            return type.category == .native ? .nativeArray : .array
        }
        
        if parentMember?.isArray == true {
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
        
        if annotation == nil && (type.category == .enum || type.category == .bitmask) {
            return .value
        }
        
        if isCallback {
            return .callback
        }
        
        if isUserData {
            return .userData
        }
        
        return .native
    }
    
    var defaultSwiftValue: String? {
        if let defaultValue = defaultValue, defaultValue != "nullptr" {
            return type?.swiftValue(from: defaultValue)
        }
        
        if isArray && lengthMember?.defaultValue == "0" {
            return "[]"
        }
        
        if isOptional || defaultValue == "nullptr" {
            return "nil"
        }
        
        if annotation == .none, let type = type as? StructureType, type.hasDefaultSwiftInitializer {
            return "\(type.swiftName)()"
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
    
    var removingHidden: Record {
        return filter { !$0.isHidden }
    }
}
