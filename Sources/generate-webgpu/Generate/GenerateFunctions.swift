func generateFunctions(model: Model) -> String {
    return code {
        "import CWebGPU"
        ""
        
        for type in model.types(of: FunctionType.self) {
            let methodDefinition = line {
                let methodParams = commaSeparated {
                    for (index, arg) in type.swiftArguments.enumerated() {
                        line {
                            if index == 0 && type.hideFirstArgumentLabel {
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
                    
                "public func \(type.swiftFunctionName)(\(methodParams))"
                if let returnType = type.swiftReturnType {
                    " -> \(returnType)"
                }
            }
            
            block(methodDefinition) {
                for arg in type.swiftArguments {
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
                    for arg in type.arguments {
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
                    if type.returnConversion != nil {
                        "let _result = "
                    }
                    "\(type.cFunctionName)(\(functionArgs))"
                }
                
                switch type.returnConversion {
                case .native:
                    "return _result"
                case .value:
                    "return .init(cValue: _result)"
                default:
                    nil
                }
                
                for arg in type.swiftArguments {
                    switch arg.typeConversion {
                    case .valueWithClosure, .pointerWithClosure, .array, .nativeArray:
                        "}"
                    default:
                        nil
                    }
                }
            }
            ""
        }
    }
}
