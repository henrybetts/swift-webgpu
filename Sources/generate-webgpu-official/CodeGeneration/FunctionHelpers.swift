/// Generates an appropriate Swift function for the given function type.
func generateFunction(_ function: FunctionType) -> String {
    if function.isGetter {
        return generateGetter(function: function)
    }
    
    if function.isExtensibleGetter {
        return generateExtensibleGetter(function: function)
    }
    
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
    }
    
    return generateStandard(function: function)
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
                    let functionCallArgs = commaSeparated {
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
                        "\(function.cName)(\(functionCallArgs))"
                    }
                    
                    if let returnType = function.returnType {
                        "return \(convertCToSwift(type: returnType, cValue: "_result"))"
                    }
                }
            }
        }
    }
}

/// Generates a property getter (no arguments).
fileprivate func generateGetter(function: FunctionType) -> String {
    code {
        let returnType = function.returnType!
        let functionCallArgs = function is ObjectType.Method ? "_object" : ""
        
        block("public var \(function.swiftName): \(returnType.swiftType)") {
            block("return withUnsafeObject", "_object in", condition: function is ObjectType.Method) {
                "let _result = \(function.cName)(\(functionCallArgs))"
                "return \(convertCToSwift(type: returnType, cValue: "_result"))"
            }
        }
    }
}

/// Generates a extensible property getter. For now it looks the same as a regular getter, but in the future it may need to support extensions.
fileprivate func generateExtensibleGetter(function: FunctionType) -> String {
    code {
        let structType = function.arguments[0].type.linkedType as! StructType
        
        let functionCallArgs = commaSeparated {
            if function is ObjectType.Method { "_object" }
            "&_cStruct"
        }
        
        block("public var \(function.swiftName): \(structType.swiftName)") {
            block("return withUnsafeObject", "_object in", condition: function is ObjectType.Method) {
                "var _cStruct = \(structType.cName)()"
                "\(function.cName)(\(functionCallArgs))"
                "return \(structType.swiftName)(cValue: _cStruct)"
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
                    
                    let functionCallArgs = commaSeparated {
                        if function is ObjectType.Method { "_object" }
                        for cValue in cValues {
                            cValue.count
                            cValue.value
                        }
                        "callbackInfo"
                    }
                    
                    "let _result = \(function.cName)(\(functionCallArgs))"
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
