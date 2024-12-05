func generateCallbacks(model: Model) -> String {
    return code {
        "import CWebGPU"
        ""
        
        // legacy style callbacks
        for type in model.types(of: FunctionPointerType.self) {
            if type.isCallback {
                let callbackArguments = commaSeparated {
                    for arg in type.arguments {
                        "\(arg.swiftName): \(arg.cType)"
                    }
                }
                
                block("func \(type.callbackFunctionName)(\(callbackArguments))") {
                    "let _callback = UserData<\(type.swiftName)>.takeValue(userdata)"
                    let callbackArguments = commaSeparated {
                        for arg in type.arguments.removingHidden {
                            convertCToSwift(member: arg)
                        }
                    }
                    "_callback(\(callbackArguments))"
                }
                ""
            }
        }
        
        // new style callbacks
        for type in model.types(of: CallbackFunctionType.self) {
            let callbackArgumentTypes = commaSeparated {
                for arg in type.arguments.removingHidden {
                    arg.swiftType
                }
            }
            
            "public typealias \(type.swiftName) = (\(callbackArgumentTypes)) -> ()"
            ""
            
            
            let callbackArguments = commaSeparated {
                for arg in type.arguments {
                    "\(arg.swiftName): \(arg.cType)"
                }
                "userdata1: UnsafeMutableRawPointer!"
                "userdata2: UnsafeMutableRawPointer!"
            }
            
            block("func \(type.callbackFunctionName)(\(callbackArguments))") {
                "let _callback = UserData<\(type.swiftName)>.takeValue(userdata1)"
                let callbackArguments = commaSeparated {
                    for arg in type.arguments.removingHidden {
                        convertCToSwift(member: arg)
                    }
                }
                "_callback(\(callbackArguments))"
            }
            ""
        }
    }
}
