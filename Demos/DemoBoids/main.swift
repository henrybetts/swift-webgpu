import WebGPU
import WindowUtils

typealias Vector2 = (Float, Float)

struct Particle {
    var position: Vector2
    var velocity: Vector2
}


let numParticles = 1500

let simParams = (
    deltaT: Float(0.025),
    rule1Distance: Float(0.1),
    rule2Distance: Float(0.025),
    rule3Distance: Float(0.025),
    rule1Scale: Float(0.02),
    rule2Scale: Float(0.05),
    rule3Scale: Float(0.005)
)

let vertexData = [
    Vector2(-0.01, -0.02),
    Vector2(0.01, -0.02),
    Vector2(0.0, 0.02)
]


let instance = createInstance()
var device: Device? = nil;

instance.requestAdapter(options: nil, callbackInfo: RequestAdapterCallbackInfo(callback: { (status, adapter, msg) -> () in
    if (status == .success && adapter != nil) {
        print("Using adapter: \(adapter?.info.device)")
        
        let uncapturedErrorCallback: UncapturedErrorCallback = { device, errorType, errorMessage in
            print("Error (\(errorType)): \(errorMessage)")
        }

        adapter?.requestDevice(options: DeviceDescriptor(uncapturedErrorCallback: uncapturedErrorCallback), callbackInfo: RequestDeviceCallbackInfo(callback: { (status, deviceOut, msg) -> () in
            if (status == .success && deviceOut != nil) {
                device = deviceOut
            }
        }))
    }
}))

print("Using device: \(device?.limits)")

try await MainActor.run {

try withGLFW {
    let window = Window(width: 800, height: 600, title: "DemoBoids")
    let surface = instance.createSurface(descriptor: window.surfaceDescriptor)
    surface.configure(config: .init(device: device!, format: window.preferredTextureFormat, width: 800, height: 600))
    
    let renderShader = device!.createShaderModule(
        descriptor: ShaderModuleDescriptor(
            label: nil,
            nextInChain: ShaderSourceWgsl(code: renderShaderSource)))
    
    let renderPipeline = device!.createRenderPipeline(
        descriptor: RenderPipelineDescriptor(
            vertex: VertexState(
                module: renderShader,
                entryPoint: "vert_main",
                buffers: [
                    VertexBufferLayout(
                        arrayStride: UInt64(MemoryLayout<Particle>.stride),
                        stepMode: .instance,
                        attributes: [
                            VertexAttribute(
                                format: .float32x2,
                                offset: UInt64(MemoryLayout.offset(of: \Particle.position)!),
                                shaderLocation: 0),
                            VertexAttribute(
                                format: .float32x2,
                                offset: UInt64(MemoryLayout.offset(of: \Particle.velocity)!),
                                shaderLocation: 1)]),
                    VertexBufferLayout(
                        arrayStride: UInt64(MemoryLayout<Vector2>.stride),
                        stepMode: .vertex,
                        attributes: [
                            VertexAttribute(
                                format: .float32x2,
                                offset: 0,
                                shaderLocation: 2)])]),
            fragment: FragmentState(
                module: renderShader,
                entryPoint: "frag_main",
                targets: [ColorTargetState(format: window.preferredTextureFormat)])))
    
    
    let computeShader = device!.createShaderModule(
        descriptor: ShaderModuleDescriptor(
            label: nil,
            nextInChain: ShaderSourceWgsl(code: computeShaderSource)))
    
    let computePipeline = device!.createComputePipeline(
        descriptor: ComputePipelineDescriptor(
            compute: ComputeState(
                module: computeShader,
                entryPoint: "main")))
    
    
    let vertexBuffer = vertexData.withUnsafeBytes { bytes -> Buffer in
        let buffer = device!.createBuffer(descriptor: BufferDescriptor(
            usage: .vertex,
            size: UInt64(bytes.count),
            mappedAtCreation: true))
        buffer.getMappedRange().copyMemory(from: bytes.baseAddress!, byteCount: bytes.count)
        buffer.unmap()
        return buffer
    }
    
    let simParamBuffer = withUnsafeBytes(of: simParams) { bytes in
        let buffer = device!.createBuffer(descriptor: BufferDescriptor(
            usage: .uniform,
            size: UInt64(bytes.count),
            mappedAtCreation: true))
        buffer.getMappedRange().copyMemory(from: bytes.baseAddress!, byteCount: bytes.count)
        buffer.unmap()
        return buffer
    }

    var particles = [Particle]()
    particles.reserveCapacity(numParticles)
    for _ in 0..<numParticles {
        particles.append(Particle(
            position: Vector2(.random(in: -1...1), .random(in: -1...1)),
            velocity: Vector2(.random(in: -0.1...0.1), .random(in: -0.1...0.1))))
    }
    
    var particleBuffers = [Buffer]()
    var particleBindGroups = [BindGroup]()
    
    particles.withUnsafeBytes { bytes in
        for _ in 0..<2 {
            let buffer = device!.createBuffer(descriptor: BufferDescriptor(
                usage: [.vertex, .storage],
                size: UInt64(bytes.count),
                mappedAtCreation: true))
            buffer.getMappedRange().copyMemory(from: bytes.baseAddress!, byteCount: bytes.count)
            buffer.unmap()
            particleBuffers.append(buffer)
        }
    }
    
    for index in 0..<2 {
        let bindGroup = device!.createBindGroup(descriptor: BindGroupDescriptor(
            layout: computePipeline.getBindGroupLayout(groupIndex: 0),
            entries: [
                BindGroupEntry(
                    binding: 0,
                    buffer: simParamBuffer),
                BindGroupEntry(
                    binding: 1,
                    buffer: particleBuffers[index]),
                BindGroupEntry(
                    binding: 2,
                    buffer: particleBuffers[1 - index])]))
        particleBindGroups.append(bindGroup)
    }
    
    let workGroupCount = UInt32((Float(numParticles) / 64).rounded(.up))
    
    var i = 0
    try window.loop {
        let encoder = device!.createCommandEncoder()
        
        let computePass = encoder.beginComputePass()
        computePass.setPipeline(computePipeline)
        computePass.setBindGroup(groupIndex: 0, group: particleBindGroups[i])
        computePass.dispatchWorkgroups(workgroupcountx: workGroupCount)
        computePass.end()
        
        let renderPass = encoder.beginRenderPass(descriptor: RenderPassDescriptor(
            colorAttachments: [
                RenderPassColorAttachment(
                    view: try surface.getCurrentTexture().texture.createView(),
                    loadOp: .clear,
                    storeOp: .store,
                    clearValue: Color(r: 0, g: 0, b: 0, a: 1))]))
        renderPass.setPipeline(renderPipeline)
        renderPass.setVertexBuffer(slot: 0, buffer: particleBuffers[1 - i])
        renderPass.setVertexBuffer(slot: 1, buffer: vertexBuffer)
        renderPass.draw(vertexCount: 3, instanceCount: UInt32(numParticles))
        renderPass.end()
        
        let commandBuffer = encoder.finish()
        device!.queue.submit(commands: [commandBuffer])
        
        surface.present()
        
        i = 1 - i
    }
}
}
