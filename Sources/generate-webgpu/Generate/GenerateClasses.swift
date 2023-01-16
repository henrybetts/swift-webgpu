func generateClasses(model: Model) -> String {
    return code {
        "import CWebGPU"
        ""
        
        for type in model.types(of: ObjectType.self) {
            availability(of: type)
            block("public class \(type.swiftName): ConvertibleFromC, ConvertibleToCWithClosure") {
                "typealias CType = \(type.cName)?"
                
                "private let handle: \(type.cName)"
                ""
                
                "/// Create a wrapper around an existing handle."
                "///"
                "/// The ownership of the handle is transferred to this class."
                "///"
                "/// - Parameter handle: The handle to wrap."
                block("public init(handle: \(type.cName))") {
                    "self.handle = handle"
                }
                ""
                
                block("required convenience init(cValue: \(type.cName)?)") {
                    "self.init(handle: cValue!)"
                }
                ""
                
                block("deinit") {
                    for method in type.methods {
                        if method.isCallbackSetter {
                            "\(method.swiftFunctionName)(nil)"
                        }
                    }
                    "\(type.releaseFunctionName)(handle)"
                }
                ""
                
                "/// Calls the given closure with the underlying handle."
                "///"
                "/// The underlying handle is guaranteed not to be released before the closure returns."
                "///"
                "/// - Parameter body: A closure to call with the underlying handle."
                block("public func withUnsafeHandle<R>(_ body: (\(type.cName)) throws -> R) rethrows -> R") {
                    block("return try withExtendedLifetime(self)") {
                        "return try body(handle)"
                    }
                }
                ""
                
                block("func withCValue<R>(_ body: (\(type.cName)?) throws -> R) rethrows -> R") {
                    "return try withUnsafeHandle(body)"
                }
                
                for method in type.methods {
                    ""
                    
                    if method.isCallbackSetter {
                        "var _\(method.swiftFunctionName): UserData<\(method.arguments[0].swiftType)>? = nil"
                        block("public func \(method.swiftFunctionName)(_ callback: \(method.arguments[0].swiftType)?)") {
                            block("self.withUnsafeHandle", "_handle in") {
                                block("if let callback = callback") {
                                    "let userData = UserData(callback)"
                                    "self._\(method.swiftFunctionName) = userData"
                                    "\(method.cFunctionName)(_handle, \((method.arguments[0].type as! FunctionPointerType).callbackFunctionName), userData.toOpaque())"
                                }
                                block("else") {
                                    "self._\(method.swiftFunctionName) = nil"
                                    "\(method.cFunctionName)(_handle, nil, nil)"
                                }
                            }
                        }
                        
                    } else {
                        generateFunction(method, isMethod: true)
                    }
                }
            }
            ""
        }
    }
}
