/// Generates Swift struct definitions from the WebGPU model.
func generateStructs(model: WebGPUModel) -> String {
    return code {
        "import CWebGPU"
        ""
        
        for type in model.types(of: StructType.self) {
            
            let adoptions = commaSeparated {
                "ConvertibleFromC"
                "ConvertibleToCWithClosure"
                if type.type == .extensible {
                    "Extensible"
                }
                if type.type == .extension {
                    "Chained"
                }
            }
            
            block("public struct \(type.swiftName): \(adoptions)") {
                "typealias CType = \(type.cName)"
                ""
                
                for member in type.members {
                    "public var \(member.swiftName): \(member.type.swiftType)"
                }
                if type.type == .extensible || type.type == .extension {
                    "public var nextInChain: Chained?"
                }
                ""
                
                let initParams = commaSeparated {
                    for member in type.members {
                        "\(member.swiftName): \(member.type.swiftType)"
                    }
                    if type.type == .extensible || type.type == .extension {
                        "nextInChain: Chained? = nil"
                    }
                }
                
                block("public init(\(initParams))") {
                    for member in type.members {
                        "self.\(member.swiftName) = \(member.swiftName)"
                    }
                    if type.type == .extensible || type.type == .extension {
                        "self.nextInChain = nextInChain"
                    }
                }
                ""

                block("init(cValue: \(type.cName))") {
                    for member in type.members {
                        "self.\(member.swiftName) = \(convertCToSwift(parameter: member, prefix: "cValue."))"
                    }
                }
                ""

                block("func withCValue<R>(_ body: (\(type.cName)) throws -> R) rethrows -> R") {
                    block("return try self.nextInChain.withChainedStruct", "chainedStruct in", condition: type.type == .extensible || type.type == .extension) {
                        convertSwiftToC(parameters: type.members, prefix: "self.", throws: true) { cValues in
                            let structArgs = commaSeparated {
                                switch type.type {
                                case .extensible:
                                    "nextInChain: UnsafeMutablePointer(mutating: chainedStruct)"
                                case .extensibleCallbackArg:
                                    "nextInChain: nil"
                                case .extension:
                                    "chain: WGPUChainedStruct(next: UnsafeMutablePointer(mutating: chainedStruct), sType: \(type.sType))"
                                case .standalone:
                                    ()
                                }
                                
                                for (member, cValue) in zip(type.members, cValues) {
                                    if let cCountName = member.cCountName {
                                        "\(cCountName): \(cValue.count!)"
                                    }
                                    "\(member.cName): \(cValue.value)"
                                }
                            }
                            
                            "let cStruct = \(type.cName)(\(structArgs))"
                            "return try body(cStruct)"
                        }
                    }
                }
                
                if type.type == .extension {
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
