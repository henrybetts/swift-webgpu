func generateStructs(model: Model) -> String {
    return code {
        "import CWebGPU"
        ""
        
        for type in model.types(of: StructureType.self) {
            
            let adoptions = commaSeparated {
                "ConvertibleFromC"
                "ConvertibleToCWithClosure"
                if type.extensible == .in {
                    "Extensible"
                }
                if type.chained == .in {
                    "Chained"
                }
            }
            
            block("public struct \(type.swiftName): \(adoptions)") {
                "typealias CType = \(type.cName)"
                ""
                
                for member in type.swiftMembers {
                    "public var \(member.swiftName): \(member.swiftType)"
                }
                
                if type.extensible == .in || type.chained == .in {
                    "public var nextInChain: Chained?"
                }
                
                ""
                
                let initParams = commaSeparated {
                    for member in type.swiftMembers {
                        line {
                            "\(member.swiftName): \(member.swiftType)"
                            if let defaultValue = member.defaultSwiftValue {
                                " = \(defaultValue)"
                            }
                        }
                    }
                    if type.extensible == .in || type.chained == .in {
                        "nextInChain: Chained? = nil"
                    }
                }
                
                block("public init(\(initParams))") {
                    for member in type.swiftMembers {
                        "self.\(member.swiftName) = \(member.swiftName)"
                    }
                    if type.extensible == .in || type.chained == .in {
                        "self.nextInChain = nextInChain"
                    }
                }
                ""
                
                block("init(cValue: \(type.cName))") {
                    for member in type.swiftMembers {
                        switch member.typeConversion {
                        case .native:
                            "self.\(member.swiftName) = cValue.\(member.cName)"
                        case .value, .valueWithClosure:
                            "self.\(member.swiftName) = \(member.swiftType)(cValue: cValue.\(member.cName))"
                        case .pointerWithClosure:
                            "self.\(member.swiftName) = \(member.swiftType)(cPointer: cValue.\(member.cName))"
                        case .array:
                            if let lengthMember = member.lengthMember {
                                "self.\(member.swiftName) = \(member.swiftType)(cValues: UnsafeBufferPointer(start: cValue.\(member.cName), count: Int(cValue.\(lengthMember.cName))))"
                            } else if case .fixed(let length) = member.length {
                                "self.\(member.swiftName) = \(member.swiftType)(cValues: UnsafeBufferPointer(start: cValue.\(member.cName), count: \(length)))"
                            }
                        case .nativeArray:
                            if let lengthMember = member.lengthMember {
                                "self.\(member.swiftName) = \(member.swiftType)(UnsafeBufferPointer(start: cValue.\(member.cName), count: Int(cValue.\(lengthMember.cName))))"
                            } else if case .fixed(let length) = member.length {
                                "self.\(member.swiftName) = \(member.swiftType)(UnsafeBufferPointer(start: cValue.\(member.cName), count: \(length)))"
                            }
                        case .length:
                            nil
                        }
                    }
                }
                ""
                
                block("func withCValue<R>(_ body: (\(type.cName)) throws -> R) rethrows -> R") {
                    for member in type.swiftMembers {
                        if member.typeConversion == .valueWithClosure {
                            "return try self.\(member.swiftName).withCValue { cValue_\(member.swiftName) in"
                        } else if member.typeConversion == .pointerWithClosure {
                                "return try self.\(member.swiftName).withCPointer { cPointer_\(member.swiftName) in"
                        } else if member.typeConversion == .array {
                            "return try self.\(member.swiftName).withCValues { cValues_\(member.swiftName) in"
                        } else if member.typeConversion == .nativeArray {
                            "return try self.\(member.swiftName).withUnsafeBufferPointer { cValues_\(member.swiftName) in"
                        }
                    }
                    
                    let structArgs = commaSeparated {
                        if type.extensible != .none {
                            "nextInChain: nil"
                        }
                        
                        if type.chained != .none {
                            "chain: WGPUChainedStruct()"
                        }
                        
                        for member in type.members {
                            switch member.typeConversion {
                            case .native:
                                "\(member.cName): self.\(member.swiftName)"
                            case .value:
                                "\(member.cName): self.\(member.swiftName).cValue"
                            case .valueWithClosure:
                                "\(member.cName): cValue_\(member.swiftName)"
                            case .pointerWithClosure:
                                "\(member.cName): cPointer_\(member.swiftName)"
                            case .array, .nativeArray:
                                "\(member.cName): cValues_\(member.swiftName).baseAddress"
                            case .length:
                                "\(member.cName): \(member.cType)(cValues_\(member.parentMember!.swiftName).count)"
                            }
                        }
                    }
                    
                    "let cStruct = \(type.cName)(\(structArgs))"
                    "return try body(cStruct)"
                    
                    for member in type.swiftMembers {
                        switch member.typeConversion {
                        case .valueWithClosure, .pointerWithClosure, .array, .nativeArray:
                            "}"
                        default:
                            nil
                        }
                    }
                }
            }
            ""
        }
    }
}
