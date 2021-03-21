import CWebGPU

public struct AdapterProperties: CStructConvertible, Extensible {
    typealias CStruct = WGPUAdapterProperties

    public var deviceId: UInt32
    public var vendorId: UInt32
    public var name: String
    public var driverDescription: String
    public var adapterType: AdapterType
    public var backendType: BackendType

    public var nextInChain: Chained?

    public init(deviceId: UInt32, vendorId: UInt32, name: String, driverDescription: String, adapterType: AdapterType, backendType: BackendType, nextInChain: Chained? = nil) {
        self.deviceId = deviceId
        self.vendorId = vendorId
        self.name = name
        self.driverDescription = driverDescription
        self.adapterType = adapterType
        self.backendType = backendType
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUAdapterProperties>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        return try self.name.withCString { cString_name in
        return try self.driverDescription.withCString { cString_driverDescription in
        var cStruct = WGPUAdapterProperties(
            nextInChain: chainedCStruct, 
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
}

public struct BindGroupEntry: CStructConvertible {
    typealias CStruct = WGPUBindGroupEntry

    public var binding: UInt32
    public var buffer: Buffer?
    public var offset: UInt64
    public var size: UInt64
    public var sampler: Sampler?
    public var textureView: TextureView?

    public init(binding: UInt32, buffer: Buffer?, offset: UInt64, size: UInt64, sampler: Sampler?, textureView: TextureView?) {
        self.binding = binding
        self.buffer = buffer
        self.offset = offset
        self.size = size
        self.sampler = sampler
        self.textureView = textureView
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUBindGroupEntry>) throws -> R) rethrows -> R {
        var cStruct = WGPUBindGroupEntry(
            binding: self.binding, 
            buffer: self.buffer?.object, 
            offset: self.offset, 
            size: self.size, 
            sampler: self.sampler?.object, 
            textureView: self.textureView?.object
        )
        return try body(&cStruct)
    }
}

public struct BindGroupDescriptor: CStructConvertible, Extensible {
    typealias CStruct = WGPUBindGroupDescriptor

    public var label: String?
    public var layout: BindGroupLayout
    public var entries: [BindGroupEntry]

    public var nextInChain: Chained?

    public init(label: String?, layout: BindGroupLayout, entries: [BindGroupEntry], nextInChain: Chained? = nil) {
        self.label = label
        self.layout = layout
        self.entries = entries
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUBindGroupDescriptor>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        return try self.label.withOptionalCString { cString_label in
        return try self.entries.withCStructBufferPointer { buffer_entries in
        var cStruct = WGPUBindGroupDescriptor(
            nextInChain: chainedCStruct, 
            label: cString_label, 
            layout: self.layout.object, 
            entryCount: .init(buffer_entries.count), 
            entries: buffer_entries.baseAddress
        )
        return try body(&cStruct)
        }
        }
        }
    }
}

public struct BufferBindingLayout: CStructConvertible, Extensible {
    typealias CStruct = WGPUBufferBindingLayout

    public var type: BufferBindingType
    public var hasDynamicOffset: Bool
    public var minBindingSize: UInt64

    public var nextInChain: Chained?

    public init(type: BufferBindingType, hasDynamicOffset: Bool, minBindingSize: UInt64, nextInChain: Chained? = nil) {
        self.type = type
        self.hasDynamicOffset = hasDynamicOffset
        self.minBindingSize = minBindingSize
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUBufferBindingLayout>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        var cStruct = WGPUBufferBindingLayout(
            nextInChain: chainedCStruct, 
            type: self.type.cValue, 
            hasDynamicOffset: self.hasDynamicOffset, 
            minBindingSize: self.minBindingSize
        )
        return try body(&cStruct)
        }
    }
}

public struct SamplerBindingLayout: CStructConvertible, Extensible {
    typealias CStruct = WGPUSamplerBindingLayout

    public var type: SamplerBindingType

    public var nextInChain: Chained?

    public init(type: SamplerBindingType, nextInChain: Chained? = nil) {
        self.type = type
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUSamplerBindingLayout>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        var cStruct = WGPUSamplerBindingLayout(
            nextInChain: chainedCStruct, 
            type: self.type.cValue
        )
        return try body(&cStruct)
        }
    }
}

public struct TextureBindingLayout: CStructConvertible, Extensible {
    typealias CStruct = WGPUTextureBindingLayout

    public var sampleType: TextureSampleType
    public var viewDimension: TextureViewDimension
    public var multisampled: Bool

    public var nextInChain: Chained?

    public init(sampleType: TextureSampleType, viewDimension: TextureViewDimension, multisampled: Bool, nextInChain: Chained? = nil) {
        self.sampleType = sampleType
        self.viewDimension = viewDimension
        self.multisampled = multisampled
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUTextureBindingLayout>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        var cStruct = WGPUTextureBindingLayout(
            nextInChain: chainedCStruct, 
            sampleType: self.sampleType.cValue, 
            viewDimension: self.viewDimension.cValue, 
            multisampled: self.multisampled
        )
        return try body(&cStruct)
        }
    }
}

public struct StorageTextureBindingLayout: CStructConvertible, Extensible {
    typealias CStruct = WGPUStorageTextureBindingLayout

    public var access: StorageTextureAccess
    public var format: TextureFormat
    public var viewDimension: TextureViewDimension

    public var nextInChain: Chained?

    public init(access: StorageTextureAccess, format: TextureFormat, viewDimension: TextureViewDimension, nextInChain: Chained? = nil) {
        self.access = access
        self.format = format
        self.viewDimension = viewDimension
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUStorageTextureBindingLayout>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        var cStruct = WGPUStorageTextureBindingLayout(
            nextInChain: chainedCStruct, 
            access: self.access.cValue, 
            format: self.format.cValue, 
            viewDimension: self.viewDimension.cValue
        )
        return try body(&cStruct)
        }
    }
}

public struct BindGroupLayoutEntry: CStructConvertible, Extensible {
    typealias CStruct = WGPUBindGroupLayoutEntry

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

    public var nextInChain: Chained?

