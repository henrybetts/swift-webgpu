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
    
    var isCallback: Bool {
        return category == .functionPointer && name.hasSuffix(" callback") && arguments.last?.isUserData == true
    }
    
    var isRequestCallback: Bool {
        if isCallback,
           returnType == nil,
           let statusArg = arguments.first,
           statusArg.name == "status",
           (statusArg.type as? EnumType)?.isStatus == true {
            if arguments.count < 4 {
                return true
            } else if arguments.count == 4 {
                return arguments[2].isString && arguments[2].name == "message"
            }
        }
        return false
    }
    
    var isRequest: Bool {
        guard arguments.count >= 2, returnType == nil else { return false }
        
        let callbackArg = arguments[arguments.count - 2]
        let userDataArg = arguments[arguments.count - 1]
        
        return callbackArg.isCallback && (callbackArg.type as! FunctionPointerType).isRequestCallback && userDataArg.isUserData
    }
    
    var callbackFunctionName: String {
        return name.camelCased()
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
