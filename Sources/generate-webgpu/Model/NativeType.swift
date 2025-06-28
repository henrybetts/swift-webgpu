class NativeType: Type {
    init(name: String, data: NativeTypeData) {
        super.init(name: name, data: data)
    }

    private var constants: [String: ConstantTypeData] = [:]

    override func link(model: Model) {
        self.constants = model.constants
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
            if let constant = constants[value] {
                let constantName = "WGPU_" + value.snakeCased(uppercased: true)
                if name == "size_t" {
                    return "Int(bitPattern: UInt(\(constantName)))"
                } else if constant.value == "NAN" {
                    return ".nan"
                } else {
                    return "\(swiftName)(\(constantName))"
                }
            }
            
            if value == "NAN" {
                return ".nan"
            }

            if name == "float" {
                var floatString = value
                if floatString.hasSuffix("f") {
                    floatString.removeLast()
                }
                if floatString.hasSuffix(".") {
                    floatString.removeLast()
                }
                return floatString
            }
        }
        return super.swiftValue(from: value)
    }
}
