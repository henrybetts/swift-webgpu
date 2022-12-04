func generateStructs(model: Model) -> String {
    return code {
        "import CWebGPU"
        ""
        
        for type in model.types(of: StructureType.self) {
            block("public struct \(type.swiftName): \(getAdoptions(type: type).joined(separator: ", "))") {
                "typealias CValue = \(type.cName)"
                ""
                
                for member in type.swiftMembers {
                    "public var \(member.swiftName): \(member.swiftType)"
                }
                
                if type.extensible == .in || type.chained == .in {
                    "public var nextInChain: Chained?"
                }
                
                ""
                
                block("public init(\(getInitParams(strucure: type).joined(separator: ", ")))") {
                    for member in type.swiftMembers {
                        "self.\(member.swiftName) = \(member.swiftName)"
                        if type.extensible == .in || type.chained == .in {
                            "self.nextInChain = nextInChain"
                        }
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

func getAdoptions(type: StructureType) -> [String] {
    var adoptions = ["ConvertibleFromC"]
    if type.extensible == .in {
        adoptions.append("Extensible")
    }
    if type.chained == .in {
        adoptions.append("Chained")
    }
    return adoptions
}

func getInitParams(strucure: StructureType) -> [String] {
    var params = strucure.swiftMembers.map { member -> String in
        var param = "\(member.swiftName): \(member.swiftType)"
        if let defaultValue = member.defaultSwiftValue {
            param += " = \(defaultValue)"
        }
        return param
    }
    
    if strucure.extensible == .in || strucure.chained == .in {
        params.append("nextInChain: Chained? = nil")
    }
    
    return params
}
