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
}
