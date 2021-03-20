import CWebGPU

public struct AdapterProperties {
    public var deviceId: UInt32
    public var vendorId: UInt32
    public var name: UnsafePointer<CChar>!
    public var driverDescription: UnsafePointer<CChar>!
    public var adapterType: WGPUAdapterType
    public var backendType: WGPUBackendType

    func withCStruct<R>(_ body: (UnsafePointer<WGPUAdapterProperties>) throws -> R) rethrows -> R {
        var cStruct = WGPUAdapterProperties(
            nextInChain: nil, 
            deviceID: self.deviceId, 
            vendorID: self.vendorId, 
            name: self.name, 
            driverDescription: self.driverDescription, 
            adapterType: self.adapterType, 
            backendType: self.backendType
        )
        return try body(&cStruct)
    }
}

public struct BindGroupEntry {
    public var binding: UInt32
    public var buffer: WGPUBuffer
    public var offset: UInt64
    public var size: UInt64
    public var sampler: WGPUSampler
    public var textureView: WGPUTextureView

    func withCStruct<R>(_ body: (UnsafePointer<WGPUBindGroupEntry>) throws -> R) rethrows -> R {
        var cStruct = WGPUBindGroupEntry(
            binding: self.binding, 
            buffer: self.buffer, 
            offset: self.offset, 
            size: self.size, 
            sampler: self.sampler, 
            textureView: self.textureView
        )
        return try body(&cStruct)
    }
}

public struct BindGroupDescriptor {
    public var label: UnsafePointer<CChar>!
    public var layout: WGPUBindGroupLayout
    public var entryCount: UInt32
    public var entries: UnsafePointer<WGPUBindGroupEntry>!

    func withCStruct<R>(_ body: (UnsafePointer<WGPUBindGroupDescriptor>) throws -> R) rethrows -> R {
        var cStruct = WGPUBindGroupDescriptor(
            nextInChain: nil, 
            label: self.label, 
            layout: self.layout, 
            entryCount: self.entryCount, 
            entries: self.entries
        )
        return try body(&cStruct)
    }
}

public struct BufferBindingLayout {
    public var type: WGPUBufferBindingType
    public var hasDynamicOffset: Bool
    public var minBindingSize: UInt64

    func withCStruct<R>(_ body: (UnsafePointer<WGPUBufferBindingLayout>) throws -> R) rethrows -> R {
        var cStruct = WGPUBufferBindingLayout(
            nextInChain: nil, 
            type: self.type, 
            hasDynamicOffset: self.hasDynamicOffset, 
            minBindingSize: self.minBindingSize
        )
        return try body(&cStruct)
    }
}

public struct SamplerBindingLayout {
    public var type: WGPUSamplerBindingType

    func withCStruct<R>(_ body: (UnsafePointer<WGPUSamplerBindingLayout>) throws -> R) rethrows -> R {
        var cStruct = WGPUSamplerBindingLayout(
            nextInChain: nil, 
            type: self.type
        )
        return try body(&cStruct)
    }
}

public struct TextureBindingLayout {
    public var sampleType: WGPUTextureSampleType
    public var viewDimension: WGPUTextureViewDimension
    public var multisampled: Bool

    func withCStruct<R>(_ body: (UnsafePointer<WGPUTextureBindingLayout>) throws -> R) rethrows -> R {
        var cStruct = WGPUTextureBindingLayout(
            nextInChain: nil, 
            sampleType: self.sampleType, 
            viewDimension: self.viewDimension, 
            multisampled: self.multisampled
        )
        return try body(&cStruct)
    }
}

public struct StorageTextureBindingLayout {
    public var access: WGPUStorageTextureAccess
    public var format: WGPUTextureFormat
    public var viewDimension: WGPUTextureViewDimension

    func withCStruct<R>(_ body: (UnsafePointer<WGPUStorageTextureBindingLayout>) throws -> R) rethrows -> R {
        var cStruct = WGPUStorageTextureBindingLayout(
            nextInChain: nil, 
            access: self.access, 
            format: self.format, 
            viewDimension: self.viewDimension
        )
        return try body(&cStruct)
    }
}

