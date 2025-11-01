class ObjectType: Type {
    class Method: FunctionType {
        let objectName: String
        
        init(data: WebGPUData.Function, objectName: String) {
            self.objectName = objectName
            super.init(data: data)
        }
        
        override var cName: String {
            return "wgpu_\(objectName)_\(name)".camelCased(preservingCasing: true)
        }
    }

    let methods: [Method]
    
    init(data: WebGPUData.Object) {
        methods = data.methods.map { Method(data: $0, objectName: data.name) }
        super.init(name: data.name)
    }

    override func link(model: WebGPUModel) {
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
