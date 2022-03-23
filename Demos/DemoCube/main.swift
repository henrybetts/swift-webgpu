import WebGPU
import DawnNative
import WindowUtils
import SwiftMath

struct Camera {
    var view: Matrix4x4f
    var projection: Matrix4x4f
}

let instance = DawnNative.Instance()

instance.discoverDefaultAdapters()
guard let adapter = instance.adapters.first(where: { $0.properties.backendType != .null }) else {
    fatalError("No adapters found")
}
print("Using adapter: \(adapter.properties.name)")

withGLFW {
    let window = Window(width: 800, height: 600, title: "DemoCube")
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
        [[block]] struct Camera {
            view : mat4x4<f32>;
            projection: mat4x4<f32>;
        };
        [[group(0), binding(0)]] var<uniform> camera : Camera;

        struct VertexOut {
            [[builtin(position)]] position : vec4<f32>;
            [[location(0)]] color : vec4<f32>;
        };

        [[stage(vertex)]] fn main(
            [[location(0)]] position : vec4<f32>,
            [[location(1)]] color : vec4<f32>) -> VertexOut {
            var output : VertexOut;
            output.position = camera.projection * camera.view * position;
            output.color = color;
            return output;
        }
    """
    
    let fragmentShaderSource = """
        [[stage(fragment)]] fn main(
            [[location(0)]] color : vec4<f32>) -> [[location(0)]] vec4<f32> {
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
    
    let bindGroupLayout = device.createBindGroupLayout(descriptor: BindGroupLayoutDescriptor(
        entries: [
            BindGroupLayoutEntry(
                binding: 0,
                visibility: .vertex,
                buffer: BufferBindingLayout(type: .uniform))]))
    
    let pipelineLayout = device.createPipelineLayout(descriptor: PipelineLayoutDescriptor(
        bindGroupLayouts: [bindGroupLayout]))
    
    let pipeline = device.createRenderPipeline(descriptor: RenderPipelineDescriptor(
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
    
    var camera = Camera(
        view: Matrix4x4f(),
        projection: Matrix4x4f.proj(fovy: Angle(degrees: 45), aspect: 800/600, near: 1, far: 100))

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
    
    var rotation = Angle(degrees: 0)
    
    window.loop {
        rotation = (rotation + Angle(degrees: 0.5)) % Angle(degrees: 360)
        camera.view = Matrix4x4f.lookAt(
            eye: vec3(6 * sin(rotation), 2, 6 * cos(rotation)),
            at: vec3(0, 0, 0))
        
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
                    clearValue: Color(r: 0, g: 0, b: 0, a: 1))],
            depthStencilAttachment: RenderPassDepthStencilAttachment(
                view: depthStencilView,
                depthLoadOp: .clear,
                depthStoreOp: .store,
                clearDepth: 1)))
        renderPass.setPipeline(pipeline)
        renderPass.setBindGroup(groupIndex: 0, group: bindGroup)
        renderPass.setVertexBuffer(slot: 0, buffer: vertexBuffer)
        renderPass.setIndexBuffer(indexBuffer, format: .uint32)
        renderPass.drawIndexed(indexCount: UInt32(cubeIndices.count))
        renderPass.endPass()
        
        let commandBuffer = encoder.finish()
        device.queue.submit(commands: [commandBuffer])
        
        swapchain.present()
    }
}
