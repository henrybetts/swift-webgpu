func generateFunction(_ function: FunctionType, isMethod: Bool = false) -> String {
    if function.isGetter {
        return generateGetter(function: function, isMethod: isMethod)
    } else if function.isExtensibleGetter {
        return generateExtensibleGetter(function: function, isMethod: isMethod)
    } else if function.isEnumerator {
        return generateEnumerator(function: function, isMethod: isMethod)
    } else {
        return generateStandard(function: function, isMethod: isMethod)
    }
}

fileprivate func generateParameters(_ record: Record, hideFirstLabel: Bool) -> String {
    commaSeparated {
        for (index, arg) in record.enumerated() {
            line {
                if index == 0 && hideFirstLabel {
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
}

fileprivate func generateStandard(function: FunctionType, isMethod: Bool) -> String {
    code {
        let functionParams = generateParameters(function.arguments.removingHidden, hideFirstLabel: function.hideFirstArgumentLabel)

        
        let functionDefinition = line {
            "public func \(function.swiftFunctionName)(\(functionParams))"
            if let returnType = function.swiftReturnType {
                " -> \(returnType)"
            }
        }
    
        availability(of: function)
        block(functionDefinition) {
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
        
        if function.isRequest {
            ""
            generateRequestOverloads(function: function)
        }
        
    }
}

fileprivate func generateRequestOverloads(function: FunctionType) -> String {
    code {
        let functionArgs = function.arguments.dropLast(2).removingHidden
        
        let callback = function.arguments[function.arguments.count - 2].type as! FunctionPointerType
        let callbackArgs = callback.arguments.removingHidden
        
        let statusArg = callbackArgs[0]
        let successArg = callbackArgs.count > 1 ? callbackArgs[1] : nil
        let messageArg = callbackArgs.count > 2 ? callbackArgs[2] : nil

        let successType = successArg?.unwrappedSwiftType ?? "Void"
        let failureType = "RequestError<\(statusArg.swiftType)>"
        let resultType = "Result<\(successType), \(failureType)>"
        
        let functionParams = generateParameters(functionArgs, hideFirstLabel: function.hideFirstArgumentLabel)
        
        let functionParamsWithCallback = commaSeparated {
            if functionArgs.count > 0 {
                functionParams
            }
            "callback: @escaping (\(resultType)) -> Void)"
        }
        
        let functionCallArgs = commaSeparated {
            for (index, arg) in functionArgs.enumerated() {
                if index == 0 && function.hideFirstArgumentLabel {
                    arg.swiftName
                } else {
                    "\(arg.swiftName): \(arg.swiftName)"
                }
            }
        }
    
        availability(of: function)
        block("public func \(function.swiftFunctionName)(\(functionParamsWithCallback)") {
            
            let callbackArgNames = commaSeparated {
                for arg in callbackArgs {
                    arg.swiftName
                }
            }
            
            block("\(function.swiftFunctionName)(\(functionCallArgs))", "\(callbackArgNames) in") {
                block("if status == .success") {
                    let successArg = line {
                        "\(successArg?.swiftName ?? "()")"
                        if successArg?.isOptional == true {
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

fileprivate func generateGetter(function: FunctionType, isMethod: Bool) -> String {
    code {
        availability(of: function)
        block("public var \(function.swiftFunctionName): \(function.swiftReturnType!)") {
            block("return withUnsafeHandle", "_handle in", condition: isMethod) {
                let functionArgs = isMethod ? "_handle" : ""
                
                "let _result = \(function.cFunctionName)(\(functionArgs))"
                
                "return \(convertCToSwift(cValue: "_result", swiftType: function.swiftReturnType!, typeConversion: function.returnConversion!))"
            }
        }
    }
}

fileprivate func generateExtensibleGetter(function: FunctionType, isMethod: Bool) -> String {
    code {
        let structType = function.arguments[0].type!
        
        availability(of: function)
        block("public var \(function.swiftFunctionName): \(structType.swiftName)") {
            block("return withUnsafeHandle", "_handle in", condition: isMethod) {
                "var _cStruct = \(structType.cName)()"
                
                let functionArgs = commaSeparated {
                    if isMethod { "_handle" }
                    "&_cStruct"
                }
                
                "\(function.cFunctionName)(\(functionArgs))"
                
                "return \(convertCToSwift(cValue: "_cStruct", swiftType: structType.swiftName, typeConversion: .value))"
            }
        }
    }
}

fileprivate func generateEnumerator(function: FunctionType, isMethod: Bool) -> String {
    code {
        let enumeratedType = function.arguments[0].type!
        let returnType = function.swiftReturnType!
        
        availability(of: function)
        block("public var \(function.swiftFunctionName): \(returnType)") {
            block("return withUnsafeHandle", "_handle in", condition: isMethod) {
                
                let functionArgs = commaSeparated {
                    if isMethod { "_handle" }
                    "nil"
                }
                "let _count = \(function.cFunctionName)(\(functionArgs))"
                
                block("let _cValues = [\(enumeratedType.cName)](unsafeUninitializedCapacity: _count)", "_buffer, _initializedCount in") {
                    let functionArgs = commaSeparated {
                        if isMethod { "_handle" }
                        "_buffer.baseAddress"
                    }
                    "_initializedCount = \(function.cFunctionName)(\(functionArgs))"
                }
                
                "return \(convertCToSwift(cValue: "_cValues", swiftType: returnType, typeConversion: function.returnConversion!))"
            }
        }
    }
}
