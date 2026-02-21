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
        return WebGPU.Instance(object: object!)
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
        return WebGPU.Adapter(object: object!)
    }
    
    public func createDevice() -> Device? {
        guard let object = dawnNativeAdapterCreateDevice(self.adapter) else {
            return nil
        }
        return Device(object: object)
    }
}
