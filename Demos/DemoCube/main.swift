import WebGPU
import DawnNative
import WindowUtils
import SGLMath

#if canImport(Darwin)
import Darwin.C
#else
import Glibc
#endif

struct Camera {
    var view: mat4
    var projection: mat4
}

let instance = DawnNative.Instance()

instance.discoverDefaultAdapters()
guard let adapter = instance.adapters.first else {
    fatalError("No adapters found")
}
print("Using adapter: \(adapter.properties.name)")

withGLFW {
    let window = Window(width: 800, height: 600, title: "DemoCube")
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
        [[block]] struct Camera {
            [[offset(0)]] view : mat4x4<f32>;
            [[offset(64)]] projection: mat4x4<f32>;
        };
        [[group(0), binding(0)]] var<uniform> camera : Camera;

        [[location(0)]] var<in> position : vec4<f32>;
        [[location(1)]] var<in> color : vec4<f32>;
        [[builtin(position)]] var<out> Position : vec4<f32>;
        [[location(0)]] var<out> Color : vec4<f32>;
        [[stage(vertex)]] fn main() -> void {
            Position = camera.projection * camera.view * position;
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
    
    let bindGroupLayout = device.createBindGroupLayout(descriptor: BindGroupLayoutDescriptor(
        entries: [
            BindGroupLayoutEntry(
                binding: 0,
                visibility: .vertex,
                buffer: BufferBindingLayout(type: .uniform))]))
    
    let pipelineLayout = device.createPipelineLayout(descriptor: PipelineLayoutDescriptor(
        bindGroupLayouts: [bindGroupLayout]))
    
    let pipeline = device.createRenderPipeline2(descriptor: RenderPipelineDescriptor2(
        layout: pipelineLayout,
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
        depthStencil: DepthStencilState(
            format: .depth24Plus,
            depthWriteEnabled: true,
            depthCompare: .less),
        fragment: FragmentState(
            module: fragmentShader,
            entryPoint: "main",
            targets: [
                ColorTargetState(
                    format: window.preferredTextureFormat)])))
    
    let vertexBuffer = cubeVertices.withUnsafeBytes { vertexBytes -> Buffer in
        let vertexBuffer = device.createBuffer(descriptor: BufferDescriptor(
            usage: .vertex,
            size: UInt64(vertexBytes.count),
            mappedAtCreation: true))
        let ptr = vertexBuffer.getMappedRange(offset: 0, size: 0)
        ptr?.copyMemory(from: vertexBytes.baseAddress!, byteCount: vertexBytes.count)
        vertexBuffer.unmap()
        return vertexBuffer
    }
    
    let indexBuffer = cubeIndices.withUnsafeBytes { indexBytes -> Buffer in
        let indexBuffer = device.createBuffer(descriptor: BufferDescriptor(
            usage: .index,
            size: UInt64(indexBytes.count),
            mappedAtCreation: true))
        let ptr = indexBuffer.getMappedRange(offset: 0, size: 0)
        ptr?.copyMemory(from: indexBytes.baseAddress!, byteCount: indexBytes.count)
        indexBuffer.unmap()
        return indexBuffer
    }
    
    var camera = Camera(view: mat4(), projection: SGLMath.perspective(45, 800/600, 1, 100))

    let cameraBuffer = device.createBuffer(descriptor: BufferDescriptor(
        usage: [.uniform, .copyDst],
        size: UInt64(MemoryLayout<Camera>.size)))
    
    let bindGroup = device.createBindGroup(descriptor: BindGroupDescriptor(
        layout: bindGroupLayout,
        entries: [
            BindGroupEntry(binding: 0,
                           buffer: cameraBuffer,
                           size: UInt64(MemoryLayout<Camera>.size))]))
    
    let depthStencilView = device.createTexture(descriptor: TextureDescriptor(
        usage: .renderAttachment,
        size: Extent3d(width: 800, height: 600),
        format: .depth24Plus)
    ).createView()
    
    var rotation: Float = 0.0
    
    repeat {
        rotation = (rotation + 0.5).truncatingRemainder(dividingBy: 360)
        camera.view = SGLMath.lookAt(
            vec3(6 * sin(radians(rotation)), 2, 6 * cos(radians(rotation))),
            vec3(0, 0, 0),
            vec3(0, 1, 0))
        
        withUnsafeBytes(of: &camera) { cameraBytes in
            device.queue.writeBuffer(cameraBuffer, bufferOffset: 0, data: cameraBytes)
        }
        
        let encoder = device.createCommandEncoder()
        
        let renderPass = encoder.beginRenderPass(descriptor: RenderPassDescriptor(
            colorAttachments: [
                RenderPassColorAttachment(
                    view: swapchain.currentTextureView,
                    loadOp: .clear,
                    storeOp: .store,
                    clearColor: Color(r: 0, g: 0, b: 0, a: 1))],
            depthStencilAttachment: RenderPassDepthStencilAttachment(
                view: depthStencilView,
                depthLoadOp: .clear,
                depthStoreOp: .store,
                clearDepth: 1,
                stencilLoadOp: .clear,
                stencilStoreOp: .store)))
        renderPass.setPipeline(pipeline)
        renderPass.setBindGroup(groupIndex: 0, group: bindGroup)
        renderPass.setVertexBuffer(slot: 0, buffer: vertexBuffer)
        renderPass.setIndexBuffer(indexBuffer, format: .uint32)
        renderPass.drawIndexed(indexCount: UInt32(cubeIndices.count))
        renderPass.endPass()
        
        let commandBuffer = encoder.finish()
        device.queue.submit(commands: [commandBuffer])
        
        swapchain.present()
        pollEvents()
        
    } while !window.shouldClose

}
