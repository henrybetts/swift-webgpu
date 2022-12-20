func generateCallbacks(model: Model) -> String {
    return code {
        "import CWebGPU"
        ""
        
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
    }
}
