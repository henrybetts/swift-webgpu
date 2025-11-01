func generateFunction(_ function: FunctionType) -> String {
    return generateStandard(function: function)
}

fileprivate func generateParameters(function: FunctionType) -> [String] {
    return function.arguments.enumerated().map({ (index, arg) in
        line {
            if index == 0 && function.hideFirstArgumentLabel {
                "_ "
            }
            "\(arg.swiftName): \(arg.type.cType)"
        }
    })
}

fileprivate func generateStandard(function: FunctionType) -> String {
    code {
        let functionParams = commaSeparated {
            generateParameters(function: function)
        }
        
        let functionDefinition = line {
            "public func \(function.swiftName)(\(functionParams))"
            if let returnType = function.returnType {
                " -> \(returnType.cType)"
            }
        }
    
        block(functionDefinition) {
            block("return withUnsafeObject", "_object in", condition: function is ObjectType.Method) {
                let functionArgs = commaSeparated {
                    if function is ObjectType.Method { "_object" }
                    for arg in function.arguments {
                        if arg.type.isArray { "0" }
                        arg.swiftName
                    }
                }
                
                line {
                    if function.returnType != nil {
                        "let _result = "
                    }
                    "\(function.cName)(\(functionArgs))"
                }
                
                if function.returnType != nil {
                    "return _result"
                }
            }
        }
    }
}
