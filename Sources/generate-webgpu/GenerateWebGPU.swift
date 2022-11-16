import ArgumentParser
import Foundation

@main
struct GenerateWebGPU: ParsableCommand {
    static var configuration = CommandConfiguration(commandName: "generate-webgpu")
    
    @Option(help: "Path to dawn.json", transform: URL.init(fileURLWithPath:))
    var dawnJson: URL
    
    mutating func run() throws {
        let jsonData = try Data(contentsOf: dawnJson)
        let dawnData = try DawnData(from: jsonData)
        let model = Model(data: dawnData)
        for enumType in model.types(of: EnumType.self) {
            print(enumType.swiftName)
        }
    }
}
