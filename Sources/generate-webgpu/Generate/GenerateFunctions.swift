func generateFunctions(model: Model) -> String {
    return code {
        "import CWebGPU"
        ""
        
        for type in model.types(of: FunctionType.self) {
            generateFunction(type)
            ""
        }
    }
}
