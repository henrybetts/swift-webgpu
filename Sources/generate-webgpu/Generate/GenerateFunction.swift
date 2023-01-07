func generateFunction(_ function: FunctionType, isMethod: Bool = false) -> String {
    return code {
        let methodDefinition = line {
            if function.isGetter, let returnType = function.swiftReturnType {
                "public var \(function.swiftFunctionName): \(returnType)"
            } else {
                let methodParams = commaSeparated {
                    for (index, arg) in function.arguments.removingHidden.enumerated() {
                        line {
                            if index == 0 && function.hideFirstArgumentLabel {
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
                
                "public func \(function.swiftFunctionName)(\(methodParams))"
                if let returnType = function.swiftReturnType {
                    " -> \(returnType)"
                }
            }
        }
    
        block(methodDefinition) {
            block("return withUnsafeHandle", "_handle in", condition: isMethod) {
                convertSwiftToC(members: function.arguments) { cValues in
            
                    let functionArgs = commaSeparated {
                        if isMethod { "_handle" }
                        cValues
                    }
            
                    line {
                        if function.returnConversion != nil {
                            "let _result = "
                        }
                        "\(function.cFunctionName)(\(functionArgs))"
                    }
                
                    if let returnConversion = function.returnConversion, let returnType = function.swiftReturnType {
                        "return \(convertCToSwift(cValue: "_result", swiftType: returnType, typeConversion: returnConversion))"
                    }
                }
            }
        }
    }
}