public struct BindGroupLayoutEntry {
    public var binding: UInt32
    public var visibility: WGPUShaderStageFlags
    public var type: WGPUBindingType
    public var hasDynamicOffset: Bool
    public var minBufferBindingSize: UInt64
    public var viewDimension: WGPUTextureViewDimension
    public var textureComponentType: WGPUTextureComponentType
    public var storageTextureFormat: WGPUTextureFormat
    public var buffer: WGPUBufferBindingLayout
    public var sampler: WGPUSamplerBindingLayout
    public var texture: WGPUTextureBindingLayout
    public var storageTexture: WGPUStorageTextureBindingLayout

    func withCStruct<R>(_ body: (UnsafePointer<WGPUBindGroupLayoutEntry>) throws -> R) rethrows -> R {
        var cStruct = WGPUBindGroupLayoutEntry(
            nextInChain: nil, 
            binding: self.binding, 
            visibility: self.visibility, 
            type: self.type, 
            hasDynamicOffset: self.hasDynamicOffset, 
            minBufferBindingSize: self.minBufferBindingSize, 
            viewDimension: self.viewDimension, 
            textureComponentType: self.textureComponentType, 
            storageTextureFormat: self.storageTextureFormat, 
            buffer: self.buffer, 
            sampler: self.sampler, 
            texture: self.texture, 
            storageTexture: self.storageTexture
        )
        return try body(&cStruct)
    }
}

public struct BindGroupLayoutDescriptor {
    public var label: UnsafePointer<CChar>!
    public var entryCount: UInt32
    public var entries: UnsafePointer<WGPUBindGroupLayoutEntry>!

    func withCStruct<R>(_ body: (UnsafePointer<WGPUBindGroupLayoutDescriptor>) throws -> R) rethrows -> R {
        var cStruct = WGPUBindGroupLayoutDescriptor(
            nextInChain: nil, 
            label: self.label, 
            entryCount: self.entryCount, 
            entries: self.entries
        )
        return try body(&cStruct)
    }
}

public struct BlendDescriptor {
    public var operation: WGPUBlendOperation
    public var srcFactor: WGPUBlendFactor
    public var dstFactor: WGPUBlendFactor

    func withCStruct<R>(_ body: (UnsafePointer<WGPUBlendDescriptor>) throws -> R) rethrows -> R {
        var cStruct = WGPUBlendDescriptor(
            operation: self.operation, 
            srcFactor: self.srcFactor, 
            dstFactor: self.dstFactor
        )
        return try body(&cStruct)
    }
}

public struct ColorStateDescriptor {
    public var format: WGPUTextureFormat
    public var alphaBlend: WGPUBlendDescriptor
    public var colorBlend: WGPUBlendDescriptor
    public var writeMask: WGPUColorWriteMaskFlags

    func withCStruct<R>(_ body: (UnsafePointer<WGPUColorStateDescriptor>) throws -> R) rethrows -> R {
        var cStruct = WGPUColorStateDescriptor(
            nextInChain: nil, 
            format: self.format, 
            alphaBlend: self.alphaBlend, 
            colorBlend: self.colorBlend, 
            writeMask: self.writeMask
        )
        return try body(&cStruct)
    }
}

public struct BufferCopyView {
    public var layout: WGPUTextureDataLayout
    public var buffer: WGPUBuffer

    func withCStruct<R>(_ body: (UnsafePointer<WGPUBufferCopyView>) throws -> R) rethrows -> R {
        var cStruct = WGPUBufferCopyView(
            nextInChain: nil, 
            layout: self.layout, 
            buffer: self.buffer
        )
        return try body(&cStruct)
    }
}

public struct BufferDescriptor {
    public var label: UnsafePointer<CChar>!
    public var usage: WGPUBufferUsageFlags
    public var size: UInt64
    public var mappedAtCreation: Bool

    func withCStruct<R>(_ body: (UnsafePointer<WGPUBufferDescriptor>) throws -> R) rethrows -> R {
        var cStruct = WGPUBufferDescriptor(
            nextInChain: nil, 
            label: self.label, 
            usage: self.usage, 
            size: self.size, 
            mappedAtCreation: self.mappedAtCreation
        )
        return try body(&cStruct)
    }
}

public struct Color {
    public var r: Double
    public var g: Double
    public var b: Double
    public var a: Double

    func withCStruct<R>(_ body: (UnsafePointer<WGPUColor>) throws -> R) rethrows -> R {
        var cStruct = WGPUColor(
            r: self.r, 
            g: self.g, 
            b: self.b, 
            a: self.a
        )
        return try body(&cStruct)
    }
}

