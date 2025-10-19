import ArgumentParser
import Foundation

@main
struct GenerateWebGPU: ParsableCommand {
    static var configuration = CommandConfiguration(commandName: "generate-webgpu")
    
    @Option(help: "Path to webgpu.json", transform: URL.init(fileURLWithPath:))
    var jsonPath: URL
    
    @Option(help: "Path to output directory", transform: URL.init(fileURLWithPath:))
    var outputPath: URL
    
    mutating func run() throws {
        let jsonData = try Data(contentsOf: jsonPath)
        let webgpuData = try WebGPUData(jsonData: jsonData)
        let model = WebGPUModel(data: webgpuData)
        
        try FileManager.default.createDirectory(at: outputPath, withIntermediateDirectories: true)
        
        try writeSource(generateEnums(model: model), toFileNamed: "Enums.swift")
    }
    
    func writeSource(_ source: String, toFileNamed fileName: String) throws {
        try source.write(to: outputPath.appendingPathComponent(fileName), atomically: true, encoding: .utf8)
        print("Generated source file \(fileName)")
    }
}