    public init(binding: UInt32, visibility: ShaderStage, type: BindingType, hasDynamicOffset: Bool, minBufferBindingSize: UInt64, viewDimension: TextureViewDimension, textureComponentType: TextureComponentType, storageTextureFormat: TextureFormat, buffer: BufferBindingLayout, sampler: SamplerBindingLayout, texture: TextureBindingLayout, storageTexture: StorageTextureBindingLayout, nextInChain: Chained? = nil) {
        self.binding = binding
        self.visibility = visibility
        self.type = type
        self.hasDynamicOffset = hasDynamicOffset
        self.minBufferBindingSize = minBufferBindingSize
        self.viewDimension = viewDimension
        self.textureComponentType = textureComponentType
        self.storageTextureFormat = storageTextureFormat
        self.buffer = buffer
        self.sampler = sampler
        self.texture = texture
        self.storageTexture = storageTexture
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUBindGroupLayoutEntry>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        return try self.buffer.withCStruct { cStruct_buffer in
        return try self.sampler.withCStruct { cStruct_sampler in
        return try self.texture.withCStruct { cStruct_texture in
        return try self.storageTexture.withCStruct { cStruct_storageTexture in
        var cStruct = WGPUBindGroupLayoutEntry(
            nextInChain: chainedCStruct, 
            binding: self.binding, 
            visibility: self.visibility.rawValue, 
            type: self.type.cValue, 
            hasDynamicOffset: self.hasDynamicOffset, 
            minBufferBindingSize: self.minBufferBindingSize, 
            viewDimension: self.viewDimension.cValue, 
            textureComponentType: self.textureComponentType.cValue, 
            storageTextureFormat: self.storageTextureFormat.cValue, 
            buffer: cStruct_buffer.pointee, 
            sampler: cStruct_sampler.pointee, 
            texture: cStruct_texture.pointee, 
            storageTexture: cStruct_storageTexture.pointee
        )
        return try body(&cStruct)
        }
        }
        }
        }
        }
    }
}

public struct BindGroupLayoutDescriptor: CStructConvertible, Extensible {
    typealias CStruct = WGPUBindGroupLayoutDescriptor

    public var label: String?
    public var entries: [BindGroupLayoutEntry]

    public var nextInChain: Chained?

    public init(label: String?, entries: [BindGroupLayoutEntry], nextInChain: Chained? = nil) {
        self.label = label
        self.entries = entries
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUBindGroupLayoutDescriptor>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        return try self.label.withOptionalCString { cString_label in
        return try self.entries.withCStructBufferPointer { buffer_entries in
        var cStruct = WGPUBindGroupLayoutDescriptor(
            nextInChain: chainedCStruct, 
            label: cString_label, 
            entryCount: .init(buffer_entries.count), 
            entries: buffer_entries.baseAddress
        )
        return try body(&cStruct)
        }
        }
        }
    }
}

public struct BlendDescriptor: CStructConvertible {
    typealias CStruct = WGPUBlendDescriptor

    public var operation: BlendOperation
    public var srcFactor: BlendFactor
    public var dstFactor: BlendFactor

    public init(operation: BlendOperation, srcFactor: BlendFactor, dstFactor: BlendFactor) {
        self.operation = operation
        self.srcFactor = srcFactor
        self.dstFactor = dstFactor
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUBlendDescriptor>) throws -> R) rethrows -> R {
        var cStruct = WGPUBlendDescriptor(
            operation: self.operation.cValue, 
            srcFactor: self.srcFactor.cValue, 
            dstFactor: self.dstFactor.cValue
        )
        return try body(&cStruct)
    }
}

public struct ColorStateDescriptor: CStructConvertible, Extensible {
    typealias CStruct = WGPUColorStateDescriptor

    public var format: TextureFormat
    public var alphaBlend: BlendDescriptor
    public var colorBlend: BlendDescriptor
    public var writeMask: ColorWriteMask

    public var nextInChain: Chained?

    public init(format: TextureFormat, alphaBlend: BlendDescriptor, colorBlend: BlendDescriptor, writeMask: ColorWriteMask, nextInChain: Chained? = nil) {
        self.format = format
        self.alphaBlend = alphaBlend
        self.colorBlend = colorBlend
        self.writeMask = writeMask
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUColorStateDescriptor>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        return try self.alphaBlend.withCStruct { cStruct_alphaBlend in
        return try self.colorBlend.withCStruct { cStruct_colorBlend in
        var cStruct = WGPUColorStateDescriptor(
            nextInChain: chainedCStruct, 
            format: self.format.cValue, 
            alphaBlend: cStruct_alphaBlend.pointee, 
            colorBlend: cStruct_colorBlend.pointee, 
            writeMask: self.writeMask.rawValue
        )
        return try body(&cStruct)
        }
        }
        }
    }
}

public struct BufferCopyView: CStructConvertible, Extensible {
    typealias CStruct = WGPUBufferCopyView

    public var layout: TextureDataLayout
    public var buffer: Buffer

    public var nextInChain: Chained?

    public init(layout: TextureDataLayout, buffer: Buffer, nextInChain: Chained? = nil) {
        self.layout = layout
        self.buffer = buffer
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUBufferCopyView>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        return try self.layout.withCStruct { cStruct_layout in
        var cStruct = WGPUBufferCopyView(
            nextInChain: chainedCStruct, 
            layout: cStruct_layout.pointee, 
            buffer: self.buffer.object
        )
        return try body(&cStruct)
        }
        }
    }
}

public struct BufferDescriptor: CStructConvertible, Extensible {
    typealias CStruct = WGPUBufferDescriptor

    public var label: String?
    public var usage: BufferUsage
    public var size: UInt64
    public var mappedAtCreation: Bool

    public var nextInChain: Chained?

    public init(label: String?, usage: BufferUsage, size: UInt64, mappedAtCreation: Bool, nextInChain: Chained? = nil) {
        self.label = label
        self.usage = usage
        self.size = size
        self.mappedAtCreation = mappedAtCreation
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUBufferDescriptor>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        return try self.label.withOptionalCString { cString_label in
        var cStruct = WGPUBufferDescriptor(
            nextInChain: chainedCStruct, 
            label: cString_label, 
            usage: self.usage.rawValue, 
            size: self.size, 
            mappedAtCreation: self.mappedAtCreation
        )
        return try body(&cStruct)
        }
        }
    }
}

public struct Color: CStructConvertible {
    typealias CStruct = WGPUColor

    public var r: Double
    public var g: Double
    public var b: Double
    public var a: Double

    public init(r: Double, g: Double, b: Double, a: Double) {
        self.r = r
        self.g = g
        self.b = b
        self.a = a
    }

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

public struct CommandBufferDescriptor: CStructConvertible, Extensible {
    typealias CStruct = WGPUCommandBufferDescriptor

    public var label: String?

    public var nextInChain: Chained?

    public init(label: String?, nextInChain: Chained? = nil) {
        self.label = label
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUCommandBufferDescriptor>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        return try self.label.withOptionalCString { cString_label in
        var cStruct = WGPUCommandBufferDescriptor(
            nextInChain: chainedCStruct, 
            label: cString_label
        )
        return try body(&cStruct)
        }
        }
    }
}

public struct CommandEncoderDescriptor: CStructConvertible, Extensible {
    typealias CStruct = WGPUCommandEncoderDescriptor

