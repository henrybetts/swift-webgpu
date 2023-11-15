class NativeType: Type {
    init(name: String, data: NativeTypeData) {
        super.init(name: name, data: data)
    }
    
    override var cName: String {
        return [
            "void": "Void",
            "void *": "UnsafeMutableRawPointer!",
            "void const *": "UnsafeRawPointer!",
            "char": "CChar",
            "float": "Float",
            "double": "Double",
            "uint8_t": "UInt8",
            "uint16_t": "UInt16",
            "uint32_t": "UInt32",
            "uint64_t": "UInt64",
            "int32_t": "Int32",
            "int64_t": "Int64",
            "size_t": "Int",
            "int": "Int32",
            "bool": "WGPUBool"
        ][name] ?? name
    }
    
    override var swiftName: String {
        if name == "bool" {
            // Special case for 'bool' because it has a typedef for compatibility.
            return "Bool"
        }
        return cName
    }
    
    override func swiftValue(from value: Any) -> String {
        if let value = value as? String {
            if value.starts(with: "WGPU_") {
                if name == "size_t" {
                    return "Int(bitPattern: UInt(\(value)))"
                } else {
                    return "\(swiftName)(\(value))"
                }
            }
        
            if value == "NAN" {
                return ".nan"
            }
            
            if name == "float" && value.hasSuffix("f") {
                return String(value.dropLast())
            }
        }
        return super.swiftValue(from: value)
    }
}
