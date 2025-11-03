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
}
