/// Generates Swift OptionSet / bitflag definitions from the WebGPU model.
func generateBitflags(model: WebGPUModel) -> String {
    return code {
        "import CWebGPU"
        ""
        
        for type in model.bitflags {
            block("public struct \(type.swiftName): OptionSet, ConvertibleFromC, ConvertibleToC") {
                "typealias CType = \(type.cName)"
                ""
                
                "public let rawValue: \(type.cName)"
                ""
                
                block("public init(rawValue: \(type.cName))") {
                    "self.rawValue = rawValue"
                }
                ""
                
                block("init(cValue: \(type.cName))") {
                    "self.init(rawValue: cValue)"
                }
                ""
                
                block("var cValue: \(type.cName)") {
                    "return self.rawValue"
                }
                ""
                
                for entry in type.entries {
                    "public static let \(entry.swiftName) = \(type.swiftName)(rawValue: \(type.cName(of: entry)))"
                }
            }
            ""
        }
    }
}
