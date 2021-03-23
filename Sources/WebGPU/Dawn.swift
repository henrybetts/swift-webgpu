import CDawnProc
import CDawnNative

var dawnInitialized = false

public extension Instance {
    convenience init(descriptor: InstanceDescriptor? = nil) {
        if !dawnInitialized {
            dawnProcSetProcs(dawnNativeGetProcs())
            dawnInitialized = true
        }
        
        let instance = descriptor.withOptionalCStruct { cStruct_descriptor in
            wgpuCreateInstance(cStruct_descriptor)
        }
        self.init(object: instance)
    }
}
