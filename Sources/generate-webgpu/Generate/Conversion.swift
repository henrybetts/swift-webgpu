func convertCToSwift(cValue: String, swiftType: String, typeConversion: TypeConversion, count: String? = nil) -> String {
    var cValue = cValue
    
    if (typeConversion == .array || typeConversion == .nativeArray), let count = count {
        cValue = "UnsafeBufferPointer(start: \(cValue), count: Int(\(count)))"
    }
    
    switch typeConversion {
    case .value, .valueWithClosure:
        return "\(swiftType)(cValue: \(cValue))"
    case .pointerWithClosure:
        return "\(swiftType)(cPointer: \(cValue))"
    case .array:
        return "\(swiftType)(cValues: \(cValue))"
    case .nativeArray:
        return "\(swiftType)(\(cValue))"
    default:
        return cValue
    }
}

func convertCToSwift(member: RecordMember, prefix: String = "") -> String {
    let count: String?
    if let lengthMember = member.lengthMember {
        count = prefix + lengthMember.cName
    } else if case .fixed(let length) = member.length {
        count = String(length)
    } else {
        count = nil
    }
    
    return convertCToSwift(cValue: prefix + member.cName, swiftType: member.swiftType, typeConversion: member.typeConversion, count: count)
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
            case .callback:
                if let callback = member.type as? CallbackFunctionType {
                    if member.isOptional {
                        return "\(prefix)\(member.swiftName) != nil ? \(callback.callbackFunctionName) : nil"
                    } else {
                        return callback.callbackFunctionName
                    }
                } else {
                    return "\((member.type as! FunctionPointerType).callbackFunctionName)"
                }
            case .userData:
                return "UserData.passRetained(\(members.first(where: { $0.isCallback })?.swiftName ?? "callback"))"
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
