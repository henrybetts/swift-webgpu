class StructType: Type {
    let type: WebGPUData.Struct.`Type`
    
    init(data: WebGPUData.Struct) {
        type = data.type
        super.init(name: data.name)
    }
    
    var sType: String {
        return "WGPUSType_" + name.pascalCased(preservingCasing: true)
    }
}
