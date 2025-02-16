class FunctionPointerType: Type {
    let returnTypeName: String?
    let arguments: Record
    
    weak var returnType: Type?
    
    init(name: String, data: FunctionTypeData) {
        returnTypeName = data.returns
        arguments = Record(data: data.args.filter { $0.isEnabled }, context: .function)
        super.init(name: name, data: data)
    }
    
    override func link(model: Model) {
        if let returnTypeName = returnTypeName, returnTypeName != "void" {
            returnType = model.type(named: returnTypeName)
        }
        arguments.link(model: model)
    }
    
    var isGetter: Bool {
        return returnType != nil && arguments.isEmpty && name.hasPrefix("get ")
    }
    
    var isExtensibleGetter: Bool {
        // TODO: Return type may be bool
        return arguments.count == 1 && arguments[0].annotation == .mutablePointer && (arguments[0].type as? StructureType)?.extensible == .out && name.hasPrefix("get ")
    }
    
    var isEnumerator: Bool {
        return returnTypeName == "size_t" && arguments.count == 1 && arguments[0].annotation == .mutablePointer && name.hasPrefix("enumerate ")
    }
    
    var isRequest: Bool {
        if returnType?.name == "future",
           let callbackInfo = arguments.last?.type as? CallbackInfoType,
           (callbackInfo.callbackMember.type as! CallbackFunctionType).isRequestCallback {
            return true
        }
        return false
    }
    
    var swiftReturnType: String? {
        if isExtensibleGetter {
            return arguments[0].type.swiftName
        }
        
        if isEnumerator {
            return "[\(arguments[0].type.swiftName)]"
        }
        
        guard let returnType = returnType else { return nil }
        if returnType.category == .functionPointer {
            return returnType.swiftName + "?"
        }
        return returnType.swiftName
    }
    
    var returnConversion: TypeConversion? {
        if isExtensibleGetter {
            return .value
        }
        
        if isEnumerator {
            switch arguments[0].type.category {
            case .enum, .bitmask, .structure, .object:
                return .array
            default:
                return .nativeArray
            }
        }
        
        guard let returnType = returnType else { return nil }
        switch returnType.category {
        case .enum, .bitmask, .structure, .object:
            return .value
        default:
            return returnType.name == "bool" ? .value : .native
        }
    }
}
