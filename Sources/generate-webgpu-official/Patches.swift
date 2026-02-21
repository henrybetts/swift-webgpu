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

    data.patch(struct: "compute_state", member: "constants") { member in
        member.optional = true
    }
    
    data.patch(struct: "surface_configuration", member: "view_formats") { member in
        member.optional = true
    }

    for encoder in ["render_pass_encoder", "render_bundle_encoder", "compute_pass_encoder"] {
        data.patch(object: encoder, method: "set_bind_group", arg: "dynamic_offsets") { arg in
            arg.optional = true
        }
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

    /*
    Set default values that should be in webgpu.yml.
    */
    data.patch(struct: "bind_group_layout_entry", member: "binding_array_size") { member in
        member.default = .init(stringValue: "0")
    }

    data.patch(struct: "bind_group_entry", member: "offset") { member in
        member.default = .init(stringValue: "0")
    }

    data.patch(struct: "render_pass_depth_stencil_attachment", member: "stencil_clear_value") { member in
        member.default = .init(stringValue: "0")
    }

    data.patch(object: "buffer", method: "map_async", arg: "offset") {
        $0.default = .init(stringValue: "0")
    }

    data.patch(object: "buffer", method: "map_async", arg: "size") {
        $0.default = .init(stringValue: "constant.whole_map_size")
    }

    data.patch(object: "buffer", method: "get_mapped_range", arg: "offset") {
        $0.default = .init(stringValue: "0")
    }

    data.patch(object: "buffer", method: "get_mapped_range", arg: "size") {
        $0.default = .init(stringValue: "constant.whole_map_size")
    }

    for encoder in ["render_pass_encoder", "render_bundle_encoder"] {
        data.patch(object: encoder, method: "set_vertex_buffer", arg: "offset") {
            $0.default = .init(stringValue: "0")
        }
    
        data.patch(object: encoder, method: "set_vertex_buffer", arg: "size") {
            $0.default = .init(stringValue: "constant.whole_size")
        }
   
        data.patch(object: encoder, method: "set_index_buffer", arg: "offset") {
            $0.default = .init(stringValue: "0")
        }

        data.patch(object: encoder, method: "set_index_buffer", arg: "size") {
            $0.default = .init(stringValue: "constant.whole_size")
        }

        data.patch(object: encoder, method: "draw", arg: "instance_count") {
            $0.default = .init(stringValue: "1")
        }
   
        data.patch(object: encoder, method: "draw", arg: "first_vertex") {
            $0.default = .init(stringValue: "0")
        }
    
        data.patch(object: encoder, method: "draw", arg: "first_instance") {
            $0.default = .init(stringValue: "0")
        }

        data.patch(object: encoder, method: "draw_indexed", arg: "instance_count") {
            $0.default = .init(stringValue: "1")
        }

        data.patch(object: encoder, method: "draw_indexed", arg: "first_index") {
            $0.default = .init(stringValue: "0")
        }

        data.patch(object: encoder, method: "draw_indexed", arg: "base_vertex") {
            $0.default = .init(stringValue: "0")
        }

        data.patch(object: encoder, method: "draw_indexed", arg: "first_instance") {
            $0.default = .init(stringValue: "0")
        }
    }

    data.patch(object: "compute_pass_encoder", method: "dispatch_workgroups", arg: "workgroupCountY") {
        $0.default = .init(stringValue: "1")
    }

    data.patch(object: "compute_pass_encoder", method: "dispatch_workgroups", arg: "workgroupCountZ") {
        $0.default = .init(stringValue: "1")
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

    mutating func patch(object: String, method: String, arg: String, update: (inout Parameter) -> Void) {
        if let objectIndex = objects.firstIndex(where: { $0.name == object }) {
            if let methodIndex = objects[objectIndex].methods.firstIndex(where: { $0.name == method }) {
                if let argIndex = objects[objectIndex].methods[methodIndex].args.firstIndex(where: { $0.name == arg }) {
                    update(&objects[objectIndex].methods[methodIndex].args[argIndex])
                }
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
