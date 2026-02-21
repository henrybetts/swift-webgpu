func applyPatches(to data: inout WebGPUData) {
    /*
    Mapped Range functions can fail and their return type should be marked as optional.
    */
    data.patch(object: "buffer", method: "get_mapped_range") { method in
        method.returns?.optional = true
    }
    
    data.patch(object: "buffer", method: "get_const_mapped_range") { method in
        method.returns?.optional = true
    }

    /*
    Some arrays should be optional.
    All arrays can technically be nullable at the C level, but in some cases a user is expected to provide a value, so
    we can't make all arrays optional by default. Ideally webgpu.yml should express this.
    */
    data.patch(struct: "device_descriptor", member: "required_features") { member in
        member.optional = true
    }
    
    data.patch(struct: "texture_descriptor", member: "view_formats") { member in
        member.optional = true
    }
    
    data.patch(struct: "shader_module_descriptor", member: "compilation_hints") { member in
        member.optional = true
    }
    
    data.patch(struct: "vertex_state", member: "buffers") { member in
        member.optional = true
    }
    
    data.patch(struct: "vertex_state", member: "constants") { member in
        member.optional = true
    }
    
    data.patch(struct: "fragment_state", member: "constants") { member in
        member.optional = true
    }
    
    data.patch(struct: "surface_configuration", member: "view_formats") { member in
        member.optional = true
    }


    /*
    Labels should have a default empty value.
    Although this is already expressed in webgpu.yml by the "string_with_default_empty" type, this is more to do with
    how the C API will interpret null values. We don't necessarily want to set a default for all of these types, since
    in some cases a user is expected to provide a value.
    */
    for (structIndex, `struct`) in data.structs.enumerated() {
        for (memberIndex, member) in `struct`.members.enumerated() {
            if member.name == "label" {
                data.structs[structIndex].members[memberIndex].default = .init(stringValue: "")
            }
        }
    }
}

fileprivate extension WebGPUData {
    mutating func patch(object: String, method: String, update: (inout Function) -> Void) {
        if let objectIndex = objects.firstIndex(where: { $0.name == object }) {
            if let methodIndex = objects[objectIndex].methods.firstIndex(where: { $0.name == method }) {
                update(&objects[objectIndex].methods[methodIndex])
            }
        }
    }

    mutating func patch(struct: String, member: String, update: (inout Parameter) -> Void) {
        if let structIndex = structs.firstIndex(where: { $0.name == `struct` }) {
            if let memberIndex = structs[structIndex].members.firstIndex(where: { $0.name == member }) {
                update(&structs[structIndex].members[memberIndex])
            }
        }
    }
}
