import Foundation

/// A reprensentation of the webgpu.yml / webgpu.json data model.
struct WebGPUData: Decodable {
    struct Enum: Decodable {
        var name: String

        struct Entry: Decodable {
            var name: String
            var value: Int?
        }

        @DefaultFallback var entries: [Entry?]
    }

    var enums: [Enum]

    init(jsonData: Data) throws {
        let decoder = JSONDecoder()
        self = try decoder.decode(WebGPUData.self, from: jsonData)
    }
}