public struct CommandBufferDescriptor {
    public var label: UnsafePointer<CChar>!

    func withCStruct<R>(_ body: (UnsafePointer<WGPUCommandBufferDescriptor>) throws -> R) rethrows -> R {
        var cStruct = WGPUCommandBufferDescriptor(
            nextInChain: nil, 
            label: self.label
        )
        return try body(&cStruct)
    }
}

public struct CommandEncoderDescriptor {
    public var label: UnsafePointer<CChar>!

    func withCStruct<R>(_ body: (UnsafePointer<WGPUCommandEncoderDescriptor>) throws -> R) rethrows -> R {
        var cStruct = WGPUCommandEncoderDescriptor(
            nextInChain: nil, 
            label: self.label
        )
        return try body(&cStruct)
    }
}

public struct ComputePassDescriptor {
    public var label: UnsafePointer<CChar>!

    func withCStruct<R>(_ body: (UnsafePointer<WGPUComputePassDescriptor>) throws -> R) rethrows -> R {
        var cStruct = WGPUComputePassDescriptor(
            nextInChain: nil, 
            label: self.label
        )
        return try body(&cStruct)
    }
}

public struct ComputePipelineDescriptor {
    public var label: UnsafePointer<CChar>!
    public var layout: WGPUPipelineLayout
    public var computeStage: WGPUProgrammableStageDescriptor

    func withCStruct<R>(_ body: (UnsafePointer<WGPUComputePipelineDescriptor>) throws -> R) rethrows -> R {
        var cStruct = WGPUComputePipelineDescriptor(
            nextInChain: nil, 
            label: self.label, 
            layout: self.layout, 
            computeStage: self.computeStage
        )
        return try body(&cStruct)
    }
}

public struct CopyTextureForBrowserOptions {
    public var flipy: Bool

    func withCStruct<R>(_ body: (UnsafePointer<WGPUCopyTextureForBrowserOptions>) throws -> R) rethrows -> R {
        var cStruct = WGPUCopyTextureForBrowserOptions(
            nextInChain: nil, 
            flipY: self.flipy
        )
        return try body(&cStruct)
    }
}

public struct DeviceProperties {
    public var textureCompressionBc: Bool
    public var shaderFloat16: Bool
    public var pipelineStatisticsQuery: Bool
    public var timestampQuery: Bool
    public var multiPlanarFormats: Bool

    func withCStruct<R>(_ body: (UnsafePointer<WGPUDeviceProperties>) throws -> R) rethrows -> R {
        var cStruct = WGPUDeviceProperties(
            textureCompressionBC: self.textureCompressionBc, 
            shaderFloat16: self.shaderFloat16, 
            pipelineStatisticsQuery: self.pipelineStatisticsQuery, 
            timestampQuery: self.timestampQuery, 
            multiPlanarFormats: self.multiPlanarFormats
        )
        return try body(&cStruct)
    }
}

public struct DepthStencilStateDescriptor {
    public var format: WGPUTextureFormat
    public var depthWriteEnabled: Bool
    public var depthCompare: WGPUCompareFunction
    public var stencilFront: WGPUStencilStateFaceDescriptor
    public var stencilBack: WGPUStencilStateFaceDescriptor
    public var stencilReadMask: UInt32
    public var stencilWriteMask: UInt32

    func withCStruct<R>(_ body: (UnsafePointer<WGPUDepthStencilStateDescriptor>) throws -> R) rethrows -> R {
        var cStruct = WGPUDepthStencilStateDescriptor(
            nextInChain: nil, 
            format: self.format, 
            depthWriteEnabled: self.depthWriteEnabled, 
            depthCompare: self.depthCompare, 
            stencilFront: self.stencilFront, 
            stencilBack: self.stencilBack, 
            stencilReadMask: self.stencilReadMask, 
            stencilWriteMask: self.stencilWriteMask
        )
        return try body(&cStruct)
    }
}

public struct Extent3d {
    public var width: UInt32
    public var height: UInt32
    public var depth: UInt32

    func withCStruct<R>(_ body: (UnsafePointer<WGPUExtent3D>) throws -> R) rethrows -> R {
        var cStruct = WGPUExtent3D(
            width: self.width, 
            height: self.height, 
            depth: self.depth
        )
        return try body(&cStruct)
    }
}

