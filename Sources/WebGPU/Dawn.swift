import CDawnProc
import CDawnNative

var dawnInitialized = false

public class DawnNativeInstance: Instance {
    let instance: CDawnNative.DawnNativeInstance!
    
    public init() {
        if !dawnInitialized {
            dawnProcSetProcs(dawnNativeGetProcs());
            dawnInitialized = true;
        }
        
        self.instance = dawnNativeCreateInstance()
        
        let object = dawnNativeInstanceGetObject(self.instance)
        wgpuInstanceReference(object)
        super.init(object: object)
    }
    
    deinit {
        dawnNativeInstanceRelease(self.instance)
    }
    
    public func discoverDefaultAdapters() {
        dawnNativeInstanceDiscoverDefaultAdapters(self.instance)
    }
    
    public var adapters: [DawnNativeAdapter] {
        var count: Int = 0
        dawnNativeInstanceEnumerateAdapters(self.instance, &count, nil)
        
        let adapters = Array<CDawnNative.DawnNativeAdapter?>(unsafeUninitializedCapacity: count) { (buffer, initializedCount) in
            dawnNativeInstanceEnumerateAdapters(self.instance, &count, buffer.baseAddress)
            initializedCount = count
        }
        
        return adapters.map { DawnNativeAdapter(instance: self, adapter: $0) }
    }
}

public class DawnNativeAdapter {
    let instance: DawnNativeInstance
    let adapter: CDawnNative.DawnNativeAdapter!
    
    init(instance: DawnNativeInstance, adapter: CDawnNative.DawnNativeAdapter!) {
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
            deviceId: cProps.deviceID,
            vendorId: cProps.vendorID,
            name: String(cString: cProps.name),
            driverDescription: String(cString: cProps.driverDescription),
            adapterType: AdapterType(cValue: cProps.adapterType),
            backendType: BackendType(cValue: cProps.backendType)
        )
    }
    
    public func createDevice() -> Device? {
        guard let device = dawnNativeAdapterCreateDevice(self.adapter) else {
            return nil
        }
        return Device(object: device)
    }
}
