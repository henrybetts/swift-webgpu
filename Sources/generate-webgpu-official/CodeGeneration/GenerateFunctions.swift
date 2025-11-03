/// Generates Swift function definitions from the WebGPU model.
func generateFunctions(model: WebGPUModel) -> String {
    return code {
        "import CWebGPU"
        ""
        
        for type in model.functions {
            generateFunction(type)
            ""
        }
    }
}
