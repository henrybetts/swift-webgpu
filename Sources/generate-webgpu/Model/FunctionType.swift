class FunctionType: FunctionPointerType {
    var cFunctionName: String {
        return "wgpu" + name.pascalCased(preservingCasing: true)
    }
    
    var swiftFunctionName: String {
        if isGetter || isExtensibleGetter {
            return String(name.dropFirst(4)).camelCased()
        } else {
            return name.camelCased()
        }
    }
    
    var hideFirstArgumentLabel: Bool {
        guard let firstArgument = arguments.removingHidden.first else { return false }
        return name.hasSuffix(" " + firstArgument.name)
    }
}
