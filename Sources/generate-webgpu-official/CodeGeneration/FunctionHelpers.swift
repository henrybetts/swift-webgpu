/// Generates an appropriate Swift function for the given function type.
func generateFunction(_ function: FunctionType) -> String {
    if function.callback != nil {
        return generateAsync(function: function)
    } else {
        return generateStandard(function: function)
    }
}

/// Generates the Swift function parameters for a given function.
fileprivate func generateParameters(function: FunctionType) -> [String] {
    return function.arguments.enumerated().map({ (index, arg) in
        line {
            if index == 0 && function.hideFirstArgumentLabel {
                "_ "
            }
            "\(arg.swiftName): \(arg.type.swiftType)"
            if let defaultValue = arg.type.defaultSwiftValue {
                " = \(defaultValue)"
            }
        }
    })
}

/// Generates a standard function.
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

/// Generates an asynchronous function (i.e. a function with a callback).
fileprivate func generateAsync(function: FunctionType) -> String {
    code {
        let callback = function.callback!
        
        let functionParams = commaSeparated {
            generateParameters(function: function)
            "callbackMode: CallbackMode = .allowSpontaneous"
            "callback: @escaping \(callback.swiftName)"
        }
    
        block("public func \(function.swiftName)(\(functionParams)) -> Future") {
            block("return withUnsafeObject", "_object in", condition: function is ObjectType.Method) {
                convertSwiftToC(parameters: function.arguments) { cValues in
                    "var callbackInfo = \(callback.cInfoName)()"
                    "callbackInfo.mode = callbackMode.cValue"
                    "callbackInfo.callback = \(callback.adapterFunctionName)"
                    "callbackInfo.userdata1 = UserData.passRetained(callback)"
                    ""
                    
                    let functionArgs = commaSeparated {
                        if function is ObjectType.Method { "_object" }
                        for cValue in cValues {
                            cValue.count
                            cValue.value
                        }
                        "callbackInfo"
                    }
                    
                    "let _result = \(function.cName)(\(functionArgs))"
                    "return Future(cValue: _result)"
                }
            }
        }
    }
}
