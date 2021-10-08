import WebGPU
import CDawnProc
import CDawnNative

var dawnInitialized = false

public class Instance: WebGPU.Instance {
    let instance: DawnNativeInstance!
    
    public init() {
        if !dawnInitialized {
            dawnProcSetProcs(dawnNativeGetProcs());
            dawnInitialized = true;
        }
        
        self.instance = dawnNativeCreateInstance()
        
        let object = dawnNativeInstanceGetObject(self.instance)
        wgpuInstanceReference(object)
        super.init(handle: object)
    }
    
    deinit {
        dawnNativeInstanceRelease(self.instance)
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
        
        return adapters.map { Adapter(instance: self, adapter: $0) }
    }
}

public class Adapter {
    let instance: Instance
    let adapter: DawnNativeAdapter!
    
    init(instance: Instance, adapter: DawnNativeAdapter!) {
        self.instance = instance
        self.adapter = adapter
    }
    
    deinit {
        dawnNativeAdapterRelease(self.adapter)
    }
    
    public var properties: AdapterProperties {
        var cProps = WGPUAdapterProperties()
        dawnNativeAdapterGetProperties(self.adapter, &cProps)
        return AdapterProperties(
            vendorId: cProps.vendorID,
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

