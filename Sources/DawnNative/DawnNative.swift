import WebGPU
import CDawnNative

public var procs: UnsafePointer<DawnProcTable> {
    return dawnNativeGetProcs()
}

public class Instance {
    let instance: DawnNativeInstance!
    
    public init() {
        self.instance = dawnNativeCreateInstance()
    }
    
    deinit {
        dawnNativeInstanceRelease(self.instance)
    }
    
    public var webGpuInstance: WebGPU.Instance {
        let object = dawnNativeInstanceGet(self.instance)
        wgpuInstanceAddRef(object)
        return WebGPU.Instance(handle: object!)
    }
    
    public var adapters: [Adapter] {
        var count: Int = 0
        dawnNativeInstanceEnumerateAdapters(self.instance, &count, nil)
        
        let adapters = Array<CDawnNative.DawnNativeAdapter?>(unsafeUninitializedCapacity: count) { (buffer, initializedCount) in
            dawnNativeInstanceEnumerateAdapters(self.instance, &count, buffer.baseAddress)
            initializedCount = count
        }
        
        return adapters.map { Adapter(adapter: $0) }
    }
}

public class Adapter {
    let adapter: DawnNativeAdapter!
    
    init(adapter: DawnNativeAdapter!) {
        self.adapter = adapter
    }
    
    deinit {
        dawnNativeAdapterRelease(self.adapter)
    }
    
    public var webGpuAdapter: WebGPU.Adapter {
        let object = dawnNativeAdapterGet(self.adapter)
        wgpuAdapterAddRef(object)
        return WebGPU.Adapter(handle: object!)
    }
    
    public var info: AdapterInfo {
        var cInfo = WGPUAdapterInfo()
        dawnNativeAdapterGetInfo(self.adapter, &cInfo)
        
        func convertString(_ cString: WGPUStringView) -> String {
            let bytes = UnsafeRawBufferPointer(start: cString.data, count: cString.length)
            return String(decoding: bytes, as: UTF8.self)
        }
        
        return AdapterInfo(
            vendor: convertString(cInfo.vendor),
            architecture: convertString(cInfo.architecture),
            device: convertString(cInfo.device),
            description: convertString(cInfo.description),
            backendType: BackendType(rawValue: cInfo.backendType.rawValue)!,
            adapterType: AdapterType(rawValue: cInfo.adapterType.rawValue)!,
            vendorId: cInfo.vendorID,
            deviceId: cInfo.deviceID,
            compatibilityMode: cInfo.compatibilityMode != 0)
    }
    
    public func createDevice() -> Device? {
        guard let device = dawnNativeAdapterCreateDevice(self.adapter) else {
            return nil
        }
        return Device(handle: device)
    }
}
