class FunctionType: Type {
    var arguments: Parameters
    var returnType: TypeAnnotation?
    
    init(data: WebGPUData.Function) {
        arguments = Parameters(data: data.args)
        returnType = data.returns.map { TypeAnnotation(type: $0.type, pointer: $0.pointer, isOptional: $0.optional) }
        super.init(name: data.name)
    }
    
    override func link(model: WebGPUModel) {
        arguments.link(model: model)
        returnType?.link(model: model)
    }

    override var cName: String {
        return "wgpu_\(name)".camelCased(preservingCasing: true)
    }
    
    override var swiftName: String {
        return name.camelCased()
    }

    var hideFirstArgumentLabel: Bool {
        guard let firstArgument = arguments.first else { return false }
        return name.hasSuffix("_" + firstArgument.name)
    }
}
