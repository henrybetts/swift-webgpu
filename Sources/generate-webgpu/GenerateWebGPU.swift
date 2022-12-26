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
        
        try FileManager.default.createDirectory(at: outputDir, withIntermediateDirectories: true)
        
        try writeSource(generateEnums(model: model), toFileNamed: "Enums.swift")
        try writeSource(generateOptionSets(model: model), toFileNamed: "OptionSets.swift")
        try writeSource(generateStructs(model: model), toFileNamed: "Structs.swift")
        try writeSource(generateClasses(model: model), toFileNamed: "Classes.swift")
        try writeSource(generateFunctionTypes(model: model), toFileNamed: "FunctionTypes.swift")
        try writeSource(generateFunctions(model: model), toFileNamed: "Functions.swift")
        try writeSource(generateCallbacks(model: model), toFileNamed: "Callbacks.swift")
    }
    
    func writeSource(_ source: String, toFileNamed fileName: String) throws {
        try source.write(to: outputDir.appendingPathComponent(fileName), atomically: true, encoding: .utf8)
        print("Generated source file \(fileName)")
    }
}