    public var label: String?

    public var nextInChain: Chained?

    public init(label: String?, nextInChain: Chained? = nil) {
        self.label = label
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUCommandEncoderDescriptor>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        return try self.label.withOptionalCString { cString_label in
        var cStruct = WGPUCommandEncoderDescriptor(
            nextInChain: chainedCStruct, 
            label: cString_label
        )
        return try body(&cStruct)
        }
        }
    }
}

public struct ComputePassDescriptor: CStructConvertible, Extensible {
    typealias CStruct = WGPUComputePassDescriptor

    public var label: String?

    public var nextInChain: Chained?

    public init(label: String?, nextInChain: Chained? = nil) {
        self.label = label
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUComputePassDescriptor>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        return try self.label.withOptionalCString { cString_label in
        var cStruct = WGPUComputePassDescriptor(
            nextInChain: chainedCStruct, 
            label: cString_label
        )
        return try body(&cStruct)
        }
        }
    }
}

public struct ComputePipelineDescriptor: CStructConvertible, Extensible {
    typealias CStruct = WGPUComputePipelineDescriptor

    public var label: String?
    public var layout: PipelineLayout?
    public var computeStage: ProgrammableStageDescriptor

    public var nextInChain: Chained?

    public init(label: String?, layout: PipelineLayout?, computeStage: ProgrammableStageDescriptor, nextInChain: Chained? = nil) {
        self.label = label
        self.layout = layout
        self.computeStage = computeStage
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUComputePipelineDescriptor>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        return try self.label.withOptionalCString { cString_label in
        return try self.computeStage.withCStruct { cStruct_computeStage in
        var cStruct = WGPUComputePipelineDescriptor(
            nextInChain: chainedCStruct, 
            label: cString_label, 
            layout: self.layout?.object, 
            computeStage: cStruct_computeStage.pointee
        )
        return try body(&cStruct)
        }
        }
        }
    }
}

public struct CopyTextureForBrowserOptions: CStructConvertible, Extensible {
    typealias CStruct = WGPUCopyTextureForBrowserOptions

    public var flipy: Bool

    public var nextInChain: Chained?

    public init(flipy: Bool, nextInChain: Chained? = nil) {
        self.flipy = flipy
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUCopyTextureForBrowserOptions>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        var cStruct = WGPUCopyTextureForBrowserOptions(
            nextInChain: chainedCStruct, 
            flipY: self.flipy
        )
        return try body(&cStruct)
        }
    }
}

public struct DeviceProperties: CStructConvertible {
    typealias CStruct = WGPUDeviceProperties

    public var textureCompressionBc: Bool
    public var shaderFloat16: Bool
    public var pipelineStatisticsQuery: Bool
    public var timestampQuery: Bool
    public var multiPlanarFormats: Bool

    public init(textureCompressionBc: Bool, shaderFloat16: Bool, pipelineStatisticsQuery: Bool, timestampQuery: Bool, multiPlanarFormats: Bool) {
        self.textureCompressionBc = textureCompressionBc
        self.shaderFloat16 = shaderFloat16
        self.pipelineStatisticsQuery = pipelineStatisticsQuery
        self.timestampQuery = timestampQuery
        self.multiPlanarFormats = multiPlanarFormats
    }

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

public struct DepthStencilStateDescriptor: CStructConvertible, Extensible {
    typealias CStruct = WGPUDepthStencilStateDescriptor

    public var format: TextureFormat
    public var depthWriteEnabled: Bool
    public var depthCompare: CompareFunction
    public var stencilFront: StencilStateFaceDescriptor
    public var stencilBack: StencilStateFaceDescriptor
    public var stencilReadMask: UInt32
    public var stencilWriteMask: UInt32

    public var nextInChain: Chained?

    public init(format: TextureFormat, depthWriteEnabled: Bool, depthCompare: CompareFunction, stencilFront: StencilStateFaceDescriptor, stencilBack: StencilStateFaceDescriptor, stencilReadMask: UInt32, stencilWriteMask: UInt32, nextInChain: Chained? = nil) {
        self.format = format
        self.depthWriteEnabled = depthWriteEnabled
        self.depthCompare = depthCompare
        self.stencilFront = stencilFront
        self.stencilBack = stencilBack
        self.stencilReadMask = stencilReadMask
        self.stencilWriteMask = stencilWriteMask
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUDepthStencilStateDescriptor>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        return try self.stencilFront.withCStruct { cStruct_stencilFront in
        return try self.stencilBack.withCStruct { cStruct_stencilBack in
        var cStruct = WGPUDepthStencilStateDescriptor(
            nextInChain: chainedCStruct, 
            format: self.format.cValue, 
            depthWriteEnabled: self.depthWriteEnabled, 
            depthCompare: self.depthCompare.cValue, 
            stencilFront: cStruct_stencilFront.pointee, 
            stencilBack: cStruct_stencilBack.pointee, 
            stencilReadMask: self.stencilReadMask, 
            stencilWriteMask: self.stencilWriteMask
        )
        return try body(&cStruct)
        }
        }
        }
    }
}

public struct Extent3d: CStructConvertible {
    typealias CStruct = WGPUExtent3D

    public var width: UInt32
    public var height: UInt32
    public var depth: UInt32

    public init(width: UInt32, height: UInt32, depth: UInt32) {
        self.width = width
        self.height = height
        self.depth = depth
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUExtent3D>) throws -> R) rethrows -> R {
        var cStruct = WGPUExtent3D(
            width: self.width, 
            height: self.height, 
            depth: self.depth
        )
        return try body(&cStruct)
    }
}

public struct FenceDescriptor: CStructConvertible, Extensible {
    typealias CStruct = WGPUFenceDescriptor

    public var label: String?
    public var initialValue: UInt64

    public var nextInChain: Chained?

    public init(label: String?, initialValue: UInt64, nextInChain: Chained? = nil) {
        self.label = label
        self.initialValue = initialValue
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUFenceDescriptor>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        return try self.label.withOptionalCString { cString_label in
        var cStruct = WGPUFenceDescriptor(
            nextInChain: chainedCStruct, 
            label: cString_label, 
            initialValue: self.initialValue
        )
        return try body(&cStruct)
        }
        }
    }
}

public struct InstanceDescriptor: CStructConvertible, Extensible {
    typealias CStruct = WGPUInstanceDescriptor


    public var nextInChain: Chained?

    public init(nextInChain: Chained? = nil) {
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUInstanceDescriptor>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        var cStruct = WGPUInstanceDescriptor(
            nextInChain: chainedCStruct
        )
        return try body(&cStruct)
        }
    }
}

public struct VertexAttribute: CStructConvertible {
    typealias CStruct = WGPUVertexAttribute

