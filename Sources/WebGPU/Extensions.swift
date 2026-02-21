// Extensions for missing features / more natural Swift interfaces

import CWebGPU

extension DeviceDescriptor {
    public init(deviceLostCallback: DeviceLostCallback? = nil, uncapturedErrorCallback: UncapturedErrorCallback? = nil) {
        // TODO: This is a temporary solution until we have a proper way to manage the memory / ownership of these callbacks.
        // This solution can currently result in memory leaks - though shouldn't be a huge issue unless an application is creating a lot of devices.
        self.init(cValue: .init())
        
        if let deviceLostCallback {
            self.deviceLostCallbackInfo.mode = WGPUCallbackMode_AllowSpontaneous
            self.deviceLostCallbackInfo.callback = WebGPU.deviceLostCallback
            self.deviceLostCallbackInfo.userdata1 = UserData.passRetained(deviceLostCallback)
        }
        
        if let uncapturedErrorCallback {
            self.uncapturedErrorCallbackInfo.callback = WebGPU.uncapturedErrorCallback
            // uncaptured error callback is a special case, since it can be called multiple times
            // TODO: The userdata is currently leaked - need some way of managing the memory for this
            self.uncapturedErrorCallbackInfo.userdata1 = Unmanaged.passRetained(UserData(uncapturedErrorCallback)).toOpaque()
        }
    }
}

extension Surface {
    public func getCurrentTexture() throws -> SurfaceTexture {
        // TODO: surfaceTexture.texture isn't marked as optional upstream, which is why this extension is needed
        var surfaceTexture = WGPUSurfaceTexture()
        withUnsafeObject { object in
            wgpuSurfaceGetCurrentTexture(object, &surfaceTexture)
        }
        guard surfaceTexture.texture != nil else {
            throw RequestError(status: SurfaceGetCurrentTextureStatus(cValue: surfaceTexture.status), message: "Could not get current surface texture")
        }
        return SurfaceTexture(cValue: surfaceTexture)
    }
    
    public func getCapabilities(adapter: Adapter) -> SurfaceCapabilities {
        var capabilities = WGPUSurfaceCapabilities()
        defer { wgpuSurfaceCapabilitiesFreeMembers(capabilities) }
        
        let status = getCapabilities(adapter: adapter, capabilities: &capabilities)
        
        // this shouldn't fail as we are not passing in any chained structs
        precondition(status == .success, "Failed to get surface capabilities")
        
        return SurfaceCapabilities(cValue: capabilities)
    }
}

extension Queue {
    public func writeBuffer(_ buffer: Buffer, bufferOffset: UInt64 = 0, data: UnsafeRawBufferPointer) {
        if let baseAddress = data.baseAddress {
            writeBuffer(buffer, bufferOffset: bufferOffset, data: baseAddress, size: data.count)
        }
    }
}
