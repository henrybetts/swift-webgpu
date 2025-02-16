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
    
    var isRequestCallback: Bool {
        if let statusArg = arguments.first,
           statusArg.name == "status",
           (statusArg.type as? EnumType)?.isStatus == true {
            if arguments.count < 3 {
                return true
            } else if arguments.count == 3 {
                return arguments[2].isString && arguments[2].name == "message"
            }
        }
        return false
    }
}
