/// Generates an appropriate Swift function for the given function type.
func generateFunction(_ function: FunctionType) -> String {
    if let callback = function.callback {
        return code {
            generateWithCallback(function: function)
            if callback.isFailable {
                ""
                generateWithFailableCallback(function: function)
                ""
                generateAsync(function: function)
            }
        }
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

/// Generates a function with a callback
fileprivate func generateWithCallback(function: FunctionType) -> String {
    code {
        let callback = function.callback!
        
        let functionParams = commaSeparated {
            generateParameters(function: function)
            "callbackMode: CallbackMode = .allowSpontaneous"
            "callback: @escaping \(callback.swiftName)"
        }
    
        "@discardableResult"
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

/// Generates an overload function with a failable callback.
fileprivate func generateWithFailableCallback(function: FunctionType) -> String {
    code {
        let callback = function.callback!
        
        let statusArg = callback.arguments[0]
        let successArg = callback.arguments.dropFirst().first { $0.name != "message" }
        let messageArg = callback.arguments.dropFirst().first { $0.name == "message" }

        let successType = successArg?.type.unwrappedSwiftType ?? "Void"
        let failureType = "RequestError<\(statusArg.type.swiftType)>"
        let resultType = "Result<\(successType), \(failureType)>"
        
        
        let functionParams = commaSeparated {
            generateParameters(function: function)
            "callbackMode: CallbackMode = .allowSpontaneous"
            "callback: @escaping (\(resultType)) -> Void"
        }
        
        let functionCallArgs = commaSeparated {
            for (index, arg) in function.arguments.enumerated() {
                if index == 0 && function.hideFirstArgumentLabel {
                    arg.swiftName
                } else {
                    "\(arg.swiftName): \(arg.swiftName)"
                }
            }
            "callbackMode: callbackMode"
        }
        
        let callbackArgNames = commaSeparated {
            for arg in callback.arguments {
                arg.swiftName
            }
        }
    
        "@discardableResult"
        block("public func \(function.swiftName)(\(functionParams)) -> Future") {
            block("return \(function.swiftName)(\(functionCallArgs))", "\(callbackArgNames) in") {
                block("if \(statusArg.swiftName) == .success") {
                    let successArg = line {
                        "\(successArg?.swiftName ?? "()")"
                        if successArg?.type.isOptional == true {
                            "!"
                        }
                    }
                    "callback(Result.success(\(successArg)))"
                }
                block("else") {
                    "callback(Result.failure(RequestError(status: \(statusArg.swiftName), message: \(messageArg?.swiftName ?? "nil"))))"
                }
            }
        }
    }
}

/// Generates an async function (async wrapper for failable callbacks).
fileprivate func generateAsync(function: FunctionType) -> String {
    code {
        let callback = function.callback!
        
        let successArg = callback.arguments.dropFirst().first { $0.name != "message" }
        let successType = successArg?.type.unwrappedSwiftType ?? "Void"
        
        let functionParams = commaSeparated {
            generateParameters(function: function)
        }
        
        let functionCallArgs = commaSeparated {
            for (index, arg) in function.arguments.enumerated() {
                if index == 0 && function.hideFirstArgumentLabel {
                    arg.swiftName
                } else {
                    "\(arg.swiftName): \(arg.swiftName)"
                }
            }
            "callbackMode: .allowSpontaneous"
        }
        
        block("public func \(function.swiftName)(\(functionParams)) async throws -> \(successType)") {
            block("return try await withUnsafeThrowingContinuation", "_continuation in") {
                block("\(function.swiftName)(\(functionCallArgs))", "_result in") {
                    "_continuation.resume(with: _result)"
                }
            }
        }
    }
}
