/// A type annotation for a parameter or return value.
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
    
    /// Whether the type will be an optional in Swift, either because of an explicit optional annotation, or because the type is naturally optional.
    var isSwiftTypeOptional: Bool {
        if isOptional {
            return true
        }
        
        if pointer != nil {
            return false
        }
        
        switch type {
        case .primitive(let primitiveType):
            return primitiveType.isSwiftTypeOptional
        case .complex(.enum, "optional_bool"):
            return true
        default:
            return false
        }
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
    
    /// The Swift representation of the type without an optional wrapper, or nil if no Swift representation is supported.
    var unwrappedSwiftTypeIfSupported: String? {
        // don't attempt to convert mutable types
        if pointer == .mutable {
            return nil
        }
        
        // don't attempt to convert non-array pointers, except for struct types
        if pointer == .immutable && !isArray {
            guard case .complex(.struct, _) = type else {
                return nil
            }
        }
        
        switch type {
        case .void:
            return "Void"
        case .primitive(let primitiveType):
            return primitiveType.unwrappedSwiftType
        case .primitiveArray(let primitiveType):
            return "[\(primitiveType.swiftType)]"
        case .complex(.enum, "optional_bool"):
            return "Bool"
        case .complex(_, _), .callback(_):
            return linkedType?.swiftName ?? "Unknown"
        case .complexArray(_, _):
            return "[\(linkedType?.swiftName ?? "Unknown")]"
        }
    }
    
    /// The Swift representation of the type without an optional wrapper.
    var unwrappedSwiftType: String {
        return unwrappedSwiftTypeIfSupported ?? unwrappedCType
    }
    
    /// The Swift representation of the type.
    var swiftType: String {
        if let unwrappedSwiftType = unwrappedSwiftTypeIfSupported {
            return isSwiftTypeOptional ? unwrappedSwiftType + "?" : unwrappedSwiftType
        } else {
            return cType
        }
    }
    
    /// The conversion strategy between C and Swift representations.
    var conversion: TypeConversion {
        // no conversion for mutable types
        if pointer == .mutable {
            return .implicit
        }
        
        // no conversion for non-array pointers, except for struct types
        if pointer == .immutable && !isArray {
            if case .complex(.struct, _) = type {
                return .pointerWithClosure
            } else {
                return .implicit
            }
        }
        
        switch type {
        case .void:
            return .implicit
        case .primitive(let primitiveType):
            return primitiveType.conversion
        case .complex(let complexType, _):
            return complexType.conversion
        case .primitiveArray(_), .complexArray(_, _):
            return .valueWithClosure
        case .callback(_):
            return .implicit
        }
    }
}

/// The strategy for converting between C and Swift representations of a type.
enum TypeConversion {
    /// No conversion needed.
    case implicit

    /// Convert via a simple value transform function.
    case value

    /// Same as `value`, but when going from Swift to C, a closure is needed to manage temporary storage.
    case valueWithClosure

    /// Convert via a pointer and a closure to manage temporary storage when going from Swift to C.
    case pointerWithClosure
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
    
    /// Whether the Swift representation of the primitive type is optional.
    var isSwiftTypeOptional: Bool {
        switch self {
        case .optionalString, .optionalFloat32:
            return true
        default:
            return false
        }
    }
    
    /// The Swift representation of the primitive type without an optional wrapper.
    var unwrappedSwiftType: String {
        switch self {
        case .bool:
            return "Bool"
        case .optionalString, .string, .outString:
            return "String"
        default:
            return cType
        }
    }
    
    /// The Swift representation of the primitive type.
    var swiftType: String {
        if isSwiftTypeOptional {
            return unwrappedSwiftType + "?"
        } else {
            return unwrappedSwiftType
        }
    }
    
    /// The conversion strategy between C and Swift representations of the primitive type.
    var conversion: TypeConversion {
        switch self {
        case .bool, .optionalFloat32:
            return .value
        case .optionalString, .string, .outString:
            return .valueWithClosure
        default:
            return .implicit
        }
    }
}

fileprivate extension WebGPUData.`Type`.ComplexType {
    /// The conversion strategy between C and Swift representations of the complex type.
    var conversion: TypeConversion {
        switch self {
        case .enum, .bitflag:
            return .value
        case .struct, .object:
            return .valueWithClosure
        default:
            return .implicit
        }
    }
}
