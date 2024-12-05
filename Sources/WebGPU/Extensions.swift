// Extensions for missing features / more natural Swift interfaces

import CWebGPU

extension DeviceDescriptor {
    public init(deviceLostCallback: DeviceLostCallback2? = nil, uncapturedErrorCallback: UncapturedErrorCallback? = nil) {
        self.init(
            deviceLostCallbackInfo2: .init(callback: deviceLostCallback),
            uncapturedErrorCallbackInfo2: .init(callback: uncapturedErrorCallback)
        )
    }
}

extension Surface {
    public func getCurrentTexture() throws -> SurfaceTexture {
        var surfaceTexture = WGPUSurfaceTexture()
        getCurrentTexture(surfaceTexture: &surfaceTexture)
        guard surfaceTexture.texture != nil else {
            throw RequestError(status: SurfaceGetCurrentTextureStatus(cValue: surfaceTexture.status), message: "Could not get current surface texture")
        }
        return SurfaceTexture(cValue: surfaceTexture)
    }
}
