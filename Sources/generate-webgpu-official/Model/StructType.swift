class StructType: Type {
    let type: WebGPUData.Struct.`Type`
    var members: Parameters
    var needsZeroInitializer = false
    
    init(data: WebGPUData.Struct) {
        type = data.type
        members = Parameters(data: data.members)
        super.init(name: data.name)
    }

    override func link(model: WebGPUModel) {
        members.link(model: model)
        
        for structType in model.structs {
            for member in structType.members {
                if member.type.type == .complex(.struct, name) && member.type.defaultValue?.stringValue == "zero" {
                    // generate a "zero initializer" for types that are expected to need it
                    // TODO: This isn't particularly intuitive. Should probably convert type annotations with a "zero" default to optional types.
                    needsZeroInitializer = true
                }
            }
        }
    }
    
    var sType: String {
        return "WGPUSType_" + name.pascalCased(preservingCasing: true)
    }

    var hasDefaultInitializer: Bool {
        return members.allSatisfy { $0.type.defaultSwiftValue != nil }
    }
    
    override func swiftValue(from value: String) -> String? {
        if value == "zero" {
            return ".zero"
        }
        return nil
    }
}
