/// Generates Swift callback typealiases and adapter functions for WebGPU callbacks.
func generateCallbacks(model: WebGPUModel) -> String {
    return code {
        "import CWebGPU"
        ""
        
        for callback in model.callbacks {
            let swiftTypes = commaSeparated {
                for arg in callback.arguments {
                    arg.type.swiftType
                }
            }
            
            let callbackArguments = commaSeparated {
                for arg in callback.arguments {
                    "\(arg.swiftName): \(arg.type.cType)"
                }
                "userData: UnsafeMutableRawPointer!"
                "_: UnsafeMutableRawPointer!"
            }
            
            "public typealias \(callback.swiftName) = (\(swiftTypes)) -> ()"
            ""
            
            block("func \(callback.adapterFunctionName)(\(callbackArguments))") {
                "let _callback = UserData<\(callback.swiftName)>.takeValue(userData)"
                let callbackArguments = commaSeparated {
                    for arg in callback.arguments {
                        convertCToSwift(parameter: arg)
                    }
                }
                "_callback(\(callbackArguments))"
            }
            ""
        }
    }
}
