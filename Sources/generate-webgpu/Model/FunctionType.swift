class FunctionType: FunctionPointerType {
    var cFunctionName: String {
        return "wgpu" + name.pascalCased(preservingCasing: true)
    }
    
    var swiftFunctionName: String {
        if isGetter || isExtensibleGetter || isEnumerator {
            return name.split(separator: " ").dropFirst().joined(separator: " ").camelCased()
        } else {
            return name.camelCased()
        }
    }
    
    var hideFirstArgumentLabel: Bool {
        guard let firstArgument = arguments.removingHidden.first else { return false }
        return name.hasSuffix(" " + firstArgument.name)
    }
}
