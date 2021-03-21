import CWebGPU

public struct AdapterProperties {
    public var deviceId: UInt32
    public var vendorId: UInt32
    public var name: String
    public var driverDescription: String
    public var adapterType: AdapterType
    public var backendType: BackendType

    func withCStruct<R>(_ body: (UnsafePointer<WGPUAdapterProperties>) throws -> R) rethrows -> R {
        return try self.name.withCString { cString_name in
        return try self.driverDescription.withCString { cString_driverDescription in
        var cStruct = WGPUAdapterProperties(
            nextInChain: nil, 
            deviceID: self.deviceId, 
            vendorID: self.vendorId, 
            name: cString_name, 
            driverDescription: cString_driverDescription, 
            adapterType: self.adapterType.cValue, 
            backendType: self.backendType.cValue
        )
        return try body(&cStruct)
        }
        }
    }
}

public struct BindGroupEntry {
    public var binding: UInt32
    public var buffer: Buffer?
    public var offset: UInt64
    public var size: UInt64
    public var sampler: Sampler?
    public var textureView: TextureView?

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
    public var label: String?
    public var layout: BindGroupLayout
    public var entryCount: UInt32
    public var entries: [BindGroupEntry]

    func withCStruct<R>(_ body: (UnsafePointer<WGPUBindGroupDescriptor>) throws -> R) rethrows -> R {
        return try self.label.withOptionalCString { cString_label in
        var cStruct = WGPUBindGroupDescriptor(
            nextInChain: nil, 
            label: cString_label, 
            layout: self.layout, 
            entryCount: self.entryCount, 
            entries: self.entries
        )
        return try body(&cStruct)
        }
    }
}

public struct BufferBindingLayout {
    public var type: BufferBindingType
    public var hasDynamicOffset: Bool
    public var minBindingSize: UInt64

    func withCStruct<R>(_ body: (UnsafePointer<WGPUBufferBindingLayout>) throws -> R) rethrows -> R {
        var cStruct = WGPUBufferBindingLayout(
            nextInChain: nil, 
            type: self.type.cValue, 
            hasDynamicOffset: self.hasDynamicOffset, 
            minBindingSize: self.minBindingSize
        )
        return try body(&cStruct)
    }
}

public struct SamplerBindingLayout {
    public var type: SamplerBindingType

    func withCStruct<R>(_ body: (UnsafePointer<WGPUSamplerBindingLayout>) throws -> R) rethrows -> R {
        var cStruct = WGPUSamplerBindingLayout(
            nextInChain: nil, 
            type: self.type.cValue
        )
        return try body(&cStruct)
    }
}

public struct TextureBindingLayout {
    public var sampleType: TextureSampleType
    public var viewDimension: TextureViewDimension
    public var multisampled: Bool

    func withCStruct<R>(_ body: (UnsafePointer<WGPUTextureBindingLayout>) throws -> R) rethrows -> R {
        var cStruct = WGPUTextureBindingLayout(
            nextInChain: nil, 
            sampleType: self.sampleType.cValue, 
            viewDimension: self.viewDimension.cValue, 
            multisampled: self.multisampled
        )
        return try body(&cStruct)
    }
}

public struct StorageTextureBindingLayout {
    public var access: StorageTextureAccess
    public var format: TextureFormat
    public var viewDimension: TextureViewDimension

    func withCStruct<R>(_ body: (UnsafePointer<WGPUStorageTextureBindingLayout>) throws -> R) rethrows -> R {
        var cStruct = WGPUStorageTextureBindingLayout(
            nextInChain: nil, 
            access: self.access.cValue, 
            format: self.format.cValue, 
            viewDimension: self.viewDimension.cValue
        )
        return try body(&cStruct)
    }
}

