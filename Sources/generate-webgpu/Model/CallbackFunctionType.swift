class CallbackFunctionType: Type {
    let arguments: Record
    
    init(name: String, data: CallbackFunctionTypeData) {
        arguments = Record(data: data.args.filter { $0.isEnabled }, context: .function)
        super.init(name: name, data: data)
    }
    
    override func link(model: Model) {
        arguments.link(model: model)
    }
    
    var callbackFunctionName: String {
        return name.camelCased()
    }
}
