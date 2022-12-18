func generateFunctionPointers(model: Model) -> String {
    return code {
        "import CWebGPU"
        ""
        
        for type in model.types(of: FunctionPointerType.self) {
            "public typealias \(type.swiftName) = \(type.cName)"
            ""
        }
    }
}