public struct BindGroupLayoutEntry {
    public var binding: UInt32
    public var visibility: ShaderStage
    public var type: BindingType
    public var hasDynamicOffset: Bool
    public var minBufferBindingSize: UInt64
    public var viewDimension: TextureViewDimension
    public var textureComponentType: TextureComponentType
    public var storageTextureFormat: TextureFormat
    public var buffer: BufferBindingLayout
    public var sampler: SamplerBindingLayout
    public var texture: TextureBindingLayout
    public var storageTexture: StorageTextureBindingLayout

    func withCStruct<R>(_ body: (UnsafePointer<WGPUBindGroupLayoutEntry>) throws -> R) rethrows -> R {
        var cStruct = WGPUBindGroupLayoutEntry(
            nextInChain: nil, 
            binding: self.binding, 
            visibility: self.visibility.rawValue, 
            type: self.type.cValue, 
            hasDynamicOffset: self.hasDynamicOffset, 
            minBufferBindingSize: self.minBufferBindingSize, 
            viewDimension: self.viewDimension.cValue, 
            textureComponentType: self.textureComponentType.cValue, 
            storageTextureFormat: self.storageTextureFormat.cValue, 
            buffer: self.buffer, 
            sampler: self.sampler, 
            texture: self.texture, 
            storageTexture: self.storageTexture
        )
        return try body(&cStruct)
    }
}

public struct BindGroupLayoutDescriptor {
    public var label: String?
    public var entryCount: UInt32
    public var entries: [BindGroupLayoutEntry]

    func withCStruct<R>(_ body: (UnsafePointer<WGPUBindGroupLayoutDescriptor>) throws -> R) rethrows -> R {
        return try self.label.withOptionalCString { cString_label in
        var cStruct = WGPUBindGroupLayoutDescriptor(
            nextInChain: nil, 
            label: cString_label, 
            entryCount: self.entryCount, 
            entries: self.entries
        )
        return try body(&cStruct)
        }
    }
}

public struct BlendDescriptor {
    public var operation: BlendOperation
    public var srcFactor: BlendFactor
    public var dstFactor: BlendFactor

    func withCStruct<R>(_ body: (UnsafePointer<WGPUBlendDescriptor>) throws -> R) rethrows -> R {
        var cStruct = WGPUBlendDescriptor(
            operation: self.operation.cValue, 
            srcFactor: self.srcFactor.cValue, 
            dstFactor: self.dstFactor.cValue
        )
        return try body(&cStruct)
    }
}

public struct ColorStateDescriptor {
    public var format: TextureFormat
    public var alphaBlend: BlendDescriptor
    public var colorBlend: BlendDescriptor
    public var writeMask: ColorWriteMask

    func withCStruct<R>(_ body: (UnsafePointer<WGPUColorStateDescriptor>) throws -> R) rethrows -> R {
        var cStruct = WGPUColorStateDescriptor(
            nextInChain: nil, 
            format: self.format.cValue, 
            alphaBlend: self.alphaBlend, 
            colorBlend: self.colorBlend, 
            writeMask: self.writeMask.rawValue
        )
        return try body(&cStruct)
    }
}

public struct BufferCopyView {
    public var layout: TextureDataLayout
    public var buffer: Buffer

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
    public var label: String?
    public var usage: BufferUsage
    public var size: UInt64
    public var mappedAtCreation: Bool

    func withCStruct<R>(_ body: (UnsafePointer<WGPUBufferDescriptor>) throws -> R) rethrows -> R {
        return try self.label.withOptionalCString { cString_label in
        var cStruct = WGPUBufferDescriptor(
            nextInChain: nil, 
            label: cString_label, 
            usage: self.usage.rawValue, 
            size: self.size, 
            mappedAtCreation: self.mappedAtCreation
        )
        return try body(&cStruct)
        }
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
    public var label: String?

    func withCStruct<R>(_ body: (UnsafePointer<WGPUCommandBufferDescriptor>) throws -> R) rethrows -> R {
        return try self.label.withOptionalCString { cString_label in
        var cStruct = WGPUCommandBufferDescriptor(
            nextInChain: nil, 
            label: cString_label
        )
        return try body(&cStruct)
        }
    }
}

public struct CommandEncoderDescriptor {
    public var label: String?