public struct FenceDescriptor {
    public var label: UnsafePointer<CChar>!
    public var initialValue: UInt64

    func withCStruct<R>(_ body: (UnsafePointer<WGPUFenceDescriptor>) throws -> R) rethrows -> R {
        var cStruct = WGPUFenceDescriptor(
            nextInChain: nil, 
            label: self.label, 
            initialValue: self.initialValue
        )
        return try body(&cStruct)
    }
}

public struct InstanceDescriptor {

    func withCStruct<R>(_ body: (UnsafePointer<WGPUInstanceDescriptor>) throws -> R) rethrows -> R {
        var cStruct = WGPUInstanceDescriptor(
            nextInChain: nil
        )
        return try body(&cStruct)
    }
}

public struct VertexAttribute {
    public var format: WGPUVertexFormat
    public var offset: UInt64
    public var shaderLocation: UInt32

    func withCStruct<R>(_ body: (UnsafePointer<WGPUVertexAttribute>) throws -> R) rethrows -> R {
        var cStruct = WGPUVertexAttribute(
            format: self.format, 
            offset: self.offset, 
            shaderLocation: self.shaderLocation
        )
        return try body(&cStruct)
    }
}

public struct VertexBufferLayout {
    public var arrayStride: UInt64
    public var stepMode: WGPUInputStepMode
    public var attributeCount: UInt32
    public var attributes: UnsafePointer<WGPUVertexAttribute>!

    func withCStruct<R>(_ body: (UnsafePointer<WGPUVertexBufferLayout>) throws -> R) rethrows -> R {
        var cStruct = WGPUVertexBufferLayout(
            arrayStride: self.arrayStride, 
            stepMode: self.stepMode, 
            attributeCount: self.attributeCount, 
            attributes: self.attributes
        )
        return try body(&cStruct)
    }
}

public struct VertexStateDescriptor {
    public var indexFormat: WGPUIndexFormat
    public var vertexBufferCount: UInt32
    public var vertexBuffers: UnsafePointer<WGPUVertexBufferLayout>!

    func withCStruct<R>(_ body: (UnsafePointer<WGPUVertexStateDescriptor>) throws -> R) rethrows -> R {
        var cStruct = WGPUVertexStateDescriptor(
            nextInChain: nil, 
            indexFormat: self.indexFormat, 
            vertexBufferCount: self.vertexBufferCount, 
            vertexBuffers: self.vertexBuffers
        )
        return try body(&cStruct)
    }
}

public struct Origin3d {
    public var x: UInt32
    public var y: UInt32
    public var z: UInt32

    func withCStruct<R>(_ body: (UnsafePointer<WGPUOrigin3D>) throws -> R) rethrows -> R {
        var cStruct = WGPUOrigin3D(
            x: self.x, 
            y: self.y, 
            z: self.z
        )
        return try body(&cStruct)
    }
}

public struct PipelineLayoutDescriptor {
    public var label: UnsafePointer<CChar>!
    public var bindGroupLayoutCount: UInt32
    public var bindGroupLayouts: UnsafePointer<WGPUBindGroupLayout?>!

    func withCStruct<R>(_ body: (UnsafePointer<WGPUPipelineLayoutDescriptor>) throws -> R) rethrows -> R {
        var cStruct = WGPUPipelineLayoutDescriptor(
            nextInChain: nil, 
            label: self.label, 
            bindGroupLayoutCount: self.bindGroupLayoutCount, 
            bindGroupLayouts: self.bindGroupLayouts
        )
        return try body(&cStruct)
    }
}

public struct ProgrammableStageDescriptor {
    public var module: WGPUShaderModule
    public var entryPoint: UnsafePointer<CChar>!

    func withCStruct<R>(_ body: (UnsafePointer<WGPUProgrammableStageDescriptor>) throws -> R) rethrows -> R {
        var cStruct = WGPUProgrammableStageDescriptor(
            nextInChain: nil, 
            module: self.module, 
            entryPoint: self.entryPoint
        )
        return try body(&cStruct)
    }
}

public struct QuerySetDescriptor {
    public var label: UnsafePointer<CChar>!
    public var type: WGPUQueryType
    public var count: UInt32
    public var pipelineStatistics: UnsafePointer<WGPUPipelineStatisticName>!
    public var pipelineStatisticsCount: UInt32

