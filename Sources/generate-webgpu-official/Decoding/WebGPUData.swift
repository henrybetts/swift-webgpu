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

    struct Bitflag: Decodable {
        var name: String
        @DefaultFallback var entries: [Entry]
        
        struct Entry: Decodable {
            var name: String
        }
    }

    var enums: [Enum]
    var bitflags: [Bitflag]

    init(jsonData: Data) throws {
        let decoder = JSONDecoder()
        self = try decoder.decode(WebGPUData.self, from: jsonData)
    }
}