    public var format: VertexFormat
    public var offset: UInt64
    public var shaderLocation: UInt32

    public init(format: VertexFormat, offset: UInt64, shaderLocation: UInt32) {
        self.format = format
        self.offset = offset
        self.shaderLocation = shaderLocation
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUVertexAttribute>) throws -> R) rethrows -> R {
        var cStruct = WGPUVertexAttribute(
            format: self.format.cValue, 
            offset: self.offset, 
            shaderLocation: self.shaderLocation
        )
        return try body(&cStruct)
    }
}

public struct VertexBufferLayout: CStructConvertible {
    typealias CStruct = WGPUVertexBufferLayout

    public var arrayStride: UInt64
    public var stepMode: InputStepMode
    public var attributes: [VertexAttribute]

    public init(arrayStride: UInt64, stepMode: InputStepMode, attributes: [VertexAttribute]) {
        self.arrayStride = arrayStride
        self.stepMode = stepMode
        self.attributes = attributes
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUVertexBufferLayout>) throws -> R) rethrows -> R {
        return try self.attributes.withCStructBufferPointer { buffer_attributes in
        var cStruct = WGPUVertexBufferLayout(
            arrayStride: self.arrayStride, 
            stepMode: self.stepMode.cValue, 
            attributeCount: .init(buffer_attributes.count), 
            attributes: buffer_attributes.baseAddress
        )
        return try body(&cStruct)
        }
    }
}

public struct VertexStateDescriptor: CStructConvertible, Extensible {
    typealias CStruct = WGPUVertexStateDescriptor

    public var indexFormat: IndexFormat
    public var vertexBuffers: [VertexBufferLayout]

    public var nextInChain: Chained?

    public init(indexFormat: IndexFormat, vertexBuffers: [VertexBufferLayout], nextInChain: Chained? = nil) {
        self.indexFormat = indexFormat
        self.vertexBuffers = vertexBuffers
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUVertexStateDescriptor>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        return try self.vertexBuffers.withCStructBufferPointer { buffer_vertexBuffers in
        var cStruct = WGPUVertexStateDescriptor(
            nextInChain: chainedCStruct, 
            indexFormat: self.indexFormat.cValue, 
            vertexBufferCount: .init(buffer_vertexBuffers.count), 
            vertexBuffers: buffer_vertexBuffers.baseAddress
        )
        return try body(&cStruct)
        }
        }
    }
}

public struct Origin3d: CStructConvertible {
    typealias CStruct = WGPUOrigin3D

    public var x: UInt32
    public var y: UInt32
    public var z: UInt32

    public init(x: UInt32, y: UInt32, z: UInt32) {
        self.x = x
        self.y = y
        self.z = z
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUOrigin3D>) throws -> R) rethrows -> R {
        var cStruct = WGPUOrigin3D(
            x: self.x, 
            y: self.y, 
            z: self.z
        )
        return try body(&cStruct)
    }
}

public struct PipelineLayoutDescriptor: CStructConvertible, Extensible {
    typealias CStruct = WGPUPipelineLayoutDescriptor

    public var label: String?
    public var bindGroupLayouts: [BindGroupLayout]

    public var nextInChain: Chained?

    public init(label: String?, bindGroupLayouts: [BindGroupLayout], nextInChain: Chained? = nil) {
        self.label = label
        self.bindGroupLayouts = bindGroupLayouts
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUPipelineLayoutDescriptor>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        return try self.label.withOptionalCString { cString_label in
        return try self.bindGroupLayouts.map { $0.object }.withUnsafeBufferPointer { buffer_bindGroupLayouts in 
        var cStruct = WGPUPipelineLayoutDescriptor(
            nextInChain: chainedCStruct, 
            label: cString_label, 
            bindGroupLayoutCount: .init(buffer_bindGroupLayouts.count), 
            bindGroupLayouts: buffer_bindGroupLayouts.baseAddress
        )
        return try body(&cStruct)
        }
        }
        }
    }
}

public struct ProgrammableStageDescriptor: CStructConvertible, Extensible {
    typealias CStruct = WGPUProgrammableStageDescriptor

    public var module: ShaderModule
    public var entryPoint: String

    public var nextInChain: Chained?

    public init(module: ShaderModule, entryPoint: String, nextInChain: Chained? = nil) {
        self.module = module
        self.entryPoint = entryPoint
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUProgrammableStageDescriptor>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        return try self.entryPoint.withCString { cString_entryPoint in
        var cStruct = WGPUProgrammableStageDescriptor(
            nextInChain: chainedCStruct, 
            module: self.module.object, 
            entryPoint: cString_entryPoint
        )
        return try body(&cStruct)
        }
        }
    }
}

public struct QuerySetDescriptor: CStructConvertible, Extensible {
    typealias CStruct = WGPUQuerySetDescriptor

    public var label: String?
    public var type: QueryType
    public var count: UInt32
    public var pipelineStatistics: [PipelineStatisticName]

    public var nextInChain: Chained?

    public init(label: String?, type: QueryType, count: UInt32, pipelineStatistics: [PipelineStatisticName], nextInChain: Chained? = nil) {
        self.label = label
        self.type = type
        self.count = count
        self.pipelineStatistics = pipelineStatistics
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUQuerySetDescriptor>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        return try self.label.withOptionalCString { cString_label in
        return try self.pipelineStatistics.map { $0.cValue }.withUnsafeBufferPointer { buffer_pipelineStatistics in
        var cStruct = WGPUQuerySetDescriptor(
            nextInChain: chainedCStruct, 
            label: cString_label, 
            type: self.type.cValue, 
            count: self.count, 
            pipelineStatistics: buffer_pipelineStatistics.baseAddress, 
            pipelineStatisticsCount: .init(buffer_pipelineStatistics.count)
        )
        return try body(&cStruct)
        }
        }
        }
    }
}

public struct RasterizationStateDescriptor: CStructConvertible, Extensible {
    typealias CStruct = WGPURasterizationStateDescriptor

    public var frontFace: FrontFace
    public var cullMode: CullMode
    public var depthBias: Int32
    public var depthBiasSlopeScale: Float
    public var depthBiasClamp: Float

    public var nextInChain: Chained?

    public init(frontFace: FrontFace, cullMode: CullMode, depthBias: Int32, depthBiasSlopeScale: Float, depthBiasClamp: Float, nextInChain: Chained? = nil) {
        self.frontFace = frontFace
        self.cullMode = cullMode
        self.depthBias = depthBias
        self.depthBiasSlopeScale = depthBiasSlopeScale
        self.depthBiasClamp = depthBiasClamp
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPURasterizationStateDescriptor>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        var cStruct = WGPURasterizationStateDescriptor(
            nextInChain: chainedCStruct, 
            frontFace: self.frontFace.cValue, 
            cullMode: self.cullMode.cValue, 
            depthBias: self.depthBias, 
            depthBiasSlopeScale: self.depthBiasSlopeScale, 
            depthBiasClamp: self.depthBiasClamp
        )
        return try body(&cStruct)
        }
    }
}

