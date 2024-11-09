// Extensions for missing features / more natural Swift interfaces

import CWebGPU

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
extension Device
{
	public func tick()
	{
		withUnsafeHandle {
			handle in
			wgpuDeviceTick(handle)
		}
	}
}
