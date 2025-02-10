import WebGPU
import WindowUtils

let instance = createInstance()
var device: Device? = nil;

instance.requestAdapter(options: nil, callbackInfo: RequestAdapterCallbackInfo(callback: { (status, adapter, msg) -> () in
    if (status == .success && adapter != nil) {
        print("Using adapter: \(adapter?.info.device)")
        
        let uncapturedErrorCallback: UncapturedErrorCallback = { device, errorType, errorMessage in
            print("Error (\(errorType)): \(errorMessage)")
        }

        adapter?.requestDevice(options: DeviceDescriptor(uncapturedErrorCallback: uncapturedErrorCallback), callbackInfo: RequestDeviceCallbackInfo(callback: { (status, deviceOut, msg) -> () in
            if (status == .success && deviceOut != nil) {
                device = deviceOut
            }
        }))
    }
}))

try await MainActor.run {
try withGLFW {
    let window = Window(width: 800, height: 600, title: "DemoClearColor")
    let surface = instance.createSurface(descriptor: window.surfaceDescriptor)
    surface.configure(config: .init(device: device!, format: window.preferredTextureFormat, width: 800, height: 600))
    
    var hue = 0.0
        
    try window.loop {
        let encoder = device!.createCommandEncoder()
        
        let renderPass = encoder.beginRenderPass(descriptor: RenderPassDescriptor(
            colorAttachments: [
                RenderPassColorAttachment(
                    view: try surface.getCurrentTexture().texture.createView(),
                    loadOp: .clear,
                    storeOp: .store,
                    clearValue: Color(h: hue, s: 0.9, v: 0.9, a: 1.0))]))
        renderPass.end()
        
        let commandBuffer = encoder.finish()
        device!.queue.submit(commands: [commandBuffer])
        
        surface.present()
        
        hue = (hue + 0.5).truncatingRemainder(dividingBy: 360)
    }
}
}
