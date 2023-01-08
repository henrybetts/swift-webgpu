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
        wgpuInstanceReference(object)
        return WebGPU.Instance(handle: object!)
    }
    
    public func discoverDefaultAdapters() {
        dawnNativeInstanceDiscoverDefaultAdapters(self.instance)
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
        wgpuAdapterReference(object)
        return WebGPU.Adapter(handle: object!)
    }
    
    public var properties: AdapterProperties {
        var cProps = WGPUAdapterProperties()
        dawnNativeAdapterGetProperties(self.adapter, &cProps)
        return AdapterProperties(
            vendorId: cProps.vendorID,
            vendorName: String(cString: cProps.vendorName),
            architecture: String(cString: cProps.architecture),
            deviceId: cProps.deviceID,
            name: String(cString: cProps.name),
            driverDescription: String(cString: cProps.driverDescription),
            adapterType: AdapterType(rawValue: cProps.adapterType.rawValue)!,
            backendType: BackendType(rawValue: cProps.backendType.rawValue)!
        )
    }
    
    public func createDevice() -> Device? {
        guard let device = dawnNativeAdapterCreateDevice(self.adapter) else {
            return nil
        }
        return Device(handle: device)
    }
}
