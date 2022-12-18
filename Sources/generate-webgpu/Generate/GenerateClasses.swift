func generateClasses(model: Model) -> String {
    return code {
        "import CWebGPU"
        ""
        
        for type in model.types(of: ObjectType.self) {
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
                    
                    let methodDefinition = line {
                        if method.isGetter, let returnType = method.swiftReturnType {
                            "public var \(method.swiftFunctionName): \(returnType)"
                        } else {
                            let methodParams = commaSeparated {
                                for (index, arg) in method.swiftArguments.enumerated() {
                                    line {
                                        if index == 0 && method.hideFirstArgumentLabel {
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
                            
                            "public func \(method.swiftFunctionName)(\(methodParams))"
                            if let returnType = method.swiftReturnType {
                                " -> \(returnType)"
                            }
                        }
                    }
                    
                    block(methodDefinition) {
                        
                        block("return withUnsafeHandle", "_handle in") {
                            for arg in method.swiftArguments {
                                switch arg.typeConversion {
                                case .valueWithClosure:
                                    "return \(arg.swiftName).withCValue { cValue_\(arg.swiftName) in"
                                case .pointerWithClosure:
                                        "return \(arg.swiftName).withCPointer { cPointer_\(arg.swiftName) in"
                                case .array:
                                    "return \(arg.swiftName).withCValues { cValues_\(arg.swiftName) in"
                                case .nativeArray:
                                    "return \(arg.swiftName).withUnsafeBufferPointer { cValues_\(arg.swiftName) in"
                                default:
                                    nil
                                }
                            }
                        
                            let functionArgs = commaSeparated {
                                "_handle"
                                for arg in method.arguments {
                                    switch arg.typeConversion {
                                    case .native:
                                        "\(arg.swiftName)"
                                    case .value:
                                        "\(arg.swiftName).cValue"
                                    case .valueWithClosure:
                                        "cValue_\(arg.swiftName)"
                                    case .pointerWithClosure:
                                        "cPointer_\(arg.swiftName)"
                                    case .array, .nativeArray:
                                        "cValues_\(arg.swiftName).baseAddress"
                                    case .length:
                                        "\(arg.cType)(cValues_\(arg.parentMember!.swiftName).count)"
                                    }
                                }
                            }
                        
                            line {
                                if method.returnConversion != nil {
                                    "let _result = "
                                }
                                "\(method.cFunctionName)(\(functionArgs))"
                            }
                            
                            switch method.returnConversion {
                            case .native:
                                "return _result"
                            case .value:
                                "return .init(cValue: _result)"
                            default:
                                nil
                            }
                        
                            for arg in method.swiftArguments {
                                switch arg.typeConversion {
                                case .valueWithClosure, .pointerWithClosure, .array, .nativeArray:
                                    "}"
                                default:
                                    nil
                                }
                            }
                        }
                    }
                }
            }
            ""
        }
    }
}
