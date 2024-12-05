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
        let info = adapter.webGpuAdapter.info
        
        print(subtitle: "[\(i)] \(info.device)")
        withIndent {
            print(info.description)
            print(key: "vendor", value: info.vendor)
            print(key: "vendorId", value: hex(info.vendorId))
            print(key: "deviceId", value: hex(info.deviceId))
            print(key: "adapterType", value: info.adapterType)
            print(key: "backendType", value: info.backendType)
            print(key: "architecture", value: info.architecture)
        }
        print()
    }
}
