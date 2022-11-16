struct Model {
    let types: [String: Type]
    
    init(data: DawnData) {
        var types = [String: Type]()
        
        for (name, data) in data.types {
            if let data = data as? EnumTypeData {
                types[name] = EnumType(name: name, data: data)
            }
        }
        
        self.types = types
    }
    
    func types<T: Type>(of type: T.Type) -> [T] {
        return types.values.compactMap { $0 as? T }
    }
}
