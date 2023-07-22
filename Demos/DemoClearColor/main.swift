import WebGPU
import WindowUtils

let instance = createInstance()

let adapter = try await instance.requestAdapter()
print("Using adapter: \(adapter.properties.name)")

let device = try await adapter.requestDevice()

device.setUncapturedErrorCallback { (errorType, errorMessage) in
    print("Error (\(errorType)): \(errorMessage)")
}

withGLFW {
    let window = Window(width: 800, height: 600, title: "DemoClearColor")
    let surface = instance.createSurface(descriptor: window.surfaceDescriptor)
    
    let swapchain = device.createSwapChain(surface: surface, descriptor: SwapChainDescriptor(
        usage: .renderAttachment,
        format: window.preferredTextureFormat,
        width: 800,
        height: 600,
        presentMode: .fifo))
    
    var hue = 0.0
        
    window.loop {
        let encoder = device.createCommandEncoder()
        
        let renderPass = encoder.beginRenderPass(descriptor: RenderPassDescriptor(
            colorAttachments: [
                RenderPassColorAttachment(
                    view: swapchain.currentTextureView,
                    loadOp: .clear,
                    storeOp: .store,
                    clearValue: Color(h: hue, s: 0.9, v: 0.9, a: 1.0))]))
        renderPass.end()
        
        let commandBuffer = encoder.finish()
        device.queue.submit(commands: [commandBuffer])
        
        swapchain.present()
        
        hue = (hue + 0.5).truncatingRemainder(dividingBy: 360)
    }
}
