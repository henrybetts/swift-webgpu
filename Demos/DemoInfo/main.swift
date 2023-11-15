import DawnNative

let instance = Instance()
let adapters = instance.adapters

print("===========")
print("WebGPU Info")
print("===========")
print()

print(title: "Adapters (\(adapters.count))")
withIndent {
    for (i, adapter) in adapters.enumerated() {
        let properties = adapter.properties
        
        print(subtitle: "[\(i)] \(properties.name ?? "Unknown")")
        withIndent {
            if let description = properties.driverDescription, !description.isEmpty {
                print(description)
            }
            print(key: "vendorId", value: hex(properties.vendorId))
            print(key: "deviceId", value: hex(properties.deviceId))
            print(key: "adapterType", value: properties.adapterType)
            print(key: "backendType", value: properties.backendType)
        }
        print()
    }
}
