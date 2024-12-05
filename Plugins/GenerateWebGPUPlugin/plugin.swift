import PackagePlugin
import Foundation

@main struct GenerateWebGPUPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) throws -> [Command] {
        let dawnJsonPath: Path
        
        if let dawnJsonEnv = ProcessInfo.processInfo.environment["DAWN_JSON"] {
            dawnJsonPath = Path(dawnJsonEnv)
        } else {
            dawnJsonPath = Path("/usr/local/share/dawn/dawn.json")
        }
        
        let generateTool = try context.tool(named: "generate-webgpu")
        let outputDir = context.pluginWorkDirectory.appending("Generated")
        
        let outputFiles = [
            outputDir.appending("Enums.swift"),
            outputDir.appending("OptionSets.swift"),
            outputDir.appending("Structs.swift"),
            outputDir.appending("Classes.swift"),
            outputDir.appending("Functions.swift"),
            outputDir.appending("FunctionTypes.swift"),
            outputDir.appending("Callbacks.swift"),
            outputDir.appending("CallbackInfo.swift"),
        ]
        
        return [
            .buildCommand(
                displayName: "Generating WebGPU",
                executable: generateTool.path,
                arguments: ["--dawn-json", dawnJsonPath, "--output-dir", outputDir],
                inputFiles: [dawnJsonPath],
                outputFiles: outputFiles)]
    }
}
