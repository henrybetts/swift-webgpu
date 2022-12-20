func generateFunctions(model: Model) -> String {
    return code {
        "import CWebGPU"
        ""
        
        for type in model.types(of: FunctionType.self) {
            let methodDefinition = line {
                let methodParams = commaSeparated {
                    for (index, arg) in type.arguments.removingHidden.enumerated() {
                        line {
                            if index == 0 && type.hideFirstArgumentLabel {
                                "_ "
                            }
                            "\(arg.swiftName): "
                            if arg.type?.category == .functionPointer {
                                "@escaping "
                            }
                            arg.swiftType
                            if let defaultValue = arg.defaultSwiftValue {
                                " = \(defaultValue)"
                            }
                        }
                    }
                }
                    
                "public func \(type.swiftFunctionName)(\(methodParams))"
                if let returnType = type.swiftReturnType {
                    " -> \(returnType)"
                }
            }
            
            block(methodDefinition) {
                convertSwiftToC(members: type.arguments) { cValues in                
                    line {
                        if type.returnConversion != nil {
                            "let _result = "
                        }
                        "\(type.cFunctionName)(\(commaSeparated { cValues }))"
                    }
                
                    if let returnConversion = type.returnConversion, let returnType = type.swiftReturnType {
                        "return \(convertCToSwift(cValue: "_result", swiftType: returnType, typeConversion: returnConversion))"
                    }
                }
            }
            ""
        }
    }
}