public struct RenderBundleDescriptor: CStructConvertible, Extensible {
    typealias CStruct = WGPURenderBundleDescriptor

    public var label: String?

    public var nextInChain: Chained?

    public init(label: String?, nextInChain: Chained? = nil) {
        self.label = label
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPURenderBundleDescriptor>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        return try self.label.withOptionalCString { cString_label in
        var cStruct = WGPURenderBundleDescriptor(
            nextInChain: chainedCStruct, 
            label: cString_label
        )
        return try body(&cStruct)
        }
        }
    }
}

public struct RenderBundleEncoderDescriptor: CStructConvertible, Extensible {
    typealias CStruct = WGPURenderBundleEncoderDescriptor

    public var label: String?
    public var colorFormats: [TextureFormat]
    public var depthStencilFormat: TextureFormat
    public var sampleCount: UInt32

    public var nextInChain: Chained?

    public init(label: String?, colorFormats: [TextureFormat], depthStencilFormat: TextureFormat, sampleCount: UInt32, nextInChain: Chained? = nil) {
        self.label = label
        self.colorFormats = colorFormats
        self.depthStencilFormat = depthStencilFormat
        self.sampleCount = sampleCount
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPURenderBundleEncoderDescriptor>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        return try self.label.withOptionalCString { cString_label in
        return try self.colorFormats.map { $0.cValue }.withUnsafeBufferPointer { buffer_colorFormats in
        var cStruct = WGPURenderBundleEncoderDescriptor(
            nextInChain: chainedCStruct, 
            label: cString_label, 
            colorFormatsCount: .init(buffer_colorFormats.count), 
            colorFormats: buffer_colorFormats.baseAddress, 
            depthStencilFormat: self.depthStencilFormat.cValue, 
            sampleCount: self.sampleCount
        )
        return try body(&cStruct)
        }
        }
        }
    }
}

public struct RenderPassColorAttachmentDescriptor: CStructConvertible {
    typealias CStruct = WGPURenderPassColorAttachmentDescriptor

    public var attachment: TextureView
    public var resolveTarget: TextureView?
    public var loadOp: LoadOp
    public var storeOp: StoreOp
    public var clearColor: Color

    public init(attachment: TextureView, resolveTarget: TextureView?, loadOp: LoadOp, storeOp: StoreOp, clearColor: Color) {
        self.attachment = attachment
        self.resolveTarget = resolveTarget
        self.loadOp = loadOp
        self.storeOp = storeOp
        self.clearColor = clearColor
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPURenderPassColorAttachmentDescriptor>) throws -> R) rethrows -> R {
        return try self.clearColor.withCStruct { cStruct_clearColor in
        var cStruct = WGPURenderPassColorAttachmentDescriptor(
            attachment: self.attachment.object, 
            resolveTarget: self.resolveTarget?.object, 
            loadOp: self.loadOp.cValue, 
            storeOp: self.storeOp.cValue, 
            clearColor: cStruct_clearColor.pointee
        )
        return try body(&cStruct)
        }
    }
}

public struct RenderPassDepthStencilAttachmentDescriptor: CStructConvertible {
    typealias CStruct = WGPURenderPassDepthStencilAttachmentDescriptor

    public var attachment: TextureView
    public var depthLoadOp: LoadOp
    public var depthStoreOp: StoreOp
    public var clearDepth: Float
    public var depthReadOnly: Bool
    public var stencilLoadOp: LoadOp
    public var stencilStoreOp: StoreOp
    public var clearStencil: UInt32
    public var stencilReadOnly: Bool

