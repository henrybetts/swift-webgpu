import PackagePlugin
import Foundation

@main struct GenerateWebGPUPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) throws -> [Command] {        
        let jsonPath: Path
        
        if let jsonEnv = ProcessInfo.processInfo.environment["WEBGPU_JSON"] {
            jsonPath = Path(jsonEnv)
            Diagnostics.remark("WebGPU source code will be generated from \(jsonPath)")
        } else {
            jsonPath = Path("/usr/local/share/webgpu/webgpu.json")
            Diagnostics.remark("WEBGPU_JSON is not defined, so will attempt to generate source code from \(jsonPath)")
        }
        
        let generateTool = try context.tool(named: "generate-webgpu-official")
        let outputDir = context.pluginWorkDirectory.appending("Generated")
        
        let outputFiles = [
            outputDir.appending("Enums.swift"),
            outputDir.appending("Bitflags.swift"),
            outputDir.appending("Structs.swift"),
            outputDir.appending("Objects.swift"),
            outputDir.appending("Functions.swift"),
            outputDir.appending("Callbacks.swift"),
        ]
        
        return [
            .buildCommand(
                displayName: "Generating WebGPU",
                executable: generateTool.path,
                arguments: ["--json-path", jsonPath, "--output-path", outputDir],
                inputFiles: [jsonPath],
                outputFiles: outputFiles)]
    }
}
