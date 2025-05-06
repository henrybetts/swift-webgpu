// Extensions for missing features / more natural Swift interfaces

import CWebGPU

extension DeviceDescriptor {
    public init(deviceLostCallback: DeviceLostCallback? = nil, uncapturedErrorCallback: UncapturedErrorCallback? = nil) {
        self.init(
            deviceLostCallbackInfo: .init(callback: deviceLostCallback),
            uncapturedErrorCallbackInfo: .init(callback: uncapturedErrorCallback)
        )
    }
}

extension Surface {
    public func getCurrentTexture() throws -> SurfaceTexture {
        // TODO: surfaceTexture.texture isn't marked as optional upstream, which is why this extension is needed
        var surfaceTexture = WGPUSurfaceTexture()
        withUnsafeHandle { handle in
            wgpuSurfaceGetCurrentTexture(handle, &surfaceTexture)
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
