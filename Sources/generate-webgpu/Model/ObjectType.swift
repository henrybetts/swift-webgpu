class Method: FunctionType {
    let objectName: String
    
    init(data: MethodData, objectName: String) {
        self.objectName = objectName
        super.init(name: data.name, data: FunctionTypeData(category: .function, tags: data.tags, returns: data.returns, args: data.args))
    }
    
    override var cFunctionName: String {
        return "wgpu" + objectName.pascalCased(preservingCasing: true) + name.pascalCased(preservingCasing: true)
    }
    
    var isEnabled: Bool {
        // TODO: Temporary patch for dawn bug
        if objectName == "surface" && name == "set label" {
            return false
        }
        return super.isEnabled
    }
}

class ObjectType: Type {
    let methods: [Method]
    
    init(name: String, data: ObjectTypeData) {
        methods = data.methods.map { Method(data: $0, objectName: name) }.filter { $0.isEnabled }
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
