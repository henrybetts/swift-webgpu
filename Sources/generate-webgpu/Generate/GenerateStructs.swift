func generateStructs(model: Model) -> String {
    return code {
        "import CWebGPU"
        ""
        
        for type in model.types(of: StructureType.self) {
            
            let adoptions = commaSeparated {
                "ConvertibleFromC"
                "ConvertibleToCWithClosure"
                if type.extensible == .in {
                    "Exensible"
                }
                if type.chained == .in {
                    "Chained"
                }
            }
            
            block("public struct \(type.swiftName): \(adoptions)") {
                "typealias CValue = \(type.cName)"
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
                        case .implicit:
                            "self.\(member.swiftName) = cValue.\(member.cName)"
                        case .explicit:
                            "self.\(member.swiftName) = \(member.swiftType)(cValue: cValue.\(member.cName))"
                        case .array:
                            if let lengthMember = member.lengthMember {
                                "self.\(member.swiftName) = \(member.swiftType)(cValue: UnsafeBufferPointer(start: cValue.\(member.cName), count: Int(cValue.\(lengthMember.cName))))"
                            } else if case .fixed(let length) = member.length {
                                "self.\(member.swiftName) = \(member.swiftType)(cValue: UnsafeBufferPointer(start: cValue.\(member.cName), count: \(length)))"
                            }
                        }
                    }
                }
            }
            ""
        }
    }
}
