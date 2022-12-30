import PackagePlugin
import Foundation

@main struct GenerateWebGPUPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) throws -> [Command] {
        guard let dawnJsonEnv = ProcessInfo.processInfo.environment["DAWN_JSON"] else { return [] }
        let dawnJson = Path(dawnJsonEnv)
        
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
        ]
        
        return [
            .buildCommand(
                displayName: "Generating WebGPU",
                executable: generateTool.path,
                arguments: ["--dawn-json", dawnJson, "--output-dir", outputDir],
                inputFiles: [dawnJson],
                outputFiles: outputFiles)]
    }
}
