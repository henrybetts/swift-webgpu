func generateFunction(_ function: FunctionType) -> String {
    return generateStandard(function: function)
}

fileprivate func generateParameters(function: FunctionType) -> [String] {
    return function.arguments.enumerated().map({ (index, arg) in
        line {
            if index == 0 && function.hideFirstArgumentLabel {
                "_ "
            }
            "\(arg.swiftName): \(arg.type.swiftType)"
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
                " -> \(returnType.swiftType)"
            }
        }
    
        block(functionDefinition) {
            block("return withUnsafeObject", "_object in", condition: function is ObjectType.Method) {
                convertSwiftToC(parameters: function.arguments) { cValues in
                    let functionArgs = commaSeparated {
                        if function is ObjectType.Method { "_object" }
                        for cValue in cValues {
                            cValue.count
                            cValue.value
                        }
                    }
                    
                    line {
                        if function.returnType != nil {
                            "let _result = "
                        }
                        "\(function.cName)(\(functionArgs))"
                    }
                    
                    if let returnType = function.returnType {
                        "return \(convertCToSwift(type: returnType, cValue: "_result"))"
                    }
                }
            }
        }
    }
}
