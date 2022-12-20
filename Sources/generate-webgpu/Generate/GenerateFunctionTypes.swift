func generateFunctionTypes(model: Model) -> String {
    return code {
        "import CWebGPU"
        ""
        
        for type in model.types(of: FunctionPointerType.self) {
            let functionArgs = commaSeparated {
                for arg in type.arguments.removingHidden {
                    arg.swiftType
                }
            }
            let returnType = type.swiftReturnType ?? "()"
            
            line {
                "public typealias \(type.swiftName) = (\(functionArgs)) -> \(returnType)"
            }
            ""
        }
    }
}
