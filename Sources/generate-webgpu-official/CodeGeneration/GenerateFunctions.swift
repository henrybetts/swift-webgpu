/// Generates Swift function definitions from the WebGPU model.
func generateFunctions(model: WebGPUModel) -> String {
    return code {
        "import CWebGPU"
        ""
        
        for type in model.types(of: FunctionType.self) {
            generateFunction(type)
            ""
        }
    }
}
