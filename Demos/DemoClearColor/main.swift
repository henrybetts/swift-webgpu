import WebGPU
import WindowUtils

let instance = createInstance()

let adapter = try await instance.requestAdapter()
print("Using adapter: \(adapter.properties.name ?? "Unknown")")

let device = try await adapter.requestDevice()

device.setUncapturedErrorCallback { (errorType, errorMessage) in
    print("Error (\(errorType)): \(errorMessage)")
}

try withGLFW {
    let window = Window(width: 800, height: 600, title: "DemoClearColor")
    let surface = instance.createSurface(descriptor: window.surfaceDescriptor)
    surface.configure(config: .init(device: device, format: window.preferredTextureFormat, width: 800, height: 600))
    
    var hue = 0.0
        
    try window.loop {
        let encoder = device.createCommandEncoder()
        
        let renderPass = encoder.beginRenderPass(descriptor: RenderPassDescriptor(
            colorAttachments: [
                RenderPassColorAttachment(
                    view: try surface.getCurrentTexture().texture.createView(),
                    loadOp: .clear,
                    storeOp: .store,
                    clearValue: Color(h: hue, s: 0.9, v: 0.9, a: 1.0))]))
        renderPass.end()
        
        let commandBuffer = encoder.finish()
        device.queue.submit(commands: [commandBuffer])
        
        surface.present()
        
        hue = (hue + 0.5).truncatingRemainder(dividingBy: 360)
    }
}
