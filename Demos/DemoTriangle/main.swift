import WebGPU
import DawnNative
import WindowUtils

struct Vertex {
    var position: (Float, Float, Float)
    var color: (Float, Float, Float)
}

let instance = DawnNative.Instance()

instance.discoverDefaultAdapters()
guard let adapter = instance.adapters.first(where: { $0.properties.backendType != .null }) else {
    fatalError("No adapters found")
}
print("Using adapter: \(adapter.properties.name)")

withGLFW {
    let window = Window(width: 800, height: 600, title: "DemoTriangle")
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
        presentMode: .fifo,
        implementation: 0))
    
    let vertexShaderSource = """
        struct VertexOut {
            @builtin(position) position : vec4<f32>;
            @location(0) color: vec4<f32>;
        };

        @stage(vertex) fn main(
            @location(0) position : vec4<f32>,
            @location(1) color : vec4<f32>) -> VertexOut {
            var output : VertexOut;
            output.position = position;
            output.color = color;
            return output;
        }
    """
    
    let fragmentShaderSource = """
        @stage(fragment) fn main(
            @location(0) color : vec4<f32>) -> @location(0) vec4<f32> {
            return color;
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
        vertex: VertexState(
            module: vertexShader,
            entryPoint: "main",
            buffers: [
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
        fragment: FragmentState(
            module: fragmentShader,
            entryPoint: "main",
            targets: [
                ColorTargetState(format: window.preferredTextureFormat)])))
    
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
    
    window.loop {
        let encoder = device.createCommandEncoder()
        
        let renderPass = encoder.beginRenderPass(descriptor: RenderPassDescriptor(
            colorAttachments: [
                RenderPassColorAttachment(
                    view: swapchain.currentTextureView,
                    loadOp: .clear,
                    storeOp: .store,
                    clearValue: Color(r: 0, g: 0, b: 0, a: 1))]))
        renderPass.setPipeline(pipeline)
        renderPass.setVertexBuffer(slot: 0, buffer: vertexBuffer)
        renderPass.draw(vertexCount: 3)
        renderPass.end()
        
        let commandBuffer = encoder.finish()
        device.queue.submit(commands: [commandBuffer])
        
        swapchain.present()
    }
}
