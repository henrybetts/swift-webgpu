class CallbackType: Type {
    var style: WebGPUData.Callback.Style
    var arguments: Parameters
    
    init(data: WebGPUData.Callback) {
        style = data.style
        arguments = Parameters(data: data.args)
        super.init(name: data.name)
    }
    
    override func link(model: WebGPUModel) {
        arguments.link(model: model)
    }
    
    override var cName: String {
        return "WGPU" + name.pascalCased(preservingCasing: true) + "Callback"
    }
    
    override var swiftName: String {
        return name.pascalCased() + "Callback"
    }
    
    var adapterFunctionName: String {
        return name.camelCased() + "Callback"
    }
    
    var cInfoName: String {
        return cName + "Info"
    }
    
    var isFailable: Bool {
        // failable callbacks should have between 1 and 3 arguments:
        // - status only
        // - status + success type
        // - status + error message
        // - status + success type + error message
        guard arguments.count > 0 && arguments.count <= 3 else {
            return false
        }
        
        // should start with a "status-like" enum
        guard (arguments[0].type.linkedType as? EnumType)?.isStatus == true else {
            return false
        }
        
        // if there is a 3rd argument, it must be a message
        guard arguments.count < 3 || arguments[2].name == "message" else {
            return false
        }
        
        return true
    }
}
