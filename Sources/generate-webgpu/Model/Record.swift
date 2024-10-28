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

enum RecordContext {
    case structure
    case function
}

class RecordMember {
    let name: String
    let typeName: String
    let annotation: Annotation?
    let length: Length
    let defaultValue: String?
    private let _isOptional: Bool
    
    let context: RecordContext
    
    weak var type: Type!
    
    weak var lengthMember: RecordMember?
    weak var parentMember: RecordMember?
    
    init(data: RecordMemberData, context: RecordContext) {
        name = data.name
        typeName = data.type
        annotation = data.annotation
        length = data.length
        defaultValue = data.default
        _isOptional = data.optional
        self.context = context
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
    
    var isOptional: Bool {
        return _isOptional || defaultValue == "nullptr"
    }
    
    var isVoidPointer: Bool {
        return (typeName == "void" && annotation == .pointer) || typeName == "void const *"
    }
    
    var isMutableVoidPointer: Bool {
        return (typeName == "void" && annotation == .mutablePointer) || typeName == "void *"
    }
    
    var isString: Bool {
        return annotation == .none && typeName == "string view"
    }
    
    var isArray: Bool {
        return (annotation == .pointer || isVoidPointer) && length != .single
    }
    
    var isUserData: Bool {
        return context == .function && name == "userdata" && isMutableVoidPointer
    }
    
    var isCallback: Bool {
        return context == .function && name.hasSuffix("callback") && (type as? FunctionPointerType)?.isCallback == true
    }
    
    var isHidden: Bool {
        return (parentMember?.isArray ?? false) || isUserData
    }
    
    var unwrappedCType: String {
        if isVoidPointer {
            return "UnsafeRawPointer"
        }
        
        if isMutableVoidPointer {
            return "UnsafeMutableRawPointer"
        }
        
        if let annotation = annotation {
            switch annotation {
            case .pointer:
                return "UnsafePointer<\(type.cName)>"
            case .mutablePointer:
                return "UnsafeMutablePointer<\(type.cName)>"
            case .pointerToPointer:
                return "UnsafePointer<UnsafePointer<\(type.cName)>?>"
            }
        }
        
        return type.cName
    }
    
    var cType: String {
        if annotation != nil || isVoidPointer || isMutableVoidPointer || type.category == .object || type.category == .functionPointer {
            return unwrappedCType + "!"
        }
        return unwrappedCType
    }
    
    var unwrappedSwiftType: String {
        if isString {
            return "String"
        
        } else if isArray {
            return isVoidPointer ? "UnsafeRawBufferPointer" : "[\(type.swiftName)]"
            
        } else if annotation == .pointer && type.category == .structure {
            return type.swiftName
            
        } else if type.category == .functionPointer && !isCallback {
            return unwrappedCType
            
        } else if annotation == nil && !isVoidPointer && !isMutableVoidPointer {
            return type.swiftName
        
        } else {
            return unwrappedCType
        }
    }
    
    var swiftType: String {
        if isOptional && !(isArray && !isVoidPointer) {
            return unwrappedSwiftType + "?"
        }
        return unwrappedSwiftType
    }
    
    var typeConversion: TypeConversion {
        if isString {
            return .valueWithClosure
        }
        
        if isArray {
            return type.category == .native && typeName != "bool" ? .nativeArray : .array
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
        
        if annotation == nil && typeName == "bool" {
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
        
        if isArray && (isOptional || lengthMember?.defaultValue == "0") {
            return isVoidPointer ? "nil" : "[]"
        }
        
        if isOptional {
            return "nil"
        }
        
        if annotation == .none, !isString, let type = type as? StructureType, type.hasDefaultSwiftInitializer {
            return "\(type.swiftName)()"
        }
        
        return nil
    }
}


typealias Record = [RecordMember]

extension Record {
    init(data: RecordData, context: RecordContext) {
        self = data.map { RecordMember(data: $0, context: context) }
        
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
