import CWebGPU

public func createInstance(descriptor: InstanceDescriptor? = nil) -> Instance {
    descriptor.withOptionalCStruct { cStruct_descriptor in
    let result = wgpuCreateInstance(
        cStruct_descriptor
    )
    return .init(handle: result)
    }
}

public func getProcAddress(device: Device, procName: String) -> Proc? {
    device.withUnsafeHandle { handle_device in
    procName.withCString { cString_procName in
    let result = wgpuGetProcAddress(
        handle_device, 
        cString_procName
    )
    return result
    }
    }
}