    public init(attachment: TextureView, depthLoadOp: LoadOp, depthStoreOp: StoreOp, clearDepth: Float, depthReadOnly: Bool, stencilLoadOp: LoadOp, stencilStoreOp: StoreOp, clearStencil: UInt32, stencilReadOnly: Bool) {
        self.attachment = attachment
        self.depthLoadOp = depthLoadOp
        self.depthStoreOp = depthStoreOp
        self.clearDepth = clearDepth
        self.depthReadOnly = depthReadOnly
        self.stencilLoadOp = stencilLoadOp
        self.stencilStoreOp = stencilStoreOp
        self.clearStencil = clearStencil
        self.stencilReadOnly = stencilReadOnly
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPURenderPassDepthStencilAttachmentDescriptor>) throws -> R) rethrows -> R {
        var cStruct = WGPURenderPassDepthStencilAttachmentDescriptor(
            attachment: self.attachment.object, 
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

public struct RenderPassDescriptor: CStructConvertible, Extensible {
    typealias CStruct = WGPURenderPassDescriptor

    public var label: String?
    public var colorAttachments: [RenderPassColorAttachmentDescriptor]
    public var depthStencilAttachment: RenderPassDepthStencilAttachmentDescriptor?
    public var occlusionQuerySet: QuerySet?

    public var nextInChain: Chained?

    public init(label: String?, colorAttachments: [RenderPassColorAttachmentDescriptor], depthStencilAttachment: RenderPassDepthStencilAttachmentDescriptor?, occlusionQuerySet: QuerySet?, nextInChain: Chained? = nil) {
        self.label = label
        self.colorAttachments = colorAttachments
        self.depthStencilAttachment = depthStencilAttachment
        self.occlusionQuerySet = occlusionQuerySet
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPURenderPassDescriptor>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        return try self.label.withOptionalCString { cString_label in
        return try self.colorAttachments.withCStructBufferPointer { buffer_colorAttachments in
        return try self.depthStencilAttachment.withOptionalCStruct { cStruct_depthStencilAttachment in
        var cStruct = WGPURenderPassDescriptor(
            nextInChain: chainedCStruct, 
            label: cString_label, 
            colorAttachmentCount: .init(buffer_colorAttachments.count), 
            colorAttachments: buffer_colorAttachments.baseAddress, 
            depthStencilAttachment: cStruct_depthStencilAttachment, 
            occlusionQuerySet: self.occlusionQuerySet?.object
        )
        return try body(&cStruct)
        }
        }
        }
        }
    }
}

public struct RenderPipelineDescriptor: CStructConvertible, Extensible {
    typealias CStruct = WGPURenderPipelineDescriptor

    public var label: String?
    public var layout: PipelineLayout?
    public var vertexStage: ProgrammableStageDescriptor
    public var fragmentStage: ProgrammableStageDescriptor?
    public var vertexState: VertexStateDescriptor?
    public var primitiveTopology: PrimitiveTopology
    public var rasterizationState: RasterizationStateDescriptor?
    public var sampleCount: UInt32
    public var depthStencilState: DepthStencilStateDescriptor?
    public var colorStates: [ColorStateDescriptor]
    public var sampleMask: UInt32
    public var alphaToCoverageEnabled: Bool

    public var nextInChain: Chained?

    public init(label: String?, layout: PipelineLayout?, vertexStage: ProgrammableStageDescriptor, fragmentStage: ProgrammableStageDescriptor?, vertexState: VertexStateDescriptor?, primitiveTopology: PrimitiveTopology, rasterizationState: RasterizationStateDescriptor?, sampleCount: UInt32, depthStencilState: DepthStencilStateDescriptor?, colorStates: [ColorStateDescriptor], sampleMask: UInt32, alphaToCoverageEnabled: Bool, nextInChain: Chained? = nil) {
        self.label = label
        self.layout = layout
        self.vertexStage = vertexStage
        self.fragmentStage = fragmentStage
        self.vertexState = vertexState
        self.primitiveTopology = primitiveTopology
        self.rasterizationState = rasterizationState
        self.sampleCount = sampleCount
        self.depthStencilState = depthStencilState
        self.colorStates = colorStates
        self.sampleMask = sampleMask
        self.alphaToCoverageEnabled = alphaToCoverageEnabled
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPURenderPipelineDescriptor>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        return try self.label.withOptionalCString { cString_label in
        return try self.vertexStage.withCStruct { cStruct_vertexStage in
        return try self.fragmentStage.withOptionalCStruct { cStruct_fragmentStage in
        return try self.vertexState.withOptionalCStruct { cStruct_vertexState in
        return try self.rasterizationState.withOptionalCStruct { cStruct_rasterizationState in
        return try self.depthStencilState.withOptionalCStruct { cStruct_depthStencilState in
        return try self.colorStates.withCStructBufferPointer { buffer_colorStates in
        var cStruct = WGPURenderPipelineDescriptor(
            nextInChain: chainedCStruct, 
            label: cString_label, 
            layout: self.layout?.object, 
            vertexStage: cStruct_vertexStage.pointee, 
            fragmentStage: cStruct_fragmentStage, 
            vertexState: cStruct_vertexState, 
            primitiveTopology: self.primitiveTopology.cValue, 
            rasterizationState: cStruct_rasterizationState, 
            sampleCount: self.sampleCount, 
            depthStencilState: cStruct_depthStencilState, 
            colorStateCount: .init(buffer_colorStates.count), 
            colorStates: buffer_colorStates.baseAddress, 
            sampleMask: self.sampleMask, 
            alphaToCoverageEnabled: self.alphaToCoverageEnabled
        )
        return try body(&cStruct)
        }
        }
        }
        }
        }
        }
        }
        }
    }
}

public struct RenderPipelineDescriptorDummyExtension: CStructConvertible, Chained {
    typealias CStruct = WGPURenderPipelineDescriptorDummyExtension

    public var dummyStage: ProgrammableStageDescriptor

    public var nextInChain: Chained?

    public init(dummyStage: ProgrammableStageDescriptor, nextInChain: Chained? = nil) {
        self.dummyStage = dummyStage
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPURenderPipelineDescriptorDummyExtension>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        return try self.dummyStage.withCStruct { cStruct_dummyStage in
        var cStruct = WGPURenderPipelineDescriptorDummyExtension(
            chain: WGPUChainedStruct(next: chainedCStruct, sType: WGPUSType_RenderPipelineDescriptorDummyExtension), 
            dummyStage: cStruct_dummyStage.pointee
        )
        return try body(&cStruct)
        }
        }
    }

    public func withChainedCStruct<R>(_ body: (UnsafePointer<WGPUChainedStruct>) throws -> R) rethrows -> R {
        return try withCStruct { cStruct in
            let chainedCStruct = UnsafeRawPointer(cStruct).bindMemory(to: WGPUChainedStruct.self, capacity: 1)
            return try body(chainedCStruct)
        }
    }
}

public struct SamplerDescriptor: CStructConvertible, Extensible {
    typealias CStruct = WGPUSamplerDescriptor

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

    public var nextInChain: Chained?

    public init(label: String?, addressModeU: AddressMode, addressModeV: AddressMode, addressModeW: AddressMode, magFilter: FilterMode, minFilter: FilterMode, mipmapFilter: FilterMode, lodMinClamp: Float, lodMaxClamp: Float, compare: CompareFunction, maxAnisotropy: UInt16, nextInChain: Chained? = nil) {
        self.label = label
        self.addressModeU = addressModeU
        self.addressModeV = addressModeV
        self.addressModeW = addressModeW
        self.magFilter = magFilter
        self.minFilter = minFilter
        self.mipmapFilter = mipmapFilter
        self.lodMinClamp = lodMinClamp
        self.lodMaxClamp = lodMaxClamp
        self.compare = compare
        self.maxAnisotropy = maxAnisotropy
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUSamplerDescriptor>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        return try self.label.withOptionalCString { cString_label in
        var cStruct = WGPUSamplerDescriptor(
            nextInChain: chainedCStruct, 
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
}

public struct SamplerDescriptorDummyAnisotropicFiltering: CStructConvertible, Chained {
    typealias CStruct = WGPUSamplerDescriptorDummyAnisotropicFiltering

    public var maxAnisotropy: Float

    public var nextInChain: Chained?

    public init(maxAnisotropy: Float, nextInChain: Chained? = nil) {
        self.maxAnisotropy = maxAnisotropy
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUSamplerDescriptorDummyAnisotropicFiltering>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        var cStruct = WGPUSamplerDescriptorDummyAnisotropicFiltering(
            chain: WGPUChainedStruct(next: chainedCStruct, sType: WGPUSType_SamplerDescriptorDummyAnisotropicFiltering), 
            maxAnisotropy: self.maxAnisotropy
        )
        return try body(&cStruct)
        }
    }

    public func withChainedCStruct<R>(_ body: (UnsafePointer<WGPUChainedStruct>) throws -> R) rethrows -> R {
        return try withCStruct { cStruct in
            let chainedCStruct = UnsafeRawPointer(cStruct).bindMemory(to: WGPUChainedStruct.self, capacity: 1)
            return try body(chainedCStruct)
        }
    }
}

public struct ShaderModuleDescriptor: CStructConvertible, Extensible {
    typealias CStruct = WGPUShaderModuleDescriptor

    public var label: String?

    public var nextInChain: Chained?

    public init(label: String?, nextInChain: Chained? = nil) {
        self.label = label
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUShaderModuleDescriptor>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        return try self.label.withOptionalCString { cString_label in
        var cStruct = WGPUShaderModuleDescriptor(
            nextInChain: chainedCStruct, 
            label: cString_label
        )
        return try body(&cStruct)
        }
        }
    }
}

public struct ShaderModuleSpirvDescriptor: CStructConvertible, Chained {
    typealias CStruct = WGPUShaderModuleSPIRVDescriptor

