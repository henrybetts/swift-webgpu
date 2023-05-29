import WebGPU
import DawnNative
import WindowUtils

let instance = DawnNative.Instance()

instance.discoverDefaultAdapters()
guard let adapter = instance.adapters.first(where: { $0.properties.backendType != .null }) else {
    fatalError("No adapters found")
}
print("Using adapter: \(adapter.properties.name)")

withGLFW {
    let window = Window(width: 800, height: 600, title: "DemoClearColor")
    let surface = instance.webGpuInstance.createSurface(descriptor: window.surfaceDescriptor)
        
    guard let device = adapter.createDevice() else {
        fatalError("Failed to create device")
    }
    
    device.setUncapturedErrorCallback { (errorType, errorMessage) in
        print("Error (\(errorType)): \(errorMessage)")
    }
    
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
