func applyPatches(to data: inout WebGPUData) {
    data.patch(object: "buffer", method: "get_mapped_range") { method in
        method.returns?.optional = true
    }
    
    data.patch(object: "buffer", method: "get_const_mapped_range") { method in
        method.returns?.optional = true
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
}
