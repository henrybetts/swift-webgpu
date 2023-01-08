func generateOptionSets(model: Model) -> String {
    return code {
        "import CWebGPU"
        ""
        
        for type in model.types(of: BitmaskType.self) {
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
                
                // TODO: This shouldn't be needed, but there are currently a couple of mistakes in the generated webgpu.h
                block("init(cValue: \(type.cEnumName))") {
                    "self.init(rawValue: \(type.cName)(cValue.rawValue))"
                }
                ""
                
                block("var cValue: \(type.cName)") {
                    "return self.rawValue"
                }
                ""
                
                for value in type.values {
                    if value.value != 0 {
                        "public static let \(value.swiftName) = \(type.swiftName)(rawValue: \(value.value))"
                    } else {
                        "public static let \(value.swiftName) = \(type.swiftName)([])"
                    }
                }
            }
            ""
        }
    }
}
