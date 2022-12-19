func convertCToSwift(cValue: String, swiftType: String, typeConversion: TypeConversion) -> String {
    switch typeConversion {
    case .value, .valueWithClosure:
        return "\(swiftType)(cValue: \(cValue))"
    case .pointerWithClosure:
        return "\(swiftType)(cPointer: \(cValue))"
    default:
        return cValue
    }
}

func convertCToSwift(member: RecordMember, prefix: String = "") -> String {
    switch member.typeConversion {
    case .array:
        if let lengthMember = member.lengthMember {
            return "\(member.swiftType)(cValues: UnsafeBufferPointer(start: \(prefix)\(member.cName), count: Int(\(prefix)\(lengthMember.cName))))"
        } else if case .fixed(let length) = member.length {
            return "\(member.swiftType)(cValues: UnsafeBufferPointer(start: \(prefix)\(member.cName), count: \(length)))"
        }
    case .nativeArray:
        if let lengthMember = member.lengthMember {
            return "\(member.swiftType)(UnsafeBufferPointer(start: \(prefix)\(member.cName), count: Int(cValue.\(lengthMember.cName))))"
        } else if case .fixed(let length) = member.length {
            return "\(member.swiftType)(UnsafeBufferPointer(start: \(prefix)\(member.cName), count: \(length)))"
        }
    default:
        break
    }
    
    return convertCToSwift(cValue: prefix + member.cName, swiftType: member.swiftType, typeConversion: member.typeConversion)
}


func convertSwiftToC(members: Record, prefix: String = "", throws: Bool = false, @CodeBuilder builder: ([String]) -> [String]) -> String {
    return code {
        
        var indentationSize = 0
        let returnTry = `throws` ? "return try" : "return"
        
        for member in members {
            indented(size: indentationSize) {
                switch member.typeConversion {
                case .valueWithClosure:
                    "\(returnTry) \(prefix)\(member.swiftName).withCValue { c_\(member.swiftName) in"
                    indentationSize += 4
                case .pointerWithClosure:
                    "\(returnTry) \(prefix)\(member.swiftName).withCPointer { c_\(member.swiftName) in"
                    indentationSize += 4
                case .array:
                    "\(returnTry) \(prefix)\(member.swiftName).withCValues { c_\(member.swiftName) in"
                    indentationSize += 4
                case .nativeArray:
                    "\(returnTry) \(prefix)\(member.swiftName).withUnsafeBufferPointer { c_\(member.swiftName) in"
                    indentationSize += 4
                default:
                    ()
                }
            }
        }
        
        let cValues = members.map { (member) -> String in
            switch member.typeConversion {
            case .native:
                return prefix + member.swiftName
            case .value:
                return "\(prefix)\(member.swiftName).cValue"
            case .valueWithClosure, .pointerWithClosure:
                return "c_\(member.swiftName)"
            case .array, .nativeArray:
                return "c_\(member.swiftName).baseAddress"
            case .length:
                return "\(member.cType)(c_\(member.parentMember!.swiftName).count)"
            }
        }
        
        indented(size: indentationSize) { builder(cValues) }
        
        for member in members {
            switch member.typeConversion {
            case .valueWithClosure, .pointerWithClosure, .array, .nativeArray:
                indentationSize -= 4
                indented(size: indentationSize) { "}" }
            default:
                ()
            }
        }
    }
}
