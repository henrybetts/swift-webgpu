import WebGPU
import WindowUtils

struct Vertex {
    var position: (Float, Float, Float)
    var color: (Float, Float, Float)
}

let instance = createInstance()

let adapter = try await instance.requestAdapter()
print("Using adapter: \(adapter.info.device)")

let uncapturedErrorCallback: UncapturedErrorCallback = { device, errorType, errorMessage in
    print("Error (\(errorType)): \(errorMessage)")
}

let device = try await adapter.requestDevice(options: .init(
    uncapturedErrorCallback: uncapturedErrorCallback
))

try withGLFW {
    let window = Window(width: 800, height: 600, title: "DemoTriangle")
    let surface = instance.createSurface(descriptor: window.surfaceDescriptor)
    surface.configure(config: .init(device: device, format: window.preferredTextureFormat, width: 800, height: 600))
    
    let vertexShaderSource = """
        struct VertexOut {
            @builtin(position) position : vec4<f32>,
            @location(0) color: vec4<f32>
        };

        @vertex fn main(
            @location(0) position : vec4<f32>,
            @location(1) color : vec4<f32>) -> VertexOut {
            var output : VertexOut;
            output.position = position;
            output.color = color;
            return output;
        }
    """
    
    let fragmentShaderSource = """
        @fragment fn main(
            @location(0) color : vec4<f32>) -> @location(0) vec4<f32> {
            return color;
        }
    """
    
    let vertexShader = device.createShaderModule(
        descriptor: ShaderModuleDescriptor(
            label: nil,
            nextInChain: ShaderSourceWgsl(code: vertexShaderSource)))
    
    let fragmentShader = device.createShaderModule(
        descriptor: ShaderModuleDescriptor(
            label: nil,
            nextInChain: ShaderSourceWgsl(code: fragmentShaderSource)))
    
    let pipeline = device.createRenderPipeline(descriptor: RenderPipelineDescriptor(
        vertex: VertexState(
            module: vertexShader,
            entryPoint: "main",
            buffers: [
                VertexBufferLayout(
                    stepMode: .vertex,
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
    
    try window.loop {
        let encoder = device.createCommandEncoder()
        
        let renderPass = encoder.beginRenderPass(descriptor: RenderPassDescriptor(
            colorAttachments: [
                RenderPassColorAttachment(
                    view: try surface.getCurrentTexture().texture.createView(),
                    loadOp: .clear,
                    storeOp: .store,
                    clearValue: Color(r: 0, g: 0, b: 0, a: 1))]))
        renderPass.setPipeline(pipeline)
        renderPass.setVertexBuffer(slot: 0, buffer: vertexBuffer)
        renderPass.draw(vertexCount: 3)
        renderPass.end()
        
        let commandBuffer = encoder.finish()
        device.queue.submit(commands: [commandBuffer])
        
        surface.present()
    }
}