    public var code: [UInt32]

    public var nextInChain: Chained?

    public init(code: [UInt32], nextInChain: Chained? = nil) {
        self.code = code
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUShaderModuleSPIRVDescriptor>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        return try self.code.withUnsafeBufferPointer { buffer_code in
        var cStruct = WGPUShaderModuleSPIRVDescriptor(
            chain: WGPUChainedStruct(next: chainedCStruct, sType: WGPUSType_ShaderModuleSPIRVDescriptor), 
            codeSize: .init(buffer_code.count), 
            code: buffer_code.baseAddress
        )
        return try body(&cStruct)
        }
        }
    }

    public func withChainedCStruct<R>(_ body: (UnsafePointer<WGPUChainedStruct>) throws -> R) rethrows -> R {
        return try withCStruct { cStruct in
            let chainedCStruct = UnsafeRawPointer(cStruct).bindMemory(to: WGPUChainedStruct.self, capacity: 1)
            return try body(chainedCStruct)
        }
    }
}

public struct ShaderModuleWgslDescriptor: CStructConvertible, Chained {
    typealias CStruct = WGPUShaderModuleWGSLDescriptor

    public var source: String

    public var nextInChain: Chained?

    public init(source: String, nextInChain: Chained? = nil) {
        self.source = source
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUShaderModuleWGSLDescriptor>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        return try self.source.withCString { cString_source in
        var cStruct = WGPUShaderModuleWGSLDescriptor(
            chain: WGPUChainedStruct(next: chainedCStruct, sType: WGPUSType_ShaderModuleWGSLDescriptor), 
            source: cString_source
        )
        return try body(&cStruct)
        }
        }
    }

    public func withChainedCStruct<R>(_ body: (UnsafePointer<WGPUChainedStruct>) throws -> R) rethrows -> R {
        return try withCStruct { cStruct in
            let chainedCStruct = UnsafeRawPointer(cStruct).bindMemory(to: WGPUChainedStruct.self, capacity: 1)
            return try body(chainedCStruct)
        }
    }
}

public struct StencilStateFaceDescriptor: CStructConvertible {
    typealias CStruct = WGPUStencilStateFaceDescriptor

    public var compare: CompareFunction
    public var failOp: StencilOperation
    public var depthFailOp: StencilOperation
    public var passOp: StencilOperation

    public init(compare: CompareFunction, failOp: StencilOperation, depthFailOp: StencilOperation, passOp: StencilOperation) {
        self.compare = compare
        self.failOp = failOp
        self.depthFailOp = depthFailOp
        self.passOp = passOp
    }

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

public struct SurfaceDescriptor: CStructConvertible, Extensible {
    typealias CStruct = WGPUSurfaceDescriptor

    public var label: String?

    public var nextInChain: Chained?

    public init(label: String?, nextInChain: Chained? = nil) {
        self.label = label
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUSurfaceDescriptor>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        return try self.label.withOptionalCString { cString_label in
        var cStruct = WGPUSurfaceDescriptor(
            nextInChain: chainedCStruct, 
            label: cString_label
        )
        return try body(&cStruct)
        }
        }
    }
}

public struct SurfaceDescriptorFromCanvasHtmlSelector: CStructConvertible, Chained {
    typealias CStruct = WGPUSurfaceDescriptorFromCanvasHTMLSelector

    public var selector: String

    public var nextInChain: Chained?

    public init(selector: String, nextInChain: Chained? = nil) {
        self.selector = selector
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUSurfaceDescriptorFromCanvasHTMLSelector>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        return try self.selector.withCString { cString_selector in
        var cStruct = WGPUSurfaceDescriptorFromCanvasHTMLSelector(
            chain: WGPUChainedStruct(next: chainedCStruct, sType: WGPUSType_SurfaceDescriptorFromCanvasHTMLSelector), 
            selector: cString_selector
        )
        return try body(&cStruct)
        }
        }
    }

    public func withChainedCStruct<R>(_ body: (UnsafePointer<WGPUChainedStruct>) throws -> R) rethrows -> R {
        return try withCStruct { cStruct in
            let chainedCStruct = UnsafeRawPointer(cStruct).bindMemory(to: WGPUChainedStruct.self, capacity: 1)
            return try body(chainedCStruct)
        }
    }
}

public struct SurfaceDescriptorFromMetalLayer: CStructConvertible, Chained {
    typealias CStruct = WGPUSurfaceDescriptorFromMetalLayer

    public var layer: UnsafeMutableRawPointer!

    public var nextInChain: Chained?

    public init(layer: UnsafeMutableRawPointer!, nextInChain: Chained? = nil) {
        self.layer = layer
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUSurfaceDescriptorFromMetalLayer>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        var cStruct = WGPUSurfaceDescriptorFromMetalLayer(
            chain: WGPUChainedStruct(next: chainedCStruct, sType: WGPUSType_SurfaceDescriptorFromMetalLayer), 
            layer: self.layer
        )
        return try body(&cStruct)
        }
    }

    public func withChainedCStruct<R>(_ body: (UnsafePointer<WGPUChainedStruct>) throws -> R) rethrows -> R {
        return try withCStruct { cStruct in
            let chainedCStruct = UnsafeRawPointer(cStruct).bindMemory(to: WGPUChainedStruct.self, capacity: 1)
            return try body(chainedCStruct)
        }
    }
}

public struct SurfaceDescriptorFromWindowsHwnd: CStructConvertible, Chained {
    typealias CStruct = WGPUSurfaceDescriptorFromWindowsHWND

    public var hinstance: UnsafeMutableRawPointer!
    public var hwnd: UnsafeMutableRawPointer!

    public var nextInChain: Chained?

    public init(hinstance: UnsafeMutableRawPointer!, hwnd: UnsafeMutableRawPointer!, nextInChain: Chained? = nil) {
        self.hinstance = hinstance
        self.hwnd = hwnd
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUSurfaceDescriptorFromWindowsHWND>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        var cStruct = WGPUSurfaceDescriptorFromWindowsHWND(
            chain: WGPUChainedStruct(next: chainedCStruct, sType: WGPUSType_SurfaceDescriptorFromWindowsHWND), 
            hinstance: self.hinstance, 
            hwnd: self.hwnd
        )
        return try body(&cStruct)
        }
    }

    public func withChainedCStruct<R>(_ body: (UnsafePointer<WGPUChainedStruct>) throws -> R) rethrows -> R {
        return try withCStruct { cStruct in
            let chainedCStruct = UnsafeRawPointer(cStruct).bindMemory(to: WGPUChainedStruct.self, capacity: 1)
            return try body(chainedCStruct)
        }
    }
}

