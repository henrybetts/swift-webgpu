class FunctionPointerType: Type {
    let returnTypeName: String?
    let arguments: Record
    
    weak var returnType: Type?
    
    init(name: String, data: FunctionTypeData) {
        returnTypeName = data.returns
        arguments = Record(data: data.args.filter { !$0.tags.contains("upstream") })
        super.init(name: name, data: data)
    }
    
    override func link(model: Model) {
        if let returnTypeName = returnTypeName, returnTypeName != "void" {
            returnType = model.types[returnTypeName]
        }
        arguments.link(model: model)
    }
    
    var isCallback: Bool {
        return arguments.contains { $0.name == "userdata" }
    }
    
    var callbackFunctionName: String {
        return name.camelCased()
    }
    
    var swiftReturnType: String? {
        guard let returnType = returnType else { return nil }
        if returnType.category == .functionPointer {
            return returnType.swiftName + "?"
        }
        return returnType.swiftName
    }
    
    var returnConversion: TypeConversion? {
        guard let returnType = returnType else { return nil }
        switch returnType.category {
        case .enum, .bitmask, .structure, .object:
            return .value
        default:
            return .native
        }
    }
}