    func withCStruct<R>(_ body: (UnsafePointer<WGPUQuerySetDescriptor>) throws -> R) rethrows -> R {
        var cStruct = WGPUQuerySetDescriptor(
            nextInChain: nil, 
            label: self.label, 
            type: self.type, 
            count: self.count, 
            pipelineStatistics: self.pipelineStatistics, 
            pipelineStatisticsCount: self.pipelineStatisticsCount
        )
        return try body(&cStruct)
    }
}

public struct RasterizationStateDescriptor {
    public var frontFace: WGPUFrontFace
    public var cullMode: WGPUCullMode
    public var depthBias: Int32
    public var depthBiasSlopeScale: Float
    public var depthBiasClamp: Float

    func withCStruct<R>(_ body: (UnsafePointer<WGPURasterizationStateDescriptor>) throws -> R) rethrows -> R {
        var cStruct = WGPURasterizationStateDescriptor(
            nextInChain: nil, 
            frontFace: self.frontFace, 
            cullMode: self.cullMode, 
            depthBias: self.depthBias, 
            depthBiasSlopeScale: self.depthBiasSlopeScale, 
            depthBiasClamp: self.depthBiasClamp
        )
        return try body(&cStruct)
    }
}

public struct RenderBundleDescriptor {
    public var label: UnsafePointer<CChar>!

    func withCStruct<R>(_ body: (UnsafePointer<WGPURenderBundleDescriptor>) throws -> R) rethrows -> R {
        var cStruct = WGPURenderBundleDescriptor(
            nextInChain: nil, 
            label: self.label
        )
        return try body(&cStruct)
    }
}

public struct RenderBundleEncoderDescriptor {
    public var label: UnsafePointer<CChar>!
    public var colorFormatsCount: UInt32
    public var colorFormats: UnsafePointer<WGPUTextureFormat>!
    public var depthStencilFormat: WGPUTextureFormat
    public var sampleCount: UInt32

    func withCStruct<R>(_ body: (UnsafePointer<WGPURenderBundleEncoderDescriptor>) throws -> R) rethrows -> R {
        var cStruct = WGPURenderBundleEncoderDescriptor(
            nextInChain: nil, 
            label: self.label, 
            colorFormatsCount: self.colorFormatsCount, 
            colorFormats: self.colorFormats, 
            depthStencilFormat: self.depthStencilFormat, 
            sampleCount: self.sampleCount
        )
        return try body(&cStruct)
    }
}

public struct RenderPassColorAttachmentDescriptor {
    public var attachment: WGPUTextureView
    public var resolveTarget: WGPUTextureView
    public var loadOp: WGPULoadOp
    public var storeOp: WGPUStoreOp
    public var clearColor: WGPUColor

    func withCStruct<R>(_ body: (UnsafePointer<WGPURenderPassColorAttachmentDescriptor>) throws -> R) rethrows -> R {
        var cStruct = WGPURenderPassColorAttachmentDescriptor(
            attachment: self.attachment, 
            resolveTarget: self.resolveTarget, 
            loadOp: self.loadOp, 
            storeOp: self.storeOp, 
            clearColor: self.clearColor
        )
        return try body(&cStruct)
    }
}

public struct RenderPassDepthStencilAttachmentDescriptor {
    public var attachment: WGPUTextureView
    public var depthLoadOp: WGPULoadOp
    public var depthStoreOp: WGPUStoreOp
    public var clearDepth: Float
    public var depthReadOnly: Bool
    public var stencilLoadOp: WGPULoadOp
    public var stencilStoreOp: WGPUStoreOp
    public var clearStencil: UInt32
    public var stencilReadOnly: Bool

    func withCStruct<R>(_ body: (UnsafePointer<WGPURenderPassDepthStencilAttachmentDescriptor>) throws -> R) rethrows -> R {
        var cStruct = WGPURenderPassDepthStencilAttachmentDescriptor(
            attachment: self.attachment, 
            depthLoadOp: self.depthLoadOp, 
            depthStoreOp: self.depthStoreOp, 
            clearDepth: self.clearDepth, 
            depthReadOnly: self.depthReadOnly, 
            stencilLoadOp: self.stencilLoadOp, 
            stencilStoreOp: self.stencilStoreOp, 
            clearStencil: self.clearStencil, 
            stencilReadOnly: self.stencilReadOnly
        )
        return try body(&cStruct)
    }
}

