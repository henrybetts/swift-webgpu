struct TypeAnnotation {
    var type: WebGPUData.`Type`
    var pointer: WebGPUData.Pointer?
    var isOptional: Bool
    
    weak var linkedType: Type?
    
    init(type: WebGPUData.`Type`, pointer: WebGPUData.Pointer?, isOptional: Bool) {
        self.type = type
        self.pointer = pointer
        self.isOptional = isOptional
    }
    
    mutating func link(model: WebGPUModel) {
        switch type {
        case .complex(_, let name), .complexArray(_, let name):
            linkedType = model.type(named: name)
        default:
            break
        }
    }
    
    /// Whether the type is an array.
    var isArray: Bool {
        switch type {
        case .primitiveArray(_), .complexArray(_, _):
            return true
        default:
            return false
        }
    }

    /// Whether the inner type is naturally a pointer (ignoring pointer and array annotations).
    var isInnerTypePointer: Bool {
        switch type {
        case .complex(let complexType, _), .complexArray(let complexType, _):
            return complexType == .object || complexType == .functionType
        default:
            return false
        }
    }
    
    /// Whether the type is represented as a pointer in C. This naturally includes arrays.
    var isPointer: Bool {
        if pointer != nil {
            return true
        }
        
        return isArray || isInnerTypePointer
    }
    
    /// The C representation of the type, without an optional wrapper.
    var unwrappedCType: String {
        let cType: String
        
        switch type {
        case .void:
            switch pointer {
            case .immutable:
                return "UnsafeRawPointer"
            case .mutable:
                return "UnsafeMutableRawPointer"
            case .none:
                return "Void"
            }
            
        case .primitive(let primitive), .primitiveArray(let primitive):
            cType = primitive.cType
            
        case .complex(_, _), .complexArray(_, _), .callback(_):
            cType = linkedType?.cName ?? "Unknown"
        }
        
        if let pointer = pointer {
            let pointerType = isInnerTypePointer ? cType + "?" : cType
            switch pointer {
            case .mutable:
                return "UnsafeMutablePointer<\(pointerType)>"
            case .immutable:
                return "UnsafePointer<\(pointerType)>"
            }
        }
        
        return cType
    }
    
    /// The C representation of the type.
    var cType: String {
        if isPointer {
            return unwrappedCType + "!"
        }
        return unwrappedCType
    }
}


fileprivate extension WebGPUData.`Type`.PrimitiveType {
    /// The C representation of the primitive type.
    var cType: String {
        switch self {
        case .bool:
            return "WGPUBool"
        case .optionalString, .string, .outString:
            return "WGPUStringView"
        case .uint16:
            return "UInt16"
        case .uint32:
            return "UInt32"
        case .uint64:
            return "UInt64"
        case .usize:
            return "Int"
        case .int16:
            return "Int16"
        case .int32:
            return "Int32"
        case .float32, .optionalFloat32:
            return "Float"
        case .float64, .float64Super:
            return "Double"
        }
    }
}
