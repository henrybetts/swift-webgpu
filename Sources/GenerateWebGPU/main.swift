import Foundation

let jsonData = try Data(contentsOf: URL(fileURLWithPath: "/Users/henry/Documents/developer/dawn/dawn.json"))
let dawnData = try DawnData(from: jsonData)

for name in dawnData.types.keys {
    print(name)
}
