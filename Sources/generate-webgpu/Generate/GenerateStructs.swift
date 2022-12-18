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
                    if type.extensible == .in || type.chained == .in {
                        "return try self.nextInChain.withChainedStruct { chainedStruct in"
                    }
                    
                    for member in type.swiftMembers {
                        switch member.typeConversion {
                        case .valueWithClosure:
                            "return try self.\(member.swiftName).withCValue { cValue_\(member.swiftName) in"
                        case .pointerWithClosure:
                                "return try self.\(member.swiftName).withCPointer { cPointer_\(member.swiftName) in"
                        case .array:
                            "return try self.\(member.swiftName).withCValues { cValues_\(member.swiftName) in"
                        case .nativeArray:
                            "return try self.\(member.swiftName).withUnsafeBufferPointer { cValues_\(member.swiftName) in"
                        default:
                            nil
                        }
                    }
                    
                    let structArgs = commaSeparated {
                        switch type.extensible {
                        case .in:
                            "nextInChain: chainedStruct"
                        case .out:
                            "nextInChain: nil"
                        case .none:
                            nil
                        }
                        
                        switch type.chained {
                        case .in:
                            "chain: WGPUChainedStruct(next: chainedStruct, sType: \(type.sType))"
                        case .out:
                            "chain: WGPUChainedStructOut(next: nil, sType: \(type.sType))"
                        case .none:
                            nil
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
                    
                    if type.extensible == .in || type.chained == .in {
                        "}"
                    }
                }
                
                if type.chained == .in {
                    ""
                    block("public func withChainedStruct<R>(_ body: (UnsafePointer<WGPUChainedStruct>) throws -> R) rethrows -> R") {
                        block("return try withCPointer", "cStruct in") {
                            "let chainedStruct = UnsafeRawPointer(cStruct).bindMemory(to: WGPUChainedStruct.self, capacity: 1)"
                            "return try body(chainedStruct)"
                        }
                    }
                }
            }
            ""
        }
    }
}