public struct RenderPassDescriptor {
    public var label: UnsafePointer<CChar>!
    public var colorAttachmentCount: UInt32
    public var colorAttachments: UnsafePointer<WGPURenderPassColorAttachmentDescriptor>!
    public var depthStencilAttachment: UnsafePointer<WGPURenderPassDepthStencilAttachmentDescriptor>!
    public var occlusionQuerySet: WGPUQuerySet

    func withCStruct<R>(_ body: (UnsafePointer<WGPURenderPassDescriptor>) throws -> R) rethrows -> R {
        var cStruct = WGPURenderPassDescriptor(
            nextInChain: nil, 
            label: self.label, 
            colorAttachmentCount: self.colorAttachmentCount, 
            colorAttachments: self.colorAttachments, 
            depthStencilAttachment: self.depthStencilAttachment, 
            occlusionQuerySet: self.occlusionQuerySet
        )
        return try body(&cStruct)
    }
}

public struct RenderPipelineDescriptor {
    public var label: UnsafePointer<CChar>!
    public var layout: WGPUPipelineLayout
    public var vertexStage: WGPUProgrammableStageDescriptor
    public var fragmentStage: UnsafePointer<WGPUProgrammableStageDescriptor>!
    public var vertexState: UnsafePointer<WGPUVertexStateDescriptor>!
    public var primitiveTopology: WGPUPrimitiveTopology
    public var rasterizationState: UnsafePointer<WGPURasterizationStateDescriptor>!
    public var sampleCount: UInt32
    public var depthStencilState: UnsafePointer<WGPUDepthStencilStateDescriptor>!
    public var colorStateCount: UInt32
    public var colorStates: UnsafePointer<WGPUColorStateDescriptor>!
    public var sampleMask: UInt32
    public var alphaToCoverageEnabled: Bool

    func withCStruct<R>(_ body: (UnsafePointer<WGPURenderPipelineDescriptor>) throws -> R) rethrows -> R {
        var cStruct = WGPURenderPipelineDescriptor(
            nextInChain: nil, 
            label: self.label, 
            layout: self.layout, 
            vertexStage: self.vertexStage, 
            fragmentStage: self.fragmentStage, 
            vertexState: self.vertexState, 
            primitiveTopology: self.primitiveTopology, 
            rasterizationState: self.rasterizationState, 
            sampleCount: self.sampleCount, 
            depthStencilState: self.depthStencilState, 
            colorStateCount: self.colorStateCount, 
            colorStates: self.colorStates, 
            sampleMask: self.sampleMask, 
            alphaToCoverageEnabled: self.alphaToCoverageEnabled
        )
        return try body(&cStruct)
    }
}

public struct RenderPipelineDescriptorDummyExtension {
    public var dummyStage: WGPUProgrammableStageDescriptor

    func withCStruct<R>(_ body: (UnsafePointer<WGPURenderPipelineDescriptorDummyExtension>) throws -> R) rethrows -> R {
        var cStruct = WGPURenderPipelineDescriptorDummyExtension(
            chain: WGPUChainedStruct(), 
            dummyStage: self.dummyStage
        )
        return try body(&cStruct)
    }
}

public struct SamplerDescriptor {
    public var label: UnsafePointer<CChar>!
    public var addressModeU: WGPUAddressMode
    public var addressModeV: WGPUAddressMode
    public var addressModeW: WGPUAddressMode
    public var magFilter: WGPUFilterMode
    public var minFilter: WGPUFilterMode
    public var mipmapFilter: WGPUFilterMode
    public var lodMinClamp: Float
    public var lodMaxClamp: Float
    public var compare: WGPUCompareFunction
    public var maxAnisotropy: UInt16

    func withCStruct<R>(_ body: (UnsafePointer<WGPUSamplerDescriptor>) throws -> R) rethrows -> R {
        var cStruct = WGPUSamplerDescriptor(
            nextInChain: nil, 
            label: self.label, 
            addressModeU: self.addressModeU, 
            addressModeV: self.addressModeV, 
            addressModeW: self.addressModeW, 
            magFilter: self.magFilter, 
            minFilter: self.minFilter, 
            mipmapFilter: self.mipmapFilter, 
            lodMinClamp: self.lodMinClamp, 
            lodMaxClamp: self.lodMaxClamp, 
            compare: self.compare, 
            maxAnisotropy: self.maxAnisotropy
        )
        return try body(&cStruct)
    }
}

