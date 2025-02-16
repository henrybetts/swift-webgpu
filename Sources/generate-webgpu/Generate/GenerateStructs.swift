func generateStructs(model: Model) -> String {
    return code {
        "import CWebGPU"
        ""
        
        for type in model.types(of: StructureType.self) {
            
            let adoptions = commaSeparated {
                if type.name != "device descriptor" {
                    "ConvertibleFromC"
                }
                "ConvertibleToCWithClosure"
                if type.extensible == .in {
                    "Extensible"
                }
                if type.chained == .in {
                    "Chained"
                }
            }
            
            availability(of: type)
            block("public struct \(type.swiftName): \(adoptions)") {
                "typealias CType = \(type.cName)"
                ""
                
                for member in type.members.removingHidden {
                    "public var \(member.swiftName): \(member.swiftType)"
                }
                
                if type.extensible == .in || type.chained == .in {
                    "public var nextInChain: Chained?"
                }
                
                ""
                
                let initParams = commaSeparated {
                    for member in type.members.removingHidden {
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
                    for member in type.members.removingHidden {
                        "self.\(member.swiftName) = \(member.swiftName)"
                    }
                    if type.extensible == .in || type.chained == .in {
                        "self.nextInChain = nextInChain"
                    }
                }
                ""
                
                if type.name != "device descriptor" {
                    block("init(cValue: \(type.cName))") {
                        for member in type.members.removingHidden {
                            "self.\(member.swiftName) = \(convertCToSwift(member: member, prefix: "cValue."))"
                        }
                    }
                    ""
                }
                
                if type.name.hasSuffix(" binding layout") {
                    "public static var zero = \(type.swiftName)(cValue: \(type.cName)())"
                    ""
                }
                
                block("func withCValue<R>(_ body: (\(type.cName)) throws -> R) rethrows -> R") {
                    block("return try self.nextInChain.withChainedStruct", "chainedStruct in", condition: type.extensible == .in || type.chained == .in) {
                        convertSwiftToC(members: type.members, prefix: "self.", throws: true) { cValues in
                            let structArgs = commaSeparated {
                                switch type.extensible {
                                case .in:
                                    "nextInChain: UnsafeMutablePointer(mutating: chainedStruct)"
                                case .out:
                                    "nextInChain: nil"
                                case .none:
                                    ()
                                }
                                
                                switch type.chained {
                                case .in:
                                    "chain: WGPUChainedStruct(next: UnsafeMutablePointer(mutating: chainedStruct), sType: \(type.sType))"
                                case .out:
                                    "chain: WGPUChainedStruct(next: nil, sType: \(type.sType))"
                                case .none:
                                    ()
                                }
                                
                                for (member, cValue) in zip(type.members, cValues) {
                                    "\(member.cName): \(cValue)"
                                }
                            }
                    
                            "let cStruct = \(type.cName)(\(structArgs))"
                            "return try body(cStruct)"
                        }
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
