/// Generates Swift enum definitions from the WebGPU model.
func generateEnums(model: WebGPUModel) -> String {
    return code {
        "import CWebGPU"
        ""
        
        for type in model.enums {
            block("public enum \(type.swiftName): \(type.cName).RawValue, ConvertibleFromC, ConvertibleToC") {
                "typealias CType = \(type.cName)"
                ""
                
                for entry in type.entries {
                    "case \(entry.swiftName.escaped) = \(entry.value)"
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
