class FunctionType: FunctionPointerType {
    var cFunctionName: String {
        return "wgpu" + name.pascalCased(preservingCasing: true)
    }
    
    var swiftFunctionName: String {
        return name.camelCased()
    }
    
    var swiftArguments: Record {
        return arguments.filter { !($0.parentMember?.isArray ?? false) }
    }
    
    var hideFirstArgumentLabel: Bool {
        guard let firstArgument = swiftArguments.first else { return false }
        return name.hasSuffix(" " + firstArgument.name)
    }
    
    var swiftReturnType: String? {
        guard let returnType = returnType else { return nil }
        if returnType.category == .functionPointer {
            return returnType.swiftName + "?"
        }
        return returnType.swiftName
    }
    
    var returnConversion: TypeConversion? {
        guard let returnType = returnType else { return nil }
        switch returnType.category {
        case .enum, .bitmask, .structure, .object:
            return .value
        default:
            return .native
        }
    }
}
