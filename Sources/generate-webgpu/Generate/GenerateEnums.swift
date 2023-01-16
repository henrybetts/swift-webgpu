func generateEnums(model: Model) -> String {
    return code {
        "import CWebGPU"
        ""
        
        for type in model.types(of: EnumType.self) {
            availability(of: type)
            block("public enum \(type.swiftName): \(type.cName).RawValue, ConvertibleFromC, ConvertibleToC") {
                "typealias CType = \(type.cName)"
                ""
                
                for value in type.values {
                    "case \(value.swiftName.swiftSafe()) = \(value.value)"
                }
                ""
                
                block("init(cValue: \(type.cName))") {
                    "self.init(rawValue: cValue.rawValue)!"
                }
                ""
                
                block("var cValue: \(type.cName)") {
                    "return \(type.cName)(rawValue: self.rawValue)"
                }
            }
            ""
        }
    }
}

