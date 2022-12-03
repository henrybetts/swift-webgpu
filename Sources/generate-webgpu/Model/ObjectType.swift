class ObjectType: Type {
    init(name: String, data: ObjectTypeData) {
        super.init(name: name, data: data)
    }
    
    var referenceMethodName: String {
        return "wgpu\(name.pascalCased(preservingCasing: true))Reference"
    }
    
    var releaseMethodName: String {
        return "wgpu\(name.pascalCased(preservingCasing: true))Release"
    }
}