    func withCStruct<R>(_ body: (UnsafePointer<WGPUCommandEncoderDescriptor>) throws -> R) rethrows -> R {
        return try self.label.withOptionalCString { cString_label in
        var cStruct = WGPUCommandEncoderDescriptor(
            nextInChain: nil, 
            label: cString_label
        )
        return try body(&cStruct)
        }
    }
}

public struct ComputePassDescriptor {
    public var label: String?

    func withCStruct<R>(_ body: (UnsafePointer<WGPUComputePassDescriptor>) throws -> R) rethrows -> R {
        return try self.label.withOptionalCString { cString_label in
        var cStruct = WGPUComputePassDescriptor(
            nextInChain: nil, 
            label: cString_label
        )
        return try body(&cStruct)
        }
    }
}

public struct ComputePipelineDescriptor {
    public var label: String?
    public var layout: PipelineLayout?
    public var computeStage: ProgrammableStageDescriptor

    func withCStruct<R>(_ body: (UnsafePointer<WGPUComputePipelineDescriptor>) throws -> R) rethrows -> R {
        return try self.label.withOptionalCString { cString_label in
        var cStruct = WGPUComputePipelineDescriptor(
            nextInChain: nil, 
            label: cString_label, 
            layout: self.layout, 
            computeStage: self.computeStage
        )
        return try body(&cStruct)
        }
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
    public var format: TextureFormat
    public var depthWriteEnabled: Bool
    public var depthCompare: CompareFunction
    public var stencilFront: StencilStateFaceDescriptor
    public var stencilBack: StencilStateFaceDescriptor
    public var stencilReadMask: UInt32
    public var stencilWriteMask: UInt32

    func withCStruct<R>(_ body: (UnsafePointer<WGPUDepthStencilStateDescriptor>) throws -> R) rethrows -> R {
        var cStruct = WGPUDepthStencilStateDescriptor(
            nextInChain: nil, 
            format: self.format.cValue, 
            depthWriteEnabled: self.depthWriteEnabled, 
            depthCompare: self.depthCompare.cValue, 
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
    public var label: String?
    public var initialValue: UInt64

    func withCStruct<R>(_ body: (UnsafePointer<WGPUFenceDescriptor>) throws -> R) rethrows -> R {
        return try self.label.withOptionalCString { cString_label in
        var cStruct = WGPUFenceDescriptor(
            nextInChain: nil, 
            label: cString_label, 
            initialValue: self.initialValue
        )
        return try body(&cStruct)
        }
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
    public var format: VertexFormat
    public var offset: UInt64
    public var shaderLocation: UInt32

    func withCStruct<R>(_ body: (UnsafePointer<WGPUVertexAttribute>) throws -> R) rethrows -> R {
        var cStruct = WGPUVertexAttribute(
            format: self.format.cValue, 
            offset: self.offset, 
            shaderLocation: self.shaderLocation
        )
        return try body(&cStruct)
    }
}

public struct VertexBufferLayout {
    public var arrayStride: UInt64
    public var stepMode: InputStepMode
    public var attributeCount: UInt32
    public var attributes: [VertexAttribute]

    func withCStruct<R>(_ body: (UnsafePointer<WGPUVertexBufferLayout>) throws -> R) rethrows -> R {
        var cStruct = WGPUVertexBufferLayout(
            arrayStride: self.arrayStride, 
            stepMode: self.stepMode.cValue, 
            attributeCount: self.attributeCount, 
            attributes: self.attributes
        )
        return try body(&cStruct)
    }
}

public struct VertexStateDescriptor {
    public var indexFormat: IndexFormat
    public var vertexBufferCount: UInt32
    public var vertexBuffers: [VertexBufferLayout]

    func withCStruct<R>(_ body: (UnsafePointer<WGPUVertexStateDescriptor>) throws -> R) rethrows -> R {
        var cStruct = WGPUVertexStateDescriptor(
            nextInChain: nil, 
            indexFormat: self.indexFormat.cValue, 
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
    public var label: String?
    public var bindGroupLayoutCount: UInt32
    public var bindGroupLayouts: [BindGroupLayout]

    func withCStruct<R>(_ body: (UnsafePointer<WGPUPipelineLayoutDescriptor>) throws -> R) rethrows -> R {
        return try self.label.withOptionalCString { cString_label in
        var cStruct = WGPUPipelineLayoutDescriptor(
            nextInChain: nil, 
            label: cString_label, 
            bindGroupLayoutCount: self.bindGroupLayoutCount, 
            bindGroupLayouts: self.bindGroupLayouts
        )
        return try body(&cStruct)
        }
    }
}

public struct ProgrammableStageDescriptor {
    public var module: ShaderModule
    public var entryPoint: String

    func withCStruct<R>(_ body: (UnsafePointer<WGPUProgrammableStageDescriptor>) throws -> R) rethrows -> R {
        return try self.entryPoint.withCString { cString_entryPoint in
        var cStruct = WGPUProgrammableStageDescriptor(
            nextInChain: nil, 
            module: self.module, 
            entryPoint: cString_entryPoint
        )
        return try body(&cStruct)
        }
    }
}

public struct QuerySetDescriptor {
    public var label: String?
    public var type: QueryType
    public var count: UInt32
    public var pipelineStatistics: [PipelineStatisticName]
    public var pipelineStatisticsCount: UInt32

    func withCStruct<R>(_ body: (UnsafePointer<WGPUQuerySetDescriptor>) throws -> R) rethrows -> R {
        return try self.label.withOptionalCString { cString_label in
        var cStruct = WGPUQuerySetDescriptor(
            nextInChain: nil, 
            label: cString_label, 
            type: self.type.cValue, 
            count: self.count, 
            pipelineStatistics: self.pipelineStatistics, 
            pipelineStatisticsCount: self.pipelineStatisticsCount
        )
        return try body(&cStruct)
        }
    }
}

public struct RasterizationStateDescriptor {
    public var frontFace: FrontFace
    public var cullMode: CullMode
    public var depthBias: Int32
    public var depthBiasSlopeScale: Float
    public var depthBiasClamp: Float

    func withCStruct<R>(_ body: (UnsafePointer<WGPURasterizationStateDescriptor>) throws -> R) rethrows -> R {
        var cStruct = WGPURasterizationStateDescriptor(
            nextInChain: nil, 
            frontFace: self.frontFace.cValue, 
            cullMode: self.cullMode.cValue, 
            depthBias: self.depthBias, 
            depthBiasSlopeScale: self.depthBiasSlopeScale, 
            depthBiasClamp: self.depthBiasClamp
        )
        return try body(&cStruct)
    }
}

public struct RenderBundleDescriptor {
    public var label: String?

    func withCStruct<R>(_ body: (UnsafePointer<WGPURenderBundleDescriptor>) throws -> R) rethrows -> R {
        return try self.label.withOptionalCString { cString_label in
        var cStruct = WGPURenderBundleDescriptor(
            nextInChain: nil, 
            label: cString_label
        )
        return try body(&cStruct)
        }
    }
}

public struct RenderBundleEncoderDescriptor {
    public var label: String?
    public var colorFormatsCount: UInt32
    public var colorFormats: [TextureFormat]
    public var depthStencilFormat: TextureFormat
    public var sampleCount: UInt32

    func withCStruct<R>(_ body: (UnsafePointer<WGPURenderBundleEncoderDescriptor>) throws -> R) rethrows -> R {
        return try self.label.withOptionalCString { cString_label in
        var cStruct = WGPURenderBundleEncoderDescriptor(
            nextInChain: nil, 
            label: cString_label, 
            colorFormatsCount: self.colorFormatsCount, 
            colorFormats: self.colorFormats, 
            depthStencilFormat: self.depthStencilFormat.cValue, 
            sampleCount: self.sampleCount
        )
        return try body(&cStruct)
        }
    }
}

public struct RenderPassColorAttachmentDescriptor {
    public var attachment: TextureView
    public var resolveTarget: TextureView?
    public var loadOp: LoadOp
    public var storeOp: StoreOp
    public var clearColor: Color

    func withCStruct<R>(_ body: (UnsafePointer<WGPURenderPassColorAttachmentDescriptor>) throws -> R) rethrows -> R {
        var cStruct = WGPURenderPassColorAttachmentDescriptor(
            attachment: self.attachment, 
            resolveTarget: self.resolveTarget, 
            loadOp: self.loadOp.cValue, 
            storeOp: self.storeOp.cValue, 
            clearColor: self.clearColor
        )
        return try body(&cStruct)
    }
}

public struct RenderPassDepthStencilAttachmentDescriptor {
    public var attachment: TextureView
    public var depthLoadOp: LoadOp
    public var depthStoreOp: StoreOp
    public var clearDepth: Float
    public var depthReadOnly: Bool
    public var stencilLoadOp: LoadOp
    public var stencilStoreOp: StoreOp
    public var clearStencil: UInt32
    public var stencilReadOnly: Bool

    func withCStruct<R>(_ body: (UnsafePointer<WGPURenderPassDepthStencilAttachmentDescriptor>) throws -> R) rethrows -> R {
        var cStruct = WGPURenderPassDepthStencilAttachmentDescriptor(
            attachment: self.attachment, 
            depthLoadOp: self.depthLoadOp.cValue, 
            depthStoreOp: self.depthStoreOp.cValue, 
            clearDepth: self.clearDepth, 
            depthReadOnly: self.depthReadOnly, 
            stencilLoadOp: self.stencilLoadOp.cValue, 
            stencilStoreOp: self.stencilStoreOp.cValue, 
            clearStencil: self.clearStencil, 
            stencilReadOnly: self.stencilReadOnly
        )
        return try body(&cStruct)
    }
}

public struct RenderPassDescriptor {
    public var label: String?
    public var colorAttachmentCount: UInt32
    public var colorAttachments: [RenderPassColorAttachmentDescriptor]
    public var depthStencilAttachment: RenderPassDepthStencilAttachmentDescriptor?
    public var occlusionQuerySet: QuerySet?

    func withCStruct<R>(_ body: (UnsafePointer<WGPURenderPassDescriptor>) throws -> R) rethrows -> R {
        return try self.label.withOptionalCString { cString_label in
        var cStruct = WGPURenderPassDescriptor(
            nextInChain: nil, 
            label: cString_label, 
            colorAttachmentCount: self.colorAttachmentCount, 
            colorAttachments: self.colorAttachments, 
            depthStencilAttachment: self.depthStencilAttachment, 
            occlusionQuerySet: self.occlusionQuerySet
        )
        return try body(&cStruct)
        }
    }
}

public struct RenderPipelineDescriptor {
    public var label: String?
    public var layout: PipelineLayout?
    public var vertexStage: ProgrammableStageDescriptor
    public var fragmentStage: ProgrammableStageDescriptor?
    public var vertexState: VertexStateDescriptor?
    public var primitiveTopology: PrimitiveTopology
    public var rasterizationState: RasterizationStateDescriptor?
    public var sampleCount: UInt32
    public var depthStencilState: DepthStencilStateDescriptor?
    public var colorStateCount: UInt32
    public var colorStates: [ColorStateDescriptor]
    public var sampleMask: UInt32
    public var alphaToCoverageEnabled: Bool

    func withCStruct<R>(_ body: (UnsafePointer<WGPURenderPipelineDescriptor>) throws -> R) rethrows -> R {
        return try self.label.withOptionalCString { cString_label in
        var cStruct = WGPURenderPipelineDescriptor(
            nextInChain: nil, 
            label: cString_label, 
            layout: self.layout, 
            vertexStage: self.vertexStage, 
            fragmentStage: self.fragmentStage, 
            vertexState: self.vertexState, 
            primitiveTopology: self.primitiveTopology.cValue, 
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
}

public struct RenderPipelineDescriptorDummyExtension {
    public var dummyStage: ProgrammableStageDescriptor

    func withCStruct<R>(_ body: (UnsafePointer<WGPURenderPipelineDescriptorDummyExtension>) throws -> R) rethrows -> R {
        var cStruct = WGPURenderPipelineDescriptorDummyExtension(
            chain: WGPUChainedStruct(), 
            dummyStage: self.dummyStage
        )
        return try body(&cStruct)
    }
}

public struct SamplerDescriptor {
    public var label: String?
    public var addressModeU: AddressMode
    public var addressModeV: AddressMode
    public var addressModeW: AddressMode
    public var magFilter: FilterMode
    public var minFilter: FilterMode
    public var mipmapFilter: FilterMode
    public var lodMinClamp: Float
    public var lodMaxClamp: Float
    public var compare: CompareFunction
    public var maxAnisotropy: UInt16

    func withCStruct<R>(_ body: (UnsafePointer<WGPUSamplerDescriptor>) throws -> R) rethrows -> R {
        return try self.label.withOptionalCString { cString_label in
        var cStruct = WGPUSamplerDescriptor(
            nextInChain: nil, 
            label: cString_label, 
            addressModeU: self.addressModeU.cValue, 
            addressModeV: self.addressModeV.cValue, 
            addressModeW: self.addressModeW.cValue, 
            magFilter: self.magFilter.cValue, 
            minFilter: self.minFilter.cValue, 
            mipmapFilter: self.mipmapFilter.cValue, 
            lodMinClamp: self.lodMinClamp, 
            lodMaxClamp: self.lodMaxClamp, 
            compare: self.compare.cValue, 
            maxAnisotropy: self.maxAnisotropy
        )
        return try body(&cStruct)
        }
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
    public var label: String?

    func withCStruct<R>(_ body: (UnsafePointer<WGPUShaderModuleDescriptor>) throws -> R) rethrows -> R {
        return try self.label.withOptionalCString { cString_label in
        var cStruct = WGPUShaderModuleDescriptor(
            nextInChain: nil, 
            label: cString_label
        )
        return try body(&cStruct)
        }
    }
}

public struct ShaderModuleSpirvDescriptor {
    public var codeSize: UInt32
    public var code: [UInt32]

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
    public var source: String

    func withCStruct<R>(_ body: (UnsafePointer<WGPUShaderModuleWGSLDescriptor>) throws -> R) rethrows -> R {
        return try self.source.withCString { cString_source in
        var cStruct = WGPUShaderModuleWGSLDescriptor(
            chain: WGPUChainedStruct(), 
            source: cString_source
        )
        return try body(&cStruct)
        }
    }
}

public struct StencilStateFaceDescriptor {
    public var compare: CompareFunction
    public var failOp: StencilOperation
    public var depthFailOp: StencilOperation
    public var passOp: StencilOperation

    func withCStruct<R>(_ body: (UnsafePointer<WGPUStencilStateFaceDescriptor>) throws -> R) rethrows -> R {
        var cStruct = WGPUStencilStateFaceDescriptor(
            compare: self.compare.cValue, 
            failOp: self.failOp.cValue, 
            depthFailOp: self.depthFailOp.cValue, 
            passOp: self.passOp.cValue
        )
        return try body(&cStruct)
    }
}

public struct SurfaceDescriptor {
    public var label: String?

    func withCStruct<R>(_ body: (UnsafePointer<WGPUSurfaceDescriptor>) throws -> R) rethrows -> R {
        return try self.label.withOptionalCString { cString_label in
        var cStruct = WGPUSurfaceDescriptor(
            nextInChain: nil, 
            label: cString_label
        )
        return try body(&cStruct)
        }
    }
}

public struct SurfaceDescriptorFromCanvasHtmlSelector {
    public var selector: String

    func withCStruct<R>(_ body: (UnsafePointer<WGPUSurfaceDescriptorFromCanvasHTMLSelector>) throws -> R) rethrows -> R {
        return try self.selector.withCString { cString_selector in
        var cStruct = WGPUSurfaceDescriptorFromCanvasHTMLSelector(
            chain: WGPUChainedStruct(), 
            selector: cString_selector
        )
        return try body(&cStruct)
        }
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
    public var label: String?
    public var usage: TextureUsage
    public var format: TextureFormat
    public var width: UInt32
    public var height: UInt32
    public var presentMode: PresentMode
    public var implementation: UInt64

    func withCStruct<R>(_ body: (UnsafePointer<WGPUSwapChainDescriptor>) throws -> R) rethrows -> R {
        return try self.label.withOptionalCString { cString_label in
        var cStruct = WGPUSwapChainDescriptor(
            nextInChain: nil, 
            label: cString_label, 
            usage: self.usage.rawValue, 
            format: self.format.cValue, 
            width: self.width, 
            height: self.height, 
            presentMode: self.presentMode.cValue, 
            implementation: self.implementation
        )
        return try body(&cStruct)
        }
    }
}

public struct TextureCopyView {
    public var texture: Texture
    public var mipLevel: UInt32
    public var origin: Origin3d
    public var aspect: TextureAspect

    func withCStruct<R>(_ body: (UnsafePointer<WGPUTextureCopyView>) throws -> R) rethrows -> R {
        var cStruct = WGPUTextureCopyView(
            nextInChain: nil, 
            texture: self.texture, 
            mipLevel: self.mipLevel, 
            origin: self.origin, 
            aspect: self.aspect.cValue
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
    public var label: String?
    public var usage: TextureUsage
    public var dimension: TextureDimension
    public var size: Extent3d
    public var format: TextureFormat
    public var mipLevelCount: UInt32
    public var sampleCount: UInt32

    func withCStruct<R>(_ body: (UnsafePointer<WGPUTextureDescriptor>) throws -> R) rethrows -> R {
        return try self.label.withOptionalCString { cString_label in
        var cStruct = WGPUTextureDescriptor(
            nextInChain: nil, 
            label: cString_label, 
            usage: self.usage.rawValue, 
            dimension: self.dimension.cValue, 
            size: self.size, 
            format: self.format.cValue, 
            mipLevelCount: self.mipLevelCount, 
            sampleCount: self.sampleCount
        )
        return try body(&cStruct)
        }
    }
}

public struct TextureViewDescriptor {
    public var label: String?
    public var format: TextureFormat
    public var dimension: TextureViewDimension
    public var baseMipLevel: UInt32
    public var mipLevelCount: UInt32
    public var baseArrayLayer: UInt32
    public var arrayLayerCount: UInt32
    public var aspect: TextureAspect

    func withCStruct<R>(_ body: (UnsafePointer<WGPUTextureViewDescriptor>) throws -> R) rethrows -> R {
        return try self.label.withOptionalCString { cString_label in
        var cStruct = WGPUTextureViewDescriptor(
            nextInChain: nil, 
            label: cString_label, 
            format: self.format.cValue, 
            dimension: self.dimension.cValue, 
            baseMipLevel: self.baseMipLevel, 
            mipLevelCount: self.mipLevelCount, 
            baseArrayLayer: self.baseArrayLayer, 
            arrayLayerCount: self.arrayLayerCount, 
            aspect: self.aspect.cValue
        )
        return try body(&cStruct)
        }
    }
}

