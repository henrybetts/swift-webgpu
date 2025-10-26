class ObjectType: Type {
    
    init(data: WebGPUData.Object) {
        super.init(name: data.name)
    }
    
    var referenceFunctionName: String {
        return "wgpu\(name.pascalCased(preservingCasing: true))Reference"
    }
    
    var releaseFunctionName: String {
        return "wgpu\(name.pascalCased(preservingCasing: true))Release"
    }
}