public struct SurfaceDescriptorFromXlib: CStructConvertible, Chained {
    typealias CStruct = WGPUSurfaceDescriptorFromXlib

    public var display: UnsafeMutableRawPointer!
    public var window: UInt32

    public var nextInChain: Chained?

    public init(display: UnsafeMutableRawPointer!, window: UInt32, nextInChain: Chained? = nil) {
        self.display = display
        self.window = window
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUSurfaceDescriptorFromXlib>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        var cStruct = WGPUSurfaceDescriptorFromXlib(
            chain: WGPUChainedStruct(next: chainedCStruct, sType: WGPUSType_SurfaceDescriptorFromXlib), 
            display: self.display, 
            window: self.window
        )
        return try body(&cStruct)
        }
    }

    public func withChainedCStruct<R>(_ body: (UnsafePointer<WGPUChainedStruct>) throws -> R) rethrows -> R {
        return try withCStruct { cStruct in
            let chainedCStruct = UnsafeRawPointer(cStruct).bindMemory(to: WGPUChainedStruct.self, capacity: 1)
            return try body(chainedCStruct)
        }
    }
}

public struct SwapChainDescriptor: CStructConvertible, Extensible {
    typealias CStruct = WGPUSwapChainDescriptor

    public var label: String?
    public var usage: TextureUsage
    public var format: TextureFormat
    public var width: UInt32
    public var height: UInt32
    public var presentMode: PresentMode
    public var implementation: UInt64

    public var nextInChain: Chained?

    public init(label: String?, usage: TextureUsage, format: TextureFormat, width: UInt32, height: UInt32, presentMode: PresentMode, implementation: UInt64, nextInChain: Chained? = nil) {
        self.label = label
        self.usage = usage
        self.format = format
        self.width = width
        self.height = height
        self.presentMode = presentMode
        self.implementation = implementation
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUSwapChainDescriptor>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        return try self.label.withOptionalCString { cString_label in
        var cStruct = WGPUSwapChainDescriptor(
            nextInChain: chainedCStruct, 
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
}

public struct TextureCopyView: CStructConvertible, Extensible {
    typealias CStruct = WGPUTextureCopyView

    public var texture: Texture
    public var mipLevel: UInt32
    public var origin: Origin3d
    public var aspect: TextureAspect

    public var nextInChain: Chained?

    public init(texture: Texture, mipLevel: UInt32, origin: Origin3d, aspect: TextureAspect, nextInChain: Chained? = nil) {
        self.texture = texture
        self.mipLevel = mipLevel
        self.origin = origin
        self.aspect = aspect
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUTextureCopyView>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        return try self.origin.withCStruct { cStruct_origin in
        var cStruct = WGPUTextureCopyView(
            nextInChain: chainedCStruct, 
            texture: self.texture.object, 
            mipLevel: self.mipLevel, 
            origin: cStruct_origin.pointee, 
            aspect: self.aspect.cValue
        )
        return try body(&cStruct)
        }
        }
    }
}

public struct TextureDataLayout: CStructConvertible, Extensible {
    typealias CStruct = WGPUTextureDataLayout

    public var offset: UInt64
    public var bytesPerRow: UInt32
    public var rowsPerImage: UInt32

    public var nextInChain: Chained?

    public init(offset: UInt64, bytesPerRow: UInt32, rowsPerImage: UInt32, nextInChain: Chained? = nil) {
        self.offset = offset
        self.bytesPerRow = bytesPerRow
        self.rowsPerImage = rowsPerImage
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUTextureDataLayout>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        var cStruct = WGPUTextureDataLayout(
            nextInChain: chainedCStruct, 
            offset: self.offset, 
            bytesPerRow: self.bytesPerRow, 
            rowsPerImage: self.rowsPerImage
        )
        return try body(&cStruct)
        }
    }
}

public struct TextureDescriptor: CStructConvertible, Extensible {
    typealias CStruct = WGPUTextureDescriptor

    public var label: String?
    public var usage: TextureUsage
    public var dimension: TextureDimension
    public var size: Extent3d
    public var format: TextureFormat
    public var mipLevelCount: UInt32
    public var sampleCount: UInt32

    public var nextInChain: Chained?

    public init(label: String?, usage: TextureUsage, dimension: TextureDimension, size: Extent3d, format: TextureFormat, mipLevelCount: UInt32, sampleCount: UInt32, nextInChain: Chained? = nil) {
        self.label = label
        self.usage = usage
        self.dimension = dimension
        self.size = size
        self.format = format
        self.mipLevelCount = mipLevelCount
        self.sampleCount = sampleCount
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUTextureDescriptor>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        return try self.label.withOptionalCString { cString_label in
        return try self.size.withCStruct { cStruct_size in
        var cStruct = WGPUTextureDescriptor(
            nextInChain: chainedCStruct, 
            label: cString_label, 
            usage: self.usage.rawValue, 
            dimension: self.dimension.cValue, 
            size: cStruct_size.pointee, 
            format: self.format.cValue, 
            mipLevelCount: self.mipLevelCount, 
            sampleCount: self.sampleCount
        )
        return try body(&cStruct)
        }
        }
        }
    }
}

public struct TextureViewDescriptor: CStructConvertible, Extensible {
    typealias CStruct = WGPUTextureViewDescriptor

    public var label: String?
    public var format: TextureFormat
    public var dimension: TextureViewDimension
    public var baseMipLevel: UInt32
    public var mipLevelCount: UInt32
    public var baseArrayLayer: UInt32
    public var arrayLayerCount: UInt32
    public var aspect: TextureAspect

    public var nextInChain: Chained?

    public init(label: String?, format: TextureFormat, dimension: TextureViewDimension, baseMipLevel: UInt32, mipLevelCount: UInt32, baseArrayLayer: UInt32, arrayLayerCount: UInt32, aspect: TextureAspect, nextInChain: Chained? = nil) {
        self.label = label
        self.format = format
        self.dimension = dimension
        self.baseMipLevel = baseMipLevel
        self.mipLevelCount = mipLevelCount
        self.baseArrayLayer = baseArrayLayer
        self.arrayLayerCount = arrayLayerCount
        self.aspect = aspect
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUTextureViewDescriptor>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        return try self.label.withOptionalCString { cString_label in
        var cStruct = WGPUTextureViewDescriptor(
            nextInChain: chainedCStruct, 
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
}

