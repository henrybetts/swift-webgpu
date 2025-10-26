struct Parameter {
    var name: String
    var type: TypeAnnotation
    
    init(data: WebGPUData.Parameter) {
        name = data.name
        type = TypeAnnotation(type: data.type, pointer: data.pointer, isOptional: data.optional)
    }

    mutating func link(model: WebGPUModel) {
        type.link(model: model)
    }
    
    var cName: String {
        return name.camelCased(preservingCasing: true)
    }

    var cCountName: String? {
        return type.isArray ? cName.singularForm + "Count" : nil
    }
    
    var swiftName: String {
        return name.camelCased()
    }
}


typealias Parameters = [Parameter]

extension Parameters {
    init(data: [WebGPUData.Parameter]) {
        self = data.map { Parameter(data: $0) }
    }

    mutating func link(model: WebGPUModel) {
        for index in self.indices {
            self[index].link(model: model)
        }
    }
}
