import ArgumentParser
import Foundation

@main
struct GenerateWebGPU: ParsableCommand {
    static var configuration = CommandConfiguration(commandName: "generate-webgpu")
    
    @Option(help: "Path to dawn.json", transform: URL.init(fileURLWithPath:))
    var dawnJson: URL
    
    @Option(help: "Path to output directory", transform: URL.init(fileURLWithPath:))
    var outputDir: URL
    
    mutating func run() throws {
        let jsonData = try Data(contentsOf: dawnJson)
        let dawnData = try DawnData(from: jsonData)
        let model = Model(data: dawnData)
        
        try generateEnums(model: model).write(to: outputDir.appendingPathComponent("Enums.swift"), atomically: true, encoding: .utf8)
        try generateOptionSets(model: model).write(to: outputDir.appendingPathComponent("OptionSets.swift"), atomically: true, encoding: .utf8)
        try generateStructs(model: model).write(to: outputDir.appendingPathComponent("Structs.swift"), atomically: true, encoding: .utf8)
        try generateClasses(model: model).write(to: outputDir.appendingPathComponent("Classes.swift"), atomically: true, encoding: .utf8)
        try generateFunctionPointers(model: model).write(to: outputDir.appendingPathComponent("FunctionPointers.swift"), atomically: true, encoding: .utf8)
        try generateFunctions(model: model).write(to: outputDir.appendingPathComponent("Functions.swift"), atomically: true, encoding: .utf8)
    }
}