public struct SamplerDescriptorDummyAnisotropicFiltering {
    public var maxAnisotropy: Float

    func withCStruct<R>(_ body: (UnsafePointer<WGPUSamplerDescriptorDummyAnisotropicFiltering>) throws -> R) rethrows -> R {
        var cStruct = WGPUSamplerDescriptorDummyAnisotropicFiltering(
            chain: WGPUChainedStruct(), 
            maxAnisotropy: self.maxAnisotropy
        )
        return try body(&cStruct)
    }
}

public struct ShaderModuleDescriptor {
    public var label: UnsafePointer<CChar>!

    func withCStruct<R>(_ body: (UnsafePointer<WGPUShaderModuleDescriptor>) throws -> R) rethrows -> R {
        var cStruct = WGPUShaderModuleDescriptor(
            nextInChain: nil, 
            label: self.label
        )
        return try body(&cStruct)
    }
}

public struct ShaderModuleSpirvDescriptor {
    public var codeSize: UInt32
    public var code: UnsafePointer<UInt32>!

    func withCStruct<R>(_ body: (UnsafePointer<WGPUShaderModuleSPIRVDescriptor>) throws -> R) rethrows -> R {
        var cStruct = WGPUShaderModuleSPIRVDescriptor(
            chain: WGPUChainedStruct(), 
            codeSize: self.codeSize, 
            code: self.code
        )
        return try body(&cStruct)
    }
}

public struct ShaderModuleWgslDescriptor {
    public var source: UnsafePointer<CChar>!

    func withCStruct<R>(_ body: (UnsafePointer<WGPUShaderModuleWGSLDescriptor>) throws -> R) rethrows -> R {
        var cStruct = WGPUShaderModuleWGSLDescriptor(
            chain: WGPUChainedStruct(), 
            source: self.source
        )
        return try body(&cStruct)
    }
}

public struct StencilStateFaceDescriptor {
    public var compare: WGPUCompareFunction
    public var failOp: WGPUStencilOperation
    public var depthFailOp: WGPUStencilOperation
    public var passOp: WGPUStencilOperation

    func withCStruct<R>(_ body: (UnsafePointer<WGPUStencilStateFaceDescriptor>) throws -> R) rethrows -> R {
        var cStruct = WGPUStencilStateFaceDescriptor(
            compare: self.compare, 
            failOp: self.failOp, 
            depthFailOp: self.depthFailOp, 
            passOp: self.passOp
        )
        return try body(&cStruct)
    }
}

public struct SurfaceDescriptor {
    public var label: UnsafePointer<CChar>!

    func withCStruct<R>(_ body: (UnsafePointer<WGPUSurfaceDescriptor>) throws -> R) rethrows -> R {
        var cStruct = WGPUSurfaceDescriptor(
            nextInChain: nil, 
            label: self.label
        )
        return try body(&cStruct)
    }
}

public struct SurfaceDescriptorFromCanvasHtmlSelector {
    public var selector: UnsafePointer<CChar>!

    func withCStruct<R>(_ body: (UnsafePointer<WGPUSurfaceDescriptorFromCanvasHTMLSelector>) throws -> R) rethrows -> R {
        var cStruct = WGPUSurfaceDescriptorFromCanvasHTMLSelector(
            chain: WGPUChainedStruct(), 
            selector: self.selector
        )
        return try body(&cStruct)
    }
}

public struct SurfaceDescriptorFromMetalLayer {
    public var layer: UnsafeMutableRawPointer!

    func withCStruct<R>(_ body: (UnsafePointer<WGPUSurfaceDescriptorFromMetalLayer>) throws -> R) rethrows -> R {
        var cStruct = WGPUSurfaceDescriptorFromMetalLayer(
            chain: WGPUChainedStruct(), 
            layer: self.layer
        )
        return try body(&cStruct)
    }
}

public struct SurfaceDescriptorFromWindowsHwnd {
    public var hinstance: UnsafeMutableRawPointer!
    public var hwnd: UnsafeMutableRawPointer!

    func withCStruct<R>(_ body: (UnsafePointer<WGPUSurfaceDescriptorFromWindowsHWND>) throws -> R) rethrows -> R {
        var cStruct = WGPUSurfaceDescriptorFromWindowsHWND(
            chain: WGPUChainedStruct(), 
            hinstance: self.hinstance, 
            hwnd: self.hwnd
        )
        return try body(&cStruct)
    }
}

