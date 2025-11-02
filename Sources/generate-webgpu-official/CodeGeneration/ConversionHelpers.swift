/// Converts a C value to its Swift representation based on the provided type annotation.
func convertCToSwift(type: TypeAnnotation, cValue: String, cCount: String? = nil) -> String {
    var cValue = cValue
    
    if let cCount = cCount {
        cValue = ".init(start: \(cValue), count: \(cCount))"
    }
    
    switch type.conversion {
    case .implicit:
        return cValue
    case .value, .valueWithClosure:
        return "\(type.swiftType)(cValue: \(cValue))"
    case .pointerWithClosure:
        return "\(type.swiftType)(cPointer: \(cValue))"
    }
}

/// Converts a C parameter to its Swift representation.
func convertCToSwift(parameter: Parameter, prefix: String = "") -> String {
    let cValue = prefix + parameter.cName
    let cCount = parameter.cCountName.map { prefix + $0 }
    return convertCToSwift(type: parameter.type, cValue: cValue, cCount: cCount)
}

/// Converts Swift parameters to their C representations.
func convertSwiftToC(parameters: Parameters, prefix: String = "", throws: Bool = false, @CodeBuilder builder: ([(value: String, count: String?)]) -> [String]) -> String {
    return code {
        var indentationSize = 0
        let returnTry = `throws` ? "return try" : "return"

        for param in parameters {
            indented(size: indentationSize) {
                switch param.type.conversion {
                case .valueWithClosure:
                    "\(returnTry) \(prefix)\(param.swiftName).withCValue { c_\(param.swiftName) in"
                    indentationSize += 4
                case .pointerWithClosure:
                    "\(returnTry) \(prefix)\(param.swiftName).withCPointer { c_\(param.swiftName) in"
                    indentationSize += 4
                default:
                    ()
                }
            }
        }

        let cValues = parameters.map { (param) -> (String, String?) in
            let cValue: String
            switch param.type.conversion {
            case .implicit:
                cValue = prefix + param.swiftName
            case .value:
                cValue = "\(prefix)\(param.swiftName).cValue"
            case .valueWithClosure, .pointerWithClosure:
                cValue = "c_\(param.swiftName)"
            }
            
            if param.type.isArray {
                return ("\(cValue).baseAddress", "\(cValue).count")
            } else {
                return (cValue, nil)
            }
        }

        indented(size: indentationSize) { builder(cValues) }

        for param in parameters {
            switch param.type.conversion {
            case .valueWithClosure, .pointerWithClosure:
                indentationSize -= 4
                indented(size: indentationSize) { "}" }
            default:
                ()
            }
        }
    }
}
