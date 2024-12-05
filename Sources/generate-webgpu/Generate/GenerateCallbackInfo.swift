func generateCallbackInfo(model: Model) -> String {
    return code {
        "import CWebGPU"
        ""
        
        for type in model.types(of: CallbackInfoType.self) {
            availability(of: type)
            block("public struct \(type.swiftName): ConvertibleToCWithClosure") {
                "typealias CType = \(type.cName)"
                ""
                
                for member in type.members.removingHidden {
                    "public var \(member.swiftName): \(member.swiftType)"
                }
                ""
                
                block("public init(\(generateParameters(type.members)))") {
                    for member in type.members.removingHidden {
                        "self.\(member.swiftName) = \(member.swiftName)"
                    }
                }
                ""
                
                block("func withCValue<R>(_ body: (\(type.cName)) throws -> R) rethrows -> R") {
                    convertSwiftToC(members: type.members, prefix: "self.", throws: true) { cValues in
                        let structArgs = commaSeparated {
                            "nextInChain: nil"
                            for (member, cValue) in zip(type.members, cValues) {
                                "\(member.cName): \(cValue)"
                            }
                            if type.name.hasPrefix("uncaptured error callback info") {
                                // uncaptured error callback is a special case, since it can be called multiple times
                                // TODO: The userdata is currently leaked - need some way of managing the memory for this
                                "userdata1: self.callback != nil ? Unmanaged.passRetained(UserData(self.callback)).toOpaque() : nil"
                            } else {
                                if type.callbackMember.isOptional {
                                    "userdata1: self.callback != nil ? UserData.passRetained(self.callback) : nil"
                                } else {
                                    "userdata1: UserData.passRetained(self.callback)"
                                }
                            }
                            "userdata2: nil"
                        }
                    
                        "let cStruct = \(type.cName)(\(structArgs))"
                        "return try body(cStruct)"
                    }
                }
            }
            ""
        }
    }
}
