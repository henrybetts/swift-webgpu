import WebGPU
import DawnNative
import WindowUtils

let instance = DawnNative.Instance()

instance.discoverDefaultAdapters()
guard let adapter = instance.adapters.first else {
    fatalError("No adapters found")
}
print("Using adapter: \(adapter.properties.name)")

withGLFW {
    let window = Window(width: 800, height: 600, title: "DemoClearColor")
    let surface = instance.createSurface(descriptor: window.surfaceDescriptor)
        
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
        presentMode: .fifo,
        implementation: 0))
    
    var hue = 0.0
        
    repeat {
        let encoder = device.createCommandEncoder()
        
        let renderPass = encoder.beginRenderPass(descriptor: RenderPassDescriptor(
            colorAttachments: [
                RenderPassColorAttachmentDescriptor(
                    attachment: swapchain.currentTextureView,
                    loadOp: .clear,
                    storeOp: .store,
                    clearColor: Color(h: hue, s: 0.9, v: 0.9, a: 1.0))]))
        renderPass.endPass()
        
        let commandBuffer = encoder.finish()
        device.queue.submit(commands: [commandBuffer])
        
        swapchain.present()
        pollEvents()
        
        hue = (hue + 0.5).truncatingRemainder(dividingBy: 360)
        
    } while !window.shouldClose
}
