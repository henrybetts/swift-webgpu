/// A model representing the WebGPU API.
struct WebGPUModel {
    let types: [String: Type]
    
    init(data: WebGPUData) {
        var types = [String: Type]()
        
        for enumData in data.enums {
            types[enumData.name] = EnumType(data: enumData)
        }
        
        self.types = types
    }
    
    func types<T: Type>(of _: T.Type) -> [T] {
        return types.values.compactMap {
            Swift.type(of: $0) == T.self ? ($0 as! T) : nil
        }.sorted {
            $0.name.lowercased() < $1.name.lowercased()
        }
    }
    
    func type(named name: String) -> Type {
        guard let type = types[name] else { fatalError("Unknown type '\(name)'") }
        return type
    }
}