public struct SurfaceDescriptorFromXlib {
    public var display: UnsafeMutableRawPointer!
    public var window: UInt32

    func withCStruct<R>(_ body: (UnsafePointer<WGPUSurfaceDescriptorFromXlib>) throws -> R) rethrows -> R {
        var cStruct = WGPUSurfaceDescriptorFromXlib(
            chain: WGPUChainedStruct(), 
            display: self.display, 
            window: self.window
        )
        return try body(&cStruct)
    }
}

public struct SwapChainDescriptor {
    public var label: UnsafePointer<CChar>!
    public var usage: WGPUTextureUsageFlags
    public var format: WGPUTextureFormat
    public var width: UInt32
    public var height: UInt32
    public var presentMode: WGPUPresentMode
    public var implementation: UInt64

    func withCStruct<R>(_ body: (UnsafePointer<WGPUSwapChainDescriptor>) throws -> R) rethrows -> R {
        var cStruct = WGPUSwapChainDescriptor(
            nextInChain: nil, 
            label: self.label, 
            usage: self.usage, 
            format: self.format, 
            width: self.width, 
            height: self.height, 
            presentMode: self.presentMode, 
            implementation: self.implementation
        )
        return try body(&cStruct)
    }
}

public struct TextureCopyView {
    public var texture: WGPUTexture
    public var mipLevel: UInt32
    public var origin: WGPUOrigin3D
    public var aspect: WGPUTextureAspect

    func withCStruct<R>(_ body: (UnsafePointer<WGPUTextureCopyView>) throws -> R) rethrows -> R {
        var cStruct = WGPUTextureCopyView(
            nextInChain: nil, 
            texture: self.texture, 
            mipLevel: self.mipLevel, 
            origin: self.origin, 
            aspect: self.aspect
        )
        return try body(&cStruct)
    }
}

public struct TextureDataLayout {
    public var offset: UInt64
    public var bytesPerRow: UInt32
    public var rowsPerImage: UInt32

    func withCStruct<R>(_ body: (UnsafePointer<WGPUTextureDataLayout>) throws -> R) rethrows -> R {
        var cStruct = WGPUTextureDataLayout(
            nextInChain: nil, 
            offset: self.offset, 
            bytesPerRow: self.bytesPerRow, 
            rowsPerImage: self.rowsPerImage
        )
        return try body(&cStruct)
    }
}

public struct TextureDescriptor {
    public var label: UnsafePointer<CChar>!
    public var usage: WGPUTextureUsageFlags
    public var dimension: WGPUTextureDimension
    public var size: WGPUExtent3D
    public var format: WGPUTextureFormat
    public var mipLevelCount: UInt32
    public var sampleCount: UInt32

    func withCStruct<R>(_ body: (UnsafePointer<WGPUTextureDescriptor>) throws -> R) rethrows -> R {
        var cStruct = WGPUTextureDescriptor(
            nextInChain: nil, 
            label: self.label, 
            usage: self.usage, 
            dimension: self.dimension, 
            size: self.size, 
            format: self.format, 
            mipLevelCount: self.mipLevelCount, 
            sampleCount: self.sampleCount
        )
        return try body(&cStruct)
    }
}

public struct TextureViewDescriptor {
    public var label: UnsafePointer<CChar>!
    public var format: WGPUTextureFormat
    public var dimension: WGPUTextureViewDimension
    public var baseMipLevel: UInt32
    public var mipLevelCount: UInt32
    public var baseArrayLayer: UInt32
    public var arrayLayerCount: UInt32
    public var aspect: WGPUTextureAspect

    func withCStruct<R>(_ body: (UnsafePointer<WGPUTextureViewDescriptor>) throws -> R) rethrows -> R {
        var cStruct = WGPUTextureViewDescriptor(
            nextInChain: nil, 
            label: self.label, 
            format: self.format, 
            dimension: self.dimension, 
            baseMipLevel: self.baseMipLevel, 
            mipLevelCount: self.mipLevelCount, 
            baseArrayLayer: self.baseArrayLayer, 
            arrayLayerCount: self.arrayLayerCount, 
            aspect: self.aspect
        )
        return try body(&cStruct)
    }
}

