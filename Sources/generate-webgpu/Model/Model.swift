struct Model {
    let types: [String: Type]
    
    init(data: DawnData) {
        var types = [String: Type]()
        
        for (name, data) in data.types {
            if data.tags.contains("upstream") { continue }
            
            if data.category == .native, let data = data as? NativeTypeData {
                types[name] = NativeType(name: name, data: data)
            } else if data.category == .enum, let data = data as? EnumTypeData {
                types[name] = EnumType(name: name, data: data)
            } else if data.category == .bitmask, let data = data as? EnumTypeData {
                types[name] = BitmaskType(name: name, data: data)
            } else if data.category == .structure, let data = data as? StructureTypeData {
                types[name] = StructureType(name: name, data: data)
            } else if data.category == .object, let data = data as? ObjectTypeData {
                types[name] = ObjectType(name: name, data: data)
            }
        }
        
        self.types = types
        
        for type in types.values {
            type.link(model: self)
        }
    }
    
    func types<T: Type>(of _: T.Type) -> [T] {
        return types.values.compactMap { type(of: $0) == T.self ? ($0 as! T) : nil }
    }
}
