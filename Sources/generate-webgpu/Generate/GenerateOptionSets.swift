func generateOptionSets(model: Model) -> String {
    return code {
        "import CWebGPU"
        ""
        
        for type in model.types(of: BitmaskType.self) {
            block("public struct \(type.swiftName): OptionSet, ConvertibleFromC") {
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
                
                block("init(cValue: \(type.cEnumName))") {
                    "self.init(rawValue: cValue.rawValue)"
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
