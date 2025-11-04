func applyPatches(to model: WebGPUModel) {
    if let bufferObject = model.lookup(\.objects, "buffer") {
        for method in bufferObject.methods {
            if method.name == "get_mapped_range" || method.name == "get_const_mapped_range" {
                method.returnType?.isOptional = true
            }
        }
    }
}
