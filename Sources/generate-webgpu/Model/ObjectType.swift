class Method: FunctionType {
    let objectName: String
    
    init(data: MethodData, objectName: String) {
        self.objectName = objectName
        super.init(name: data.name, data: FunctionTypeData(category: .function, tags: data.tags, returns: data.returns, args: data.args))
    }
    
    var isCallbackSetter: Bool {
        return name.hasPrefix("set ") && name.hasSuffix(" callback") && arguments.count == 2 && arguments[0].isCallback && arguments[1].isUserData
    }
    
    override var cFunctionName: String {
        return "wgpu" + objectName.pascalCased(preservingCasing: true) + name.pascalCased(preservingCasing: true)
    }
}

class ObjectType: Type {
    let methods: [Method]
    
    init(name: String, data: ObjectTypeData) {
        methods = data.methods.filter { $0.isEnabled }.map { Method(data: $0, objectName: name) }
        super.init(name: name, data: data)
    }
    
    override func link(model: Model) {
        for method in methods {
            method.link(model: model)
        }
    }
    
    var referenceFunctionName: String {
        return "wgpu\(name.pascalCased(preservingCasing: true))Reference"
    }
    
    var releaseFunctionName: String {
        return "wgpu\(name.pascalCased(preservingCasing: true))Release"
    }
}
