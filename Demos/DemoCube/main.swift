import WebGPU
import WindowUtils
import SwiftMath

struct Camera {
    var view: Matrix4x4f
    var projection: Matrix4x4f
}

let instance = createInstance()

let adapter = try await instance.requestAdapter()
print("Using adapter: \(adapter.info.device)")

let uncapturedErrorCallback: UncapturedErrorCallback = { device, errorType, errorMessage in
    print("Error (\(errorType)): \(errorMessage)")
}

let device = try await adapter.requestDevice(descriptor: .init(
    uncapturedErrorCallback: uncapturedErrorCallback
))

try withGLFW {
    let window = Window(width: 800, height: 600, title: "DemoCube")
    let surface = instance.createSurface(descriptor: window.surfaceDescriptor)
    surface.configure(config: .init(device: device, format: window.preferredTextureFormat, width: 800, height: 600))
    
    let vertexShaderSource = """
        struct Camera {
            view : mat4x4<f32>,
            projection: mat4x4<f32>
        };
        @group(0) @binding(0) var<uniform> camera : Camera;

        struct VertexOut {
            @builtin(position) position : vec4<f32>,
            @location(0) color : vec4<f32>
        };

        @vertex fn main(
            @location(0) position : vec4<f32>,
            @location(1) color : vec4<f32>) -> VertexOut {
            var output : VertexOut;
            output.position = camera.projection * camera.view * position;
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
                    stepMode: .vertex,
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
    
    try window.loop {
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
                    view: try surface.getCurrentTexture().texture.createView(),
                    loadOp: .clear,
                    storeOp: .store,
                    clearValue: Color(r: 0, g: 0, b: 0, a: 1))],
            depthStencilAttachment: RenderPassDepthStencilAttachment(
                view: depthStencilView,
                depthLoadOp: .clear,
                depthStoreOp: .store,
                depthClearValue: 1)))
        renderPass.setPipeline(pipeline)
        renderPass.setBindGroup(groupIndex: 0, group: bindGroup)
        renderPass.setVertexBuffer(slot: 0, buffer: vertexBuffer)
        renderPass.setIndexBuffer(indexBuffer, format: .uint32)
        renderPass.drawIndexed(indexCount: UInt32(cubeIndices.count))
        renderPass.end()
        
        let commandBuffer = encoder.finish()
        device.queue.submit(commands: [commandBuffer])
        
        surface.present()
    }
}
