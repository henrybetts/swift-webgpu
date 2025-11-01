/// A model representing the WebGPU API.
struct WebGPUModel {
    let types: [String: Type]
    
    init(data: WebGPUData) {
        var types = [String: Type]()
        
        for enumData in data.enums {
            types[enumData.name] = EnumType(data: enumData)
        }

        for bitflagData in data.bitflags {
            types[bitflagData.name] = BitflagType(data: bitflagData)
        }

        for structData in data.structs {
            types[structData.name] = StructType(data: structData)
        }

        for functionData in data.functions {
            types[functionData.name] = FunctionType(data: functionData)
        }

        for objectData in data.objects {
            types[objectData.name] = ObjectType(data: objectData)
        }
        
        self.types = types

        for type in types.values {
            type.link(model: self)
        }
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
