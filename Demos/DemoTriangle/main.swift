import WebGPU
import WindowUtils

struct Vertex {
    var position: (Float, Float, Float)
    var color: (Float, Float, Float)
}

let instance = DawnNativeInstance()

instance.discoverDefaultAdapters()
guard let adapter = instance.adapters.first else {
    fatalError("No adapters found")
}
print("Using adapter: \(adapter.properties.name)")

withGLFW {
    let window = Window(width: 800, height: 600, title: "DemoTriangle")
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
    
    let vertexShaderSource = """
        [[location(0)]] var<in> position : vec4<f32>;
        [[location(1)]] var<in> color : vec4<f32>;
        [[builtin(position)]] var<out> Position : vec4<f32>;
        [[location(0)]] var<out> Color: vec4<f32>;
        [[stage(vertex)]] fn main() -> void {
            Position = position;
            Color = color;
            return;
        }
    """
    
    let fragmentShaderSource = """
        [[location(0)]] var<in> color : vec4<f32>;
        [[location(0)]] var<out> FragColor : vec4<f32>;
        [[stage(fragment)]] fn main() -> void {
            FragColor = color;
            return;
        }
    """
    
    let vertexShader = device.createShaderModule(
        descriptor: ShaderModuleDescriptor(
            label: nil,
            nextInChain: ShaderModuleWgslDescriptor(source: vertexShaderSource)))
    
    let fragmentShader = device.createShaderModule(
        descriptor: ShaderModuleDescriptor(
            label: nil,
            nextInChain: ShaderModuleWgslDescriptor(source: fragmentShaderSource)))
    
    let pipeline = device.createRenderPipeline(descriptor: RenderPipelineDescriptor(
        vertexStage: ProgrammableStageDescriptor(module: vertexShader, entryPoint: "main"),
        fragmentStage: ProgrammableStageDescriptor(module: fragmentShader, entryPoint: "main"),
        vertexState: VertexStateDescriptor(
            vertexBuffers: [
                VertexBufferLayout(
                    arrayStride: UInt64(MemoryLayout<Vertex>.stride),
                    attributes: [
                        VertexAttribute(
                            format: .float32x3,
                            offset: UInt64(MemoryLayout.offset(of: \Vertex.position)!),
                            shaderLocation: 0),
                        VertexAttribute(
                            format: .float32x3,
                            offset: UInt64(MemoryLayout.offset(of: \Vertex.color)!),
                            shaderLocation: 1)])]),
        primitiveTopology: .triangleList,
        colorStates: [
            ColorStateDescriptor(
                format: window.preferredTextureFormat,
                alphaBlend: BlendDescriptor(),
                colorBlend: BlendDescriptor())]))
    
    let vertexData = [
        Vertex(position: (0, 0.5, 0), color: (1, 0, 0)),
        Vertex(position: (-0.5, -0.5, 0), color: (0, 1, 0)),
        Vertex(position: (0.5, -0.5, 0), color: (0, 0, 1))
    ]
    
    let vertexBuffer = vertexData.withUnsafeBytes { vertexBytes -> Buffer in
        let vertexBuffer = device.createBuffer(descriptor: BufferDescriptor(
            usage: .vertex,
            size: UInt64(vertexBytes.count),
            mappedAtCreation: true))
        let ptr = vertexBuffer.getMappedRange(offset: 0, size: 0)
        ptr?.copyMemory(from: vertexBytes.baseAddress!, byteCount: vertexBytes.count)
        vertexBuffer.unmap()
        return vertexBuffer
    }
    
    repeat {
        let encoder = device.createCommandEncoder()
        
        let renderPass = encoder.beginRenderPass(descriptor: RenderPassDescriptor(
            colorAttachments: [
                RenderPassColorAttachmentDescriptor(
                    attachment: swapchain.currentTextureView,
                    loadOp: .clear,
                    storeOp: .store,
                    clearColor: Color(r: 0, g: 0, b: 0, a: 1))]))
        renderPass.setPipeline(pipeline)
        renderPass.setVertexBuffer(slot: 0, buffer: vertexBuffer)
        renderPass.draw(vertexCount: 3)
        renderPass.endPass()
        
        let commandBuffer = encoder.finish()
        device.queue.submit(commands: [commandBuffer])
        
        swapchain.present()
        pollEvents()
        
    } while !window.shouldClose

}
