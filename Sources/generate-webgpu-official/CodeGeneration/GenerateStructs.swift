/// Generates Swift struct definitions from the WebGPU model.
func generateStructs(model: WebGPUModel) -> String {
    return code {
        "import CWebGPU"
        ""
        
        for type in model.types(of: StructType.self) {
            
            let adoptions = commaSeparated {
                "ConvertibleFromC"
                "ConvertibleToCWithClosure"
                if type.type == .extensible {
                    "Extensible"
                }
                if type.type == .extension {
                    "Chained"
                }
            }
            
            block("public struct \(type.swiftName): \(adoptions)") {
                "typealias CType = \(type.cName)"
                ""
                
                if type.type == .extensible || type.type == .extension {
                    "public var nextInChain: Chained?"
                }
            }
            ""
        }
    }
}
