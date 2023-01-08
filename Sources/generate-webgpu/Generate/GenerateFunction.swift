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

fileprivate func generateStandard(function: FunctionType, isMethod: Bool) -> String {
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
    
    let functionDefinition = line {
        "public func \(function.swiftFunctionName)(\(methodParams))"
        if let returnType = function.swiftReturnType {
            " -> \(returnType)"
        }
    }
    
    return block(functionDefinition) {
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

fileprivate func generateGetter(function: FunctionType, isMethod: Bool) -> String {
    block("public var \(function.swiftFunctionName): \(function.swiftReturnType!)") {
        block("return withUnsafeHandle", "_handle in", condition: isMethod) {
            let functionArgs = isMethod ? "_handle" : ""
            
            "let _result = \(function.cFunctionName)(\(functionArgs))"
            
            "return \(convertCToSwift(cValue: "_result", swiftType: function.swiftReturnType!, typeConversion: function.returnConversion!))"
        }
    }
}

fileprivate func generateExtensibleGetter(function: FunctionType, isMethod: Bool) -> String {
    let structType = function.arguments[0].type!
    
    return block("public var \(function.swiftFunctionName): \(structType.swiftName)") {
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

fileprivate func generateEnumerator(function: FunctionType, isMethod: Bool) -> String {
    let enumeratedType = function.arguments[0].type!
    let returnType = function.swiftReturnType!
    
    return block("public var \(function.swiftFunctionName): \(returnType)") {
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
                "_initializedCount = wgpuDeviceEnumerateFeatures(\(functionArgs))"
            }
            
            "return \(convertCToSwift(cValue: "_cValues", swiftType: returnType, typeConversion: function.returnConversion!))"
        }
    }
}
