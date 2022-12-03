func generateStructs(model: Model) -> String {
    return code {
        "import CWebGPU"
        ""
        
        for type in model.types(of: StructureType.self) {
            block("public struct \(type.swiftName): \(getAdoptions(type: type).joined(separator: ", "))") {
                "typealias CValue = \(type.cName)"
                ""
                
                for member in type.members {
                    "public var \(member.swiftName): \(member.swiftType)"
                }
                
                if type.extensible == .in || type.chained == .in {
                    "public var nextInChain: Chained?"
                }
                
                ""
                
                block("public init(\(getInitParams(strucure: type).joined(separator: ", ")))") {
                    for member in type.members {
                        "self.\(member.swiftName) = \(member.swiftName)"
                        if type.extensible == .in || type.chained == .in {
                            "self.nextInChain = nextInChain"
                        }
                    }
                }
                ""
                
                block("init(cValue: \(type.cName))") {
                    for member in type.members {
                        switch member.typeConversion {
                        case .implicit:
                            "self.\(member.swiftName) = cValue.\(member.cName)"
                        case .explicit:
                            "self.\(member.swiftName) = .init(cValue: cValue.\(member.cName))"
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
    var params = strucure.members.map { member -> String in
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
