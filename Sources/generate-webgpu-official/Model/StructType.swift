class StructType: Type {
    let type: WebGPUData.Struct.`Type`
    var members: Parameters
    
    init(data: WebGPUData.Struct) {
        type = data.type
        members = Parameters(data: data.members)
        super.init(name: data.name)
    }

    override func link(model: WebGPUModel) {
        members.link(model: model)
    }
    
    var sType: String {
        return "WGPUSType_" + name.pascalCased(preservingCasing: true)
    }
}
