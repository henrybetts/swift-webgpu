/// A model representing the WebGPU API.
struct WebGPUModel {
    let enums: [EnumType]
    let bitflags: [BitflagType]
    let structs: [StructType]
    let callbacks: [CallbackType]
    let functions: [FunctionType]
    let objects: [ObjectType]
    
    init(data: WebGPUData) {
        enums = data.enums.map { EnumType(data: $0) }
        bitflags = data.bitflags.map { BitflagType(data: $0) }
        structs = data.structs.map { StructType(data: $0) }
        callbacks = data.callbacks.map { CallbackType(data: $0) }
        functions = data.functions.map { FunctionType(data: $0) }
        objects = data.objects.map { ObjectType(data: $0) }
        
        for type in enums { type.link(model: self)}
        for type in bitflags { type.link(model: self)}
        for type in structs { type.link(model: self)}
        for type in callbacks { type.link(model: self)}
        for type in functions { type.link(model: self)}
        for type in objects { type.link(model: self)}
    }
    
    func lookup<T>(_ keyPath: KeyPath<Self, [T]>, _ name: String) -> T? where T: Type {
        let types = self[keyPath: keyPath]
        return types.first { $0.name == name }
    }
}
