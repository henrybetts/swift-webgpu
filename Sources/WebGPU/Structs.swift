import CWebGPU

public struct AdapterProperties: CStructConvertible {
    typealias CStruct = WGPUAdapterProperties

    public var vendorId: UInt32
    public var deviceId: UInt32
    public var name: String
    public var driverDescription: String
    public var adapterType: AdapterType
    public var backendType: BackendType

    public init(vendorId: UInt32, deviceId: UInt32, name: String, driverDescription: String, adapterType: AdapterType, backendType: BackendType) {
        self.vendorId = vendorId
        self.deviceId = deviceId
        self.name = name
        self.driverDescription = driverDescription
        self.adapterType = adapterType
        self.backendType = backendType
    }


    func withCStruct<R>(_ body: (UnsafePointer<WGPUAdapterProperties>) throws -> R) rethrows -> R {
        return try self.name.withCString { cString_name in
        return try self.driverDescription.withCString { cString_driverDescription in
        var cStruct = WGPUAdapterProperties(
            nextInChain: nil, 
            vendorID: self.vendorId, 
            deviceID: self.deviceId, 
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

public struct BindGroupEntry: CStructConvertible, Extensible {
    typealias CStruct = WGPUBindGroupEntry

    public var binding: UInt32
    public var buffer: Buffer?
    public var offset: UInt64
    public var size: UInt64
    public var sampler: Sampler?
    public var textureView: TextureView?

    public var nextInChain: Chained?

    public init(binding: UInt32, buffer: Buffer? = nil, offset: UInt64 = 0, size: UInt64, sampler: Sampler? = nil, textureView: TextureView? = nil) {
        self.binding = binding
        self.buffer = buffer
        self.offset = offset
        self.size = size
        self.sampler = sampler
        self.textureView = textureView
    }

    public init(binding: UInt32, buffer: Buffer?, offset: UInt64, size: UInt64, sampler: Sampler?, textureView: TextureView?, nextInChain: Chained?) {
        self.binding = binding
        self.buffer = buffer
        self.offset = offset
        self.size = size
        self.sampler = sampler
        self.textureView = textureView
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUBindGroupEntry>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        return try self.buffer.withOptionalHandle { handle_buffer in
        return try self.sampler.withOptionalHandle { handle_sampler in
        return try self.textureView.withOptionalHandle { handle_textureView in
        var cStruct = WGPUBindGroupEntry(
            nextInChain: chainedCStruct, 
            binding: self.binding, 
            buffer: handle_buffer, 
            offset: self.offset, 
            size: self.size, 
            sampler: handle_sampler, 
            textureView: handle_textureView
        )
        return try body(&cStruct)
        }
        }
        }
        }
    }
}

public struct BindGroupDescriptor: CStructConvertible, Extensible {
    typealias CStruct = WGPUBindGroupDescriptor

    public var label: String?
    public var layout: BindGroupLayout
    public var entries: [BindGroupEntry]

    public var nextInChain: Chained?

    public init(label: String? = nil, layout: BindGroupLayout, entries: [BindGroupEntry]) {
        self.label = label
        self.layout = layout
        self.entries = entries
    }

    public init(label: String?, layout: BindGroupLayout, entries: [BindGroupEntry], nextInChain: Chained?) {
        self.label = label
        self.layout = layout
        self.entries = entries
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUBindGroupDescriptor>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        return try self.label.withOptionalCString { cString_label in
        return try self.layout.withUnsafeHandle { handle_layout in
        return try self.entries.withCStructBufferPointer { buffer_entries in
        var cStruct = WGPUBindGroupDescriptor(
            nextInChain: chainedCStruct, 
            label: cString_label, 
            layout: handle_layout, 
            entryCount: .init(buffer_entries.count), 
            entries: buffer_entries.baseAddress
        )
        return try body(&cStruct)
        }
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

    public init(type: BufferBindingType = .undefined, hasDynamicOffset: Bool = false, minBindingSize: UInt64 = 0) {
        self.type = type
        self.hasDynamicOffset = hasDynamicOffset
        self.minBindingSize = minBindingSize
    }

    public init(type: BufferBindingType, hasDynamicOffset: Bool, minBindingSize: UInt64, nextInChain: Chained?) {
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

    public init(type: SamplerBindingType = .undefined) {
        self.type = type
    }

    public init(type: SamplerBindingType, nextInChain: Chained?) {
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

    public init(sampleType: TextureSampleType = .undefined, viewDimension: TextureViewDimension = .typeUndefined, multisampled: Bool = false) {
        self.sampleType = sampleType
        self.viewDimension = viewDimension
        self.multisampled = multisampled
    }

    public init(sampleType: TextureSampleType, viewDimension: TextureViewDimension, multisampled: Bool, nextInChain: Chained?) {
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

public struct ExternalTextureBindingEntry: CStructConvertible, Chained {
    typealias CStruct = WGPUExternalTextureBindingEntry

    public var externalTexture: ExternalTexture

    public var nextInChain: Chained?

    public init(externalTexture: ExternalTexture) {
        self.externalTexture = externalTexture
    }

    public init(externalTexture: ExternalTexture, nextInChain: Chained?) {
        self.externalTexture = externalTexture
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUExternalTextureBindingEntry>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        return try self.externalTexture.withUnsafeHandle { handle_externalTexture in
        var cStruct = WGPUExternalTextureBindingEntry(
            chain: WGPUChainedStruct(next: chainedCStruct, sType: WGPUSType_ExternalTextureBindingEntry), 
            externalTexture: handle_externalTexture
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

public struct ExternalTextureBindingLayout: CStructConvertible, Chained {
    typealias CStruct = WGPUExternalTextureBindingLayout


    public var nextInChain: Chained?

    public init() {
    }

    public init(nextInChain: Chained?) {
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUExternalTextureBindingLayout>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        var cStruct = WGPUExternalTextureBindingLayout(
            chain: WGPUChainedStruct(next: chainedCStruct, sType: WGPUSType_ExternalTextureBindingLayout)
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

public struct StorageTextureBindingLayout: CStructConvertible, Extensible {
    typealias CStruct = WGPUStorageTextureBindingLayout

    public var access: StorageTextureAccess
    public var format: TextureFormat
    public var viewDimension: TextureViewDimension

    public var nextInChain: Chained?

    public init(access: StorageTextureAccess = .undefined, format: TextureFormat = .undefined, viewDimension: TextureViewDimension = .typeUndefined) {
        self.access = access
        self.format = format
        self.viewDimension = viewDimension
    }

    public init(access: StorageTextureAccess, format: TextureFormat, viewDimension: TextureViewDimension, nextInChain: Chained?) {
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
    public var buffer: BufferBindingLayout
    public var sampler: SamplerBindingLayout
    public var texture: TextureBindingLayout
    public var storageTexture: StorageTextureBindingLayout

    public var nextInChain: Chained?

    public init(binding: UInt32, visibility: ShaderStage, buffer: BufferBindingLayout = BufferBindingLayout(), sampler: SamplerBindingLayout = SamplerBindingLayout(), texture: TextureBindingLayout = TextureBindingLayout(), storageTexture: StorageTextureBindingLayout = StorageTextureBindingLayout()) {
        self.binding = binding
        self.visibility = visibility
        self.buffer = buffer
        self.sampler = sampler
        self.texture = texture
        self.storageTexture = storageTexture
    }

    public init(binding: UInt32, visibility: ShaderStage, buffer: BufferBindingLayout, sampler: SamplerBindingLayout, texture: TextureBindingLayout, storageTexture: StorageTextureBindingLayout, nextInChain: Chained?) {
        self.binding = binding
        self.visibility = visibility
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

    public init(label: String? = nil, entries: [BindGroupLayoutEntry]) {
        self.label = label
        self.entries = entries
    }

    public init(label: String?, entries: [BindGroupLayoutEntry], nextInChain: Chained?) {
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

public struct BlendComponent: CStructConvertible {
    typealias CStruct = WGPUBlendComponent

    public var operation: BlendOperation
    public var srcFactor: BlendFactor
    public var dstFactor: BlendFactor

    public init(operation: BlendOperation = .add, srcFactor: BlendFactor = .one, dstFactor: BlendFactor = .zero) {
        self.operation = operation
        self.srcFactor = srcFactor
        self.dstFactor = dstFactor
    }

    init(cStruct: WGPUBlendComponent) {
        self.operation = .init(cValue: cStruct.operation)
        self.srcFactor = .init(cValue: cStruct.srcFactor)
        self.dstFactor = .init(cValue: cStruct.dstFactor)
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUBlendComponent>) throws -> R) rethrows -> R {
        var cStruct = WGPUBlendComponent(
            operation: self.operation.cValue, 
            srcFactor: self.srcFactor.cValue, 
            dstFactor: self.dstFactor.cValue
        )
        return try body(&cStruct)
    }
}

public struct BufferDescriptor: CStructConvertible, Extensible {
    typealias CStruct = WGPUBufferDescriptor

    public var label: String?
    public var usage: BufferUsage
    public var size: UInt64
    public var mappedAtCreation: Bool

    public var nextInChain: Chained?

    public init(label: String? = nil, usage: BufferUsage, size: UInt64, mappedAtCreation: Bool = false) {
        self.label = label
        self.usage = usage
        self.size = size
        self.mappedAtCreation = mappedAtCreation
    }

    public init(label: String?, usage: BufferUsage, size: UInt64, mappedAtCreation: Bool, nextInChain: Chained?) {
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

    init(cStruct: WGPUColor) {
        self.r = cStruct.r
        self.g = cStruct.g
        self.b = cStruct.b
        self.a = cStruct.a
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

public struct ConstantEntry: CStructConvertible, Extensible {
    typealias CStruct = WGPUConstantEntry

    public var key: String
    public var value: Double

    public var nextInChain: Chained?

    public init(key: String, value: Double) {
        self.key = key
        self.value = value
    }

    public init(key: String, value: Double, nextInChain: Chained?) {
        self.key = key
        self.value = value
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUConstantEntry>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        return try self.key.withCString { cString_key in
        var cStruct = WGPUConstantEntry(
            nextInChain: chainedCStruct, 
            key: cString_key, 
            value: self.value
        )
        return try body(&cStruct)
        }
        }
    }
}

public struct CommandBufferDescriptor: CStructConvertible, Extensible {
    typealias CStruct = WGPUCommandBufferDescriptor

    public var label: String?

    public var nextInChain: Chained?

    public init(label: String? = nil) {
        self.label = label
    }

    public init(label: String?, nextInChain: Chained?) {
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

    public init(label: String? = nil) {
        self.label = label
    }

    public init(label: String?, nextInChain: Chained?) {
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

public struct CompilationInfo: CStructConvertible {
    typealias CStruct = WGPUCompilationInfo

    public var messages: [CompilationMessage]

    public init(messages: [CompilationMessage]) {
        self.messages = messages
    }

    init(cStruct: WGPUCompilationInfo) {
        self.messages = UnsafeBufferPointer(start: cStruct.messages, count: Int(cStruct.messageCount)).map { .init(cStruct: $0) }
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUCompilationInfo>) throws -> R) rethrows -> R {
        return try self.messages.withCStructBufferPointer { buffer_messages in
        var cStruct = WGPUCompilationInfo(
            messageCount: .init(buffer_messages.count), 
            messages: buffer_messages.baseAddress
        )
        return try body(&cStruct)
        }
    }
}

public struct CompilationMessage: CStructConvertible {
    typealias CStruct = WGPUCompilationMessage

    public var message: String?
    public var type: CompilationMessageType
    public var lineNum: UInt64
    public var linePos: UInt64
    public var offset: UInt64
    public var length: UInt64

    public init(message: String? = nil, type: CompilationMessageType, lineNum: UInt64, linePos: UInt64, offset: UInt64, length: UInt64) {
        self.message = message
        self.type = type
        self.lineNum = lineNum
        self.linePos = linePos
        self.offset = offset
        self.length = length
    }

    init(cStruct: WGPUCompilationMessage) {
        self.message = cStruct.message != nil ? String(cString: cStruct.message) : nil
        self.type = .init(cValue: cStruct.type)
        self.lineNum = cStruct.lineNum
        self.linePos = cStruct.linePos
        self.offset = cStruct.offset
        self.length = cStruct.length
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUCompilationMessage>) throws -> R) rethrows -> R {
        return try self.message.withOptionalCString { cString_message in
        var cStruct = WGPUCompilationMessage(
            message: cString_message, 
            type: self.type.cValue, 
            lineNum: self.lineNum, 
            linePos: self.linePos, 
            offset: self.offset, 
            length: self.length
        )
        return try body(&cStruct)
        }
    }
}

public struct ComputePassDescriptor: CStructConvertible, Extensible {
    typealias CStruct = WGPUComputePassDescriptor

    public var label: String?

    public var nextInChain: Chained?

    public init(label: String? = nil) {
        self.label = label
    }

    public init(label: String?, nextInChain: Chained?) {
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
    public var compute: ProgrammableStageDescriptor

    public var nextInChain: Chained?

    public init(label: String? = nil, layout: PipelineLayout? = nil, compute: ProgrammableStageDescriptor) {
        self.label = label
        self.layout = layout
        self.compute = compute
    }

    public init(label: String?, layout: PipelineLayout?, compute: ProgrammableStageDescriptor, nextInChain: Chained?) {
        self.label = label
        self.layout = layout
        self.compute = compute
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUComputePipelineDescriptor>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        return try self.label.withOptionalCString { cString_label in
        return try self.layout.withOptionalHandle { handle_layout in
        return try self.compute.withCStruct { cStruct_compute in
        var cStruct = WGPUComputePipelineDescriptor(
            nextInChain: chainedCStruct, 
            label: cString_label, 
            layout: handle_layout, 
            compute: cStruct_compute.pointee
        )
        return try body(&cStruct)
        }
        }
        }
        }
    }
}

public struct CopyTextureForBrowserOptions: CStructConvertible, Extensible {
    typealias CStruct = WGPUCopyTextureForBrowserOptions

    public var flipY: Bool
    public var alphaOp: AlphaOp

    public var nextInChain: Chained?

    public init(flipY: Bool = false, alphaOp: AlphaOp = .dontChange) {
        self.flipY = flipY
        self.alphaOp = alphaOp
    }

    public init(flipY: Bool, alphaOp: AlphaOp, nextInChain: Chained?) {
        self.flipY = flipY
        self.alphaOp = alphaOp
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUCopyTextureForBrowserOptions>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        var cStruct = WGPUCopyTextureForBrowserOptions(
            nextInChain: chainedCStruct, 
            flipY: self.flipY, 
            alphaOp: self.alphaOp.cValue
        )
        return try body(&cStruct)
        }
    }
}

public struct DeviceProperties: CStructConvertible {
    typealias CStruct = WGPUDeviceProperties

    public var deviceId: UInt32
    public var vendorId: UInt32
    public var textureCompressionBc: Bool
    public var textureCompressionEtc2: Bool
    public var textureCompressionAstc: Bool
    public var shaderFloat16: Bool
    public var pipelineStatisticsQuery: Bool
    public var timestampQuery: Bool
    public var multiPlanarFormats: Bool
    public var depthClamping: Bool
    public var invalidFeature: Bool
    public var dawnInternalUsages: Bool
    public var limits: SupportedLimits

    public init(deviceId: UInt32, vendorId: UInt32, textureCompressionBc: Bool = false, textureCompressionEtc2: Bool = false, textureCompressionAstc: Bool = false, shaderFloat16: Bool = false, pipelineStatisticsQuery: Bool = false, timestampQuery: Bool = false, multiPlanarFormats: Bool = false, depthClamping: Bool = false, invalidFeature: Bool = false, dawnInternalUsages: Bool = false, limits: SupportedLimits = SupportedLimits()) {
        self.deviceId = deviceId
        self.vendorId = vendorId
        self.textureCompressionBc = textureCompressionBc
        self.textureCompressionEtc2 = textureCompressionEtc2
        self.textureCompressionAstc = textureCompressionAstc
        self.shaderFloat16 = shaderFloat16
        self.pipelineStatisticsQuery = pipelineStatisticsQuery
        self.timestampQuery = timestampQuery
        self.multiPlanarFormats = multiPlanarFormats
        self.depthClamping = depthClamping
        self.invalidFeature = invalidFeature
        self.dawnInternalUsages = dawnInternalUsages
        self.limits = limits
    }


    func withCStruct<R>(_ body: (UnsafePointer<WGPUDeviceProperties>) throws -> R) rethrows -> R {
        return try self.limits.withCStruct { cStruct_limits in
        var cStruct = WGPUDeviceProperties(
            deviceID: self.deviceId, 
            vendorID: self.vendorId, 
            textureCompressionBC: self.textureCompressionBc, 
            textureCompressionETC2: self.textureCompressionEtc2, 
            textureCompressionASTC: self.textureCompressionAstc, 
            shaderFloat16: self.shaderFloat16, 
            pipelineStatisticsQuery: self.pipelineStatisticsQuery, 
            timestampQuery: self.timestampQuery, 
            multiPlanarFormats: self.multiPlanarFormats, 
            depthClamping: self.depthClamping, 
            invalidFeature: self.invalidFeature, 
            dawnInternalUsages: self.dawnInternalUsages, 
            limits: cStruct_limits.pointee
        )
        return try body(&cStruct)
        }
    }
}

public struct Limits: CStructConvertible {
    typealias CStruct = WGPULimits

    public var maxTextureDimension1d: UInt32
    public var maxTextureDimension2d: UInt32
    public var maxTextureDimension3d: UInt32
    public var maxTextureArrayLayers: UInt32
    public var maxBindGroups: UInt32
    public var maxDynamicUniformBuffersPerPipelineLayout: UInt32
    public var maxDynamicStorageBuffersPerPipelineLayout: UInt32
    public var maxSampledTexturesPerShaderStage: UInt32
    public var maxSamplersPerShaderStage: UInt32
    public var maxStorageBuffersPerShaderStage: UInt32
    public var maxStorageTexturesPerShaderStage: UInt32
    public var maxUniformBuffersPerShaderStage: UInt32
    public var maxUniformBufferBindingSize: UInt64
    public var maxStorageBufferBindingSize: UInt64
    public var minUniformBufferOffsetAlignment: UInt32
    public var minStorageBufferOffsetAlignment: UInt32
    public var maxVertexBuffers: UInt32
    public var maxVertexAttributes: UInt32
    public var maxVertexBufferArrayStride: UInt32
    public var maxInterStageShaderComponents: UInt32
    public var maxComputeWorkgroupStorageSize: UInt32
    public var maxComputeInvocationsPerWorkgroup: UInt32
    public var maxComputeWorkgroupSizeX: UInt32
    public var maxComputeWorkgroupSizeY: UInt32
    public var maxComputeWorkgroupSizeZ: UInt32
    public var maxComputeWorkgroupsPerDimension: UInt32

    public init(maxTextureDimension1d: UInt32 = UInt32(WGPU_LIMIT_U32_UNDEFINED), maxTextureDimension2d: UInt32 = UInt32(WGPU_LIMIT_U32_UNDEFINED), maxTextureDimension3d: UInt32 = UInt32(WGPU_LIMIT_U32_UNDEFINED), maxTextureArrayLayers: UInt32 = UInt32(WGPU_LIMIT_U32_UNDEFINED), maxBindGroups: UInt32 = UInt32(WGPU_LIMIT_U32_UNDEFINED), maxDynamicUniformBuffersPerPipelineLayout: UInt32 = UInt32(WGPU_LIMIT_U32_UNDEFINED), maxDynamicStorageBuffersPerPipelineLayout: UInt32 = UInt32(WGPU_LIMIT_U32_UNDEFINED), maxSampledTexturesPerShaderStage: UInt32 = UInt32(WGPU_LIMIT_U32_UNDEFINED), maxSamplersPerShaderStage: UInt32 = UInt32(WGPU_LIMIT_U32_UNDEFINED), maxStorageBuffersPerShaderStage: UInt32 = UInt32(WGPU_LIMIT_U32_UNDEFINED), maxStorageTexturesPerShaderStage: UInt32 = UInt32(WGPU_LIMIT_U32_UNDEFINED), maxUniformBuffersPerShaderStage: UInt32 = UInt32(WGPU_LIMIT_U32_UNDEFINED), maxUniformBufferBindingSize: UInt64 = UInt64(WGPU_LIMIT_U64_UNDEFINED), maxStorageBufferBindingSize: UInt64 = UInt64(WGPU_LIMIT_U64_UNDEFINED), minUniformBufferOffsetAlignment: UInt32 = UInt32(WGPU_LIMIT_U32_UNDEFINED), minStorageBufferOffsetAlignment: UInt32 = UInt32(WGPU_LIMIT_U32_UNDEFINED), maxVertexBuffers: UInt32 = UInt32(WGPU_LIMIT_U32_UNDEFINED), maxVertexAttributes: UInt32 = UInt32(WGPU_LIMIT_U32_UNDEFINED), maxVertexBufferArrayStride: UInt32 = UInt32(WGPU_LIMIT_U32_UNDEFINED), maxInterStageShaderComponents: UInt32 = UInt32(WGPU_LIMIT_U32_UNDEFINED), maxComputeWorkgroupStorageSize: UInt32 = UInt32(WGPU_LIMIT_U32_UNDEFINED), maxComputeInvocationsPerWorkgroup: UInt32 = UInt32(WGPU_LIMIT_U32_UNDEFINED), maxComputeWorkgroupSizeX: UInt32 = UInt32(WGPU_LIMIT_U32_UNDEFINED), maxComputeWorkgroupSizeY: UInt32 = UInt32(WGPU_LIMIT_U32_UNDEFINED), maxComputeWorkgroupSizeZ: UInt32 = UInt32(WGPU_LIMIT_U32_UNDEFINED), maxComputeWorkgroupsPerDimension: UInt32 = UInt32(WGPU_LIMIT_U32_UNDEFINED)) {
        self.maxTextureDimension1d = maxTextureDimension1d
        self.maxTextureDimension2d = maxTextureDimension2d
        self.maxTextureDimension3d = maxTextureDimension3d
        self.maxTextureArrayLayers = maxTextureArrayLayers
        self.maxBindGroups = maxBindGroups
        self.maxDynamicUniformBuffersPerPipelineLayout = maxDynamicUniformBuffersPerPipelineLayout
        self.maxDynamicStorageBuffersPerPipelineLayout = maxDynamicStorageBuffersPerPipelineLayout
        self.maxSampledTexturesPerShaderStage = maxSampledTexturesPerShaderStage
        self.maxSamplersPerShaderStage = maxSamplersPerShaderStage
        self.maxStorageBuffersPerShaderStage = maxStorageBuffersPerShaderStage
        self.maxStorageTexturesPerShaderStage = maxStorageTexturesPerShaderStage
        self.maxUniformBuffersPerShaderStage = maxUniformBuffersPerShaderStage
        self.maxUniformBufferBindingSize = maxUniformBufferBindingSize
        self.maxStorageBufferBindingSize = maxStorageBufferBindingSize
        self.minUniformBufferOffsetAlignment = minUniformBufferOffsetAlignment
        self.minStorageBufferOffsetAlignment = minStorageBufferOffsetAlignment
        self.maxVertexBuffers = maxVertexBuffers
        self.maxVertexAttributes = maxVertexAttributes
        self.maxVertexBufferArrayStride = maxVertexBufferArrayStride
        self.maxInterStageShaderComponents = maxInterStageShaderComponents
        self.maxComputeWorkgroupStorageSize = maxComputeWorkgroupStorageSize
        self.maxComputeInvocationsPerWorkgroup = maxComputeInvocationsPerWorkgroup
        self.maxComputeWorkgroupSizeX = maxComputeWorkgroupSizeX
        self.maxComputeWorkgroupSizeY = maxComputeWorkgroupSizeY
        self.maxComputeWorkgroupSizeZ = maxComputeWorkgroupSizeZ
        self.maxComputeWorkgroupsPerDimension = maxComputeWorkgroupsPerDimension
    }

    init(cStruct: WGPULimits) {
        self.maxTextureDimension1d = cStruct.maxTextureDimension1D
        self.maxTextureDimension2d = cStruct.maxTextureDimension2D
        self.maxTextureDimension3d = cStruct.maxTextureDimension3D
        self.maxTextureArrayLayers = cStruct.maxTextureArrayLayers
        self.maxBindGroups = cStruct.maxBindGroups
        self.maxDynamicUniformBuffersPerPipelineLayout = cStruct.maxDynamicUniformBuffersPerPipelineLayout
        self.maxDynamicStorageBuffersPerPipelineLayout = cStruct.maxDynamicStorageBuffersPerPipelineLayout
        self.maxSampledTexturesPerShaderStage = cStruct.maxSampledTexturesPerShaderStage
        self.maxSamplersPerShaderStage = cStruct.maxSamplersPerShaderStage
        self.maxStorageBuffersPerShaderStage = cStruct.maxStorageBuffersPerShaderStage
        self.maxStorageTexturesPerShaderStage = cStruct.maxStorageTexturesPerShaderStage
        self.maxUniformBuffersPerShaderStage = cStruct.maxUniformBuffersPerShaderStage
        self.maxUniformBufferBindingSize = cStruct.maxUniformBufferBindingSize
        self.maxStorageBufferBindingSize = cStruct.maxStorageBufferBindingSize
        self.minUniformBufferOffsetAlignment = cStruct.minUniformBufferOffsetAlignment
        self.minStorageBufferOffsetAlignment = cStruct.minStorageBufferOffsetAlignment
        self.maxVertexBuffers = cStruct.maxVertexBuffers
        self.maxVertexAttributes = cStruct.maxVertexAttributes
        self.maxVertexBufferArrayStride = cStruct.maxVertexBufferArrayStride
        self.maxInterStageShaderComponents = cStruct.maxInterStageShaderComponents
        self.maxComputeWorkgroupStorageSize = cStruct.maxComputeWorkgroupStorageSize
        self.maxComputeInvocationsPerWorkgroup = cStruct.maxComputeInvocationsPerWorkgroup
        self.maxComputeWorkgroupSizeX = cStruct.maxComputeWorkgroupSizeX
        self.maxComputeWorkgroupSizeY = cStruct.maxComputeWorkgroupSizeY
        self.maxComputeWorkgroupSizeZ = cStruct.maxComputeWorkgroupSizeZ
        self.maxComputeWorkgroupsPerDimension = cStruct.maxComputeWorkgroupsPerDimension
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPULimits>) throws -> R) rethrows -> R {
        var cStruct = WGPULimits(
            maxTextureDimension1D: self.maxTextureDimension1d, 
            maxTextureDimension2D: self.maxTextureDimension2d, 
            maxTextureDimension3D: self.maxTextureDimension3d, 
            maxTextureArrayLayers: self.maxTextureArrayLayers, 
            maxBindGroups: self.maxBindGroups, 
            maxDynamicUniformBuffersPerPipelineLayout: self.maxDynamicUniformBuffersPerPipelineLayout, 
            maxDynamicStorageBuffersPerPipelineLayout: self.maxDynamicStorageBuffersPerPipelineLayout, 
            maxSampledTexturesPerShaderStage: self.maxSampledTexturesPerShaderStage, 
            maxSamplersPerShaderStage: self.maxSamplersPerShaderStage, 
            maxStorageBuffersPerShaderStage: self.maxStorageBuffersPerShaderStage, 
            maxStorageTexturesPerShaderStage: self.maxStorageTexturesPerShaderStage, 
            maxUniformBuffersPerShaderStage: self.maxUniformBuffersPerShaderStage, 
            maxUniformBufferBindingSize: self.maxUniformBufferBindingSize, 
            maxStorageBufferBindingSize: self.maxStorageBufferBindingSize, 
            minUniformBufferOffsetAlignment: self.minUniformBufferOffsetAlignment, 
            minStorageBufferOffsetAlignment: self.minStorageBufferOffsetAlignment, 
            maxVertexBuffers: self.maxVertexBuffers, 
            maxVertexAttributes: self.maxVertexAttributes, 
            maxVertexBufferArrayStride: self.maxVertexBufferArrayStride, 
            maxInterStageShaderComponents: self.maxInterStageShaderComponents, 
            maxComputeWorkgroupStorageSize: self.maxComputeWorkgroupStorageSize, 
            maxComputeInvocationsPerWorkgroup: self.maxComputeInvocationsPerWorkgroup, 
            maxComputeWorkgroupSizeX: self.maxComputeWorkgroupSizeX, 
            maxComputeWorkgroupSizeY: self.maxComputeWorkgroupSizeY, 
            maxComputeWorkgroupSizeZ: self.maxComputeWorkgroupSizeZ, 
            maxComputeWorkgroupsPerDimension: self.maxComputeWorkgroupsPerDimension
        )
        return try body(&cStruct)
    }
}

public struct RequiredLimits: CStructConvertible, Extensible {
    typealias CStruct = WGPURequiredLimits

    public var limits: Limits

    public var nextInChain: Chained?

    public init(limits: Limits = Limits()) {
        self.limits = limits
    }

    public init(limits: Limits, nextInChain: Chained?) {
        self.limits = limits
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPURequiredLimits>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        return try self.limits.withCStruct { cStruct_limits in
        var cStruct = WGPURequiredLimits(
            nextInChain: chainedCStruct, 
            limits: cStruct_limits.pointee
        )
        return try body(&cStruct)
        }
        }
    }
}

public struct SupportedLimits: CStructConvertible {
    typealias CStruct = WGPUSupportedLimits

    public var limits: Limits

    public init(limits: Limits = Limits()) {
        self.limits = limits
    }


    func withCStruct<R>(_ body: (UnsafePointer<WGPUSupportedLimits>) throws -> R) rethrows -> R {
        return try self.limits.withCStruct { cStruct_limits in
        var cStruct = WGPUSupportedLimits(
            nextInChain: nil, 
            limits: cStruct_limits.pointee
        )
        return try body(&cStruct)
        }
    }
}

public struct Extent3d: CStructConvertible {
    typealias CStruct = WGPUExtent3D

    public var width: UInt32
    public var height: UInt32
    public var depthOrArrayLayers: UInt32

    public init(width: UInt32, height: UInt32 = 1, depthOrArrayLayers: UInt32 = 1) {
        self.width = width
        self.height = height
        self.depthOrArrayLayers = depthOrArrayLayers
    }

    init(cStruct: WGPUExtent3D) {
        self.width = cStruct.width
        self.height = cStruct.height
        self.depthOrArrayLayers = cStruct.depthOrArrayLayers
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUExtent3D>) throws -> R) rethrows -> R {
        var cStruct = WGPUExtent3D(
            width: self.width, 
            height: self.height, 
            depthOrArrayLayers: self.depthOrArrayLayers
        )
        return try body(&cStruct)
    }
}

public struct ExternalTextureDescriptor: CStructConvertible, Extensible {
    typealias CStruct = WGPUExternalTextureDescriptor

    public var label: String?
    public var plane0: TextureView
    public var format: TextureFormat

    public var nextInChain: Chained?

    public init(label: String? = nil, plane0: TextureView, format: TextureFormat) {
        self.label = label
        self.plane0 = plane0
        self.format = format
    }

    public init(label: String?, plane0: TextureView, format: TextureFormat, nextInChain: Chained?) {
        self.label = label
        self.plane0 = plane0
        self.format = format
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUExternalTextureDescriptor>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        return try self.label.withOptionalCString { cString_label in
        return try self.plane0.withUnsafeHandle { handle_plane0 in
        var cStruct = WGPUExternalTextureDescriptor(
            nextInChain: chainedCStruct, 
            label: cString_label, 
            plane0: handle_plane0, 
            format: self.format.cValue
        )
        return try body(&cStruct)
        }
        }
        }
    }
}

public struct ImageCopyBuffer: CStructConvertible, Extensible {
    typealias CStruct = WGPUImageCopyBuffer

    public var layout: TextureDataLayout
    public var buffer: Buffer

    public var nextInChain: Chained?

    public init(layout: TextureDataLayout, buffer: Buffer) {
        self.layout = layout
        self.buffer = buffer
    }

    public init(layout: TextureDataLayout, buffer: Buffer, nextInChain: Chained?) {
        self.layout = layout
        self.buffer = buffer
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUImageCopyBuffer>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        return try self.layout.withCStruct { cStruct_layout in
        return try self.buffer.withUnsafeHandle { handle_buffer in
        var cStruct = WGPUImageCopyBuffer(
            nextInChain: chainedCStruct, 
            layout: cStruct_layout.pointee, 
            buffer: handle_buffer
        )
        return try body(&cStruct)
        }
        }
        }
    }
}

public struct ImageCopyTexture: CStructConvertible, Extensible {
    typealias CStruct = WGPUImageCopyTexture

    public var texture: Texture
    public var mipLevel: UInt32
    public var origin: Origin3d
    public var aspect: TextureAspect

    public var nextInChain: Chained?

    public init(texture: Texture, mipLevel: UInt32 = 0, origin: Origin3d = Origin3d(), aspect: TextureAspect = .all) {
        self.texture = texture
        self.mipLevel = mipLevel
        self.origin = origin
        self.aspect = aspect
    }

    public init(texture: Texture, mipLevel: UInt32, origin: Origin3d, aspect: TextureAspect, nextInChain: Chained?) {
        self.texture = texture
        self.mipLevel = mipLevel
        self.origin = origin
        self.aspect = aspect
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUImageCopyTexture>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        return try self.texture.withUnsafeHandle { handle_texture in
        return try self.origin.withCStruct { cStruct_origin in
        var cStruct = WGPUImageCopyTexture(
            nextInChain: chainedCStruct, 
            texture: handle_texture, 
            mipLevel: self.mipLevel, 
            origin: cStruct_origin.pointee, 
            aspect: self.aspect.cValue
        )
        return try body(&cStruct)
        }
        }
        }
    }
}

public struct InstanceDescriptor: CStructConvertible, Extensible {
    typealias CStruct = WGPUInstanceDescriptor


    public var nextInChain: Chained?

    public init() {
    }

    public init(nextInChain: Chained?) {
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

    init(cStruct: WGPUVertexAttribute) {
        self.format = .init(cValue: cStruct.format)
        self.offset = cStruct.offset
        self.shaderLocation = cStruct.shaderLocation
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
    public var stepMode: VertexStepMode
    public var attributes: [VertexAttribute]

    public init(arrayStride: UInt64, stepMode: VertexStepMode = .vertex, attributes: [VertexAttribute]) {
        self.arrayStride = arrayStride
        self.stepMode = stepMode
        self.attributes = attributes
    }

    init(cStruct: WGPUVertexBufferLayout) {
        self.arrayStride = cStruct.arrayStride
        self.stepMode = .init(cValue: cStruct.stepMode)
        self.attributes = UnsafeBufferPointer(start: cStruct.attributes, count: Int(cStruct.attributeCount)).map { .init(cStruct: $0) }
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

public struct Origin3d: CStructConvertible {
    typealias CStruct = WGPUOrigin3D

    public var x: UInt32
    public var y: UInt32
    public var z: UInt32

    public init(x: UInt32 = 0, y: UInt32 = 0, z: UInt32 = 0) {
        self.x = x
        self.y = y
        self.z = z
    }

    init(cStruct: WGPUOrigin3D) {
        self.x = cStruct.x
        self.y = cStruct.y
        self.z = cStruct.z
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

    public init(label: String? = nil, bindGroupLayouts: [BindGroupLayout]) {
        self.label = label
        self.bindGroupLayouts = bindGroupLayouts
    }

    public init(label: String?, bindGroupLayouts: [BindGroupLayout], nextInChain: Chained?) {
        self.label = label
        self.bindGroupLayouts = bindGroupLayouts
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUPipelineLayoutDescriptor>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        return try self.label.withOptionalCString { cString_label in
        return try self.bindGroupLayouts.withHandleBufferPointer { buffer_bindGroupLayouts in
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
    public var constants: [ConstantEntry]

    public var nextInChain: Chained?

    public init(module: ShaderModule, entryPoint: String, constants: [ConstantEntry] = []) {
        self.module = module
        self.entryPoint = entryPoint
        self.constants = constants
    }

    public init(module: ShaderModule, entryPoint: String, constants: [ConstantEntry], nextInChain: Chained?) {
        self.module = module
        self.entryPoint = entryPoint
        self.constants = constants
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUProgrammableStageDescriptor>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        return try self.module.withUnsafeHandle { handle_module in
        return try self.entryPoint.withCString { cString_entryPoint in
        return try self.constants.withCStructBufferPointer { buffer_constants in
        var cStruct = WGPUProgrammableStageDescriptor(
            nextInChain: chainedCStruct, 
            module: handle_module, 
            entryPoint: cString_entryPoint, 
            constantCount: .init(buffer_constants.count), 
            constants: buffer_constants.baseAddress
        )
        return try body(&cStruct)
        }
        }
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

    public init(label: String? = nil, type: QueryType, count: UInt32, pipelineStatistics: [PipelineStatisticName] = []) {
        self.label = label
        self.type = type
        self.count = count
        self.pipelineStatistics = pipelineStatistics
    }

    public init(label: String?, type: QueryType, count: UInt32, pipelineStatistics: [PipelineStatisticName], nextInChain: Chained?) {
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

public struct RenderBundleDescriptor: CStructConvertible, Extensible {
    typealias CStruct = WGPURenderBundleDescriptor

    public var label: String?

    public var nextInChain: Chained?

    public init(label: String? = nil) {
        self.label = label
    }

    public init(label: String?, nextInChain: Chained?) {
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
    public var depthReadOnly: Bool
    public var stencilReadOnly: Bool

    public var nextInChain: Chained?

    public init(label: String? = nil, colorFormats: [TextureFormat], depthStencilFormat: TextureFormat = .undefined, sampleCount: UInt32 = 1, depthReadOnly: Bool = false, stencilReadOnly: Bool = false) {
        self.label = label
        self.colorFormats = colorFormats
        self.depthStencilFormat = depthStencilFormat
        self.sampleCount = sampleCount
        self.depthReadOnly = depthReadOnly
        self.stencilReadOnly = stencilReadOnly
    }

    public init(label: String?, colorFormats: [TextureFormat], depthStencilFormat: TextureFormat, sampleCount: UInt32, depthReadOnly: Bool, stencilReadOnly: Bool, nextInChain: Chained?) {
        self.label = label
        self.colorFormats = colorFormats
        self.depthStencilFormat = depthStencilFormat
        self.sampleCount = sampleCount
        self.depthReadOnly = depthReadOnly
        self.stencilReadOnly = stencilReadOnly
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
            sampleCount: self.sampleCount, 
            depthReadOnly: self.depthReadOnly, 
            stencilReadOnly: self.stencilReadOnly
        )
        return try body(&cStruct)
        }
        }
        }
    }
}

public struct RenderPassColorAttachment: CStructConvertible {
    typealias CStruct = WGPURenderPassColorAttachment

    public var view: TextureView
    public var resolveTarget: TextureView?
    public var loadOp: LoadOp
    public var storeOp: StoreOp
    public var clearColor: Color

    public init(view: TextureView, resolveTarget: TextureView? = nil, loadOp: LoadOp, storeOp: StoreOp, clearColor: Color) {
        self.view = view
        self.resolveTarget = resolveTarget
        self.loadOp = loadOp
        self.storeOp = storeOp
        self.clearColor = clearColor
    }

    init(cStruct: WGPURenderPassColorAttachment) {
        self.view = .init(handle: cStruct.view)
        self.resolveTarget = cStruct.resolveTarget != nil ? .init(handle: cStruct.resolveTarget) : nil
        self.loadOp = .init(cValue: cStruct.loadOp)
        self.storeOp = .init(cValue: cStruct.storeOp)
        self.clearColor = .init(cStruct: cStruct.clearColor)
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPURenderPassColorAttachment>) throws -> R) rethrows -> R {
        return try self.view.withUnsafeHandle { handle_view in
        return try self.resolveTarget.withOptionalHandle { handle_resolveTarget in
        return try self.clearColor.withCStruct { cStruct_clearColor in
        var cStruct = WGPURenderPassColorAttachment(
            view: handle_view, 
            resolveTarget: handle_resolveTarget, 
            loadOp: self.loadOp.cValue, 
            storeOp: self.storeOp.cValue, 
            clearColor: cStruct_clearColor.pointee
        )
        return try body(&cStruct)
        }
        }
        }
    }
}

public struct RenderPassDepthStencilAttachment: CStructConvertible {
    typealias CStruct = WGPURenderPassDepthStencilAttachment

    public var view: TextureView
    public var depthLoadOp: LoadOp
    public var depthStoreOp: StoreOp
    public var clearDepth: Float
    public var depthReadOnly: Bool
    public var stencilLoadOp: LoadOp
    public var stencilStoreOp: StoreOp
    public var clearStencil: UInt32
    public var stencilReadOnly: Bool

    public init(view: TextureView, depthLoadOp: LoadOp, depthStoreOp: StoreOp, clearDepth: Float, depthReadOnly: Bool = false, stencilLoadOp: LoadOp, stencilStoreOp: StoreOp, clearStencil: UInt32 = 0, stencilReadOnly: Bool = false) {
        self.view = view
        self.depthLoadOp = depthLoadOp
        self.depthStoreOp = depthStoreOp
        self.clearDepth = clearDepth
        self.depthReadOnly = depthReadOnly
        self.stencilLoadOp = stencilLoadOp
        self.stencilStoreOp = stencilStoreOp
        self.clearStencil = clearStencil
        self.stencilReadOnly = stencilReadOnly
    }

    init(cStruct: WGPURenderPassDepthStencilAttachment) {
        self.view = .init(handle: cStruct.view)
        self.depthLoadOp = .init(cValue: cStruct.depthLoadOp)
        self.depthStoreOp = .init(cValue: cStruct.depthStoreOp)
        self.clearDepth = cStruct.clearDepth
        self.depthReadOnly = cStruct.depthReadOnly
        self.stencilLoadOp = .init(cValue: cStruct.stencilLoadOp)
        self.stencilStoreOp = .init(cValue: cStruct.stencilStoreOp)
        self.clearStencil = cStruct.clearStencil
        self.stencilReadOnly = cStruct.stencilReadOnly
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPURenderPassDepthStencilAttachment>) throws -> R) rethrows -> R {
        return try self.view.withUnsafeHandle { handle_view in
        var cStruct = WGPURenderPassDepthStencilAttachment(
            view: handle_view, 
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
}

public struct RenderPassDescriptor: CStructConvertible, Extensible {
    typealias CStruct = WGPURenderPassDescriptor

    public var label: String?
    public var colorAttachments: [RenderPassColorAttachment]
    public var depthStencilAttachment: RenderPassDepthStencilAttachment?
    public var occlusionQuerySet: QuerySet?

    public var nextInChain: Chained?

    public init(label: String? = nil, colorAttachments: [RenderPassColorAttachment], depthStencilAttachment: RenderPassDepthStencilAttachment? = nil, occlusionQuerySet: QuerySet? = nil) {
        self.label = label
        self.colorAttachments = colorAttachments
        self.depthStencilAttachment = depthStencilAttachment
        self.occlusionQuerySet = occlusionQuerySet
    }

    public init(label: String?, colorAttachments: [RenderPassColorAttachment], depthStencilAttachment: RenderPassDepthStencilAttachment?, occlusionQuerySet: QuerySet?, nextInChain: Chained?) {
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
        return try self.occlusionQuerySet.withOptionalHandle { handle_occlusionQuerySet in
        var cStruct = WGPURenderPassDescriptor(
            nextInChain: chainedCStruct, 
            label: cString_label, 
            colorAttachmentCount: .init(buffer_colorAttachments.count), 
            colorAttachments: buffer_colorAttachments.baseAddress, 
            depthStencilAttachment: cStruct_depthStencilAttachment, 
            occlusionQuerySet: handle_occlusionQuerySet
        )
        return try body(&cStruct)
        }
        }
        }
        }
        }
    }
}

public struct VertexState: CStructConvertible, Extensible {
    typealias CStruct = WGPUVertexState

    public var module: ShaderModule
    public var entryPoint: String
    public var constants: [ConstantEntry]
    public var buffers: [VertexBufferLayout]

    public var nextInChain: Chained?

    public init(module: ShaderModule, entryPoint: String, constants: [ConstantEntry] = [], buffers: [VertexBufferLayout] = []) {
        self.module = module
        self.entryPoint = entryPoint
        self.constants = constants
        self.buffers = buffers
    }

    public init(module: ShaderModule, entryPoint: String, constants: [ConstantEntry], buffers: [VertexBufferLayout], nextInChain: Chained?) {
        self.module = module
        self.entryPoint = entryPoint
        self.constants = constants
        self.buffers = buffers
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUVertexState>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        return try self.module.withUnsafeHandle { handle_module in
        return try self.entryPoint.withCString { cString_entryPoint in
        return try self.constants.withCStructBufferPointer { buffer_constants in
        return try self.buffers.withCStructBufferPointer { buffer_buffers in
        var cStruct = WGPUVertexState(
            nextInChain: chainedCStruct, 
            module: handle_module, 
            entryPoint: cString_entryPoint, 
            constantCount: .init(buffer_constants.count), 
            constants: buffer_constants.baseAddress, 
            bufferCount: .init(buffer_buffers.count), 
            buffers: buffer_buffers.baseAddress
        )
        return try body(&cStruct)
        }
        }
        }
        }
        }
    }
}

public struct PrimitiveState: CStructConvertible, Extensible {
    typealias CStruct = WGPUPrimitiveState

    public var topology: PrimitiveTopology
    public var stripIndexFormat: IndexFormat
    public var frontFace: FrontFace
    public var cullMode: CullMode

    public var nextInChain: Chained?

    public init(topology: PrimitiveTopology = .triangleList, stripIndexFormat: IndexFormat = .undefined, frontFace: FrontFace = .ccw, cullMode: CullMode = .none) {
        self.topology = topology
        self.stripIndexFormat = stripIndexFormat
        self.frontFace = frontFace
        self.cullMode = cullMode
    }

    public init(topology: PrimitiveTopology, stripIndexFormat: IndexFormat, frontFace: FrontFace, cullMode: CullMode, nextInChain: Chained?) {
        self.topology = topology
        self.stripIndexFormat = stripIndexFormat
        self.frontFace = frontFace
        self.cullMode = cullMode
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUPrimitiveState>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        var cStruct = WGPUPrimitiveState(
            nextInChain: chainedCStruct, 
            topology: self.topology.cValue, 
            stripIndexFormat: self.stripIndexFormat.cValue, 
            frontFace: self.frontFace.cValue, 
            cullMode: self.cullMode.cValue
        )
        return try body(&cStruct)
        }
    }
}

public struct PrimitiveDepthClampingState: CStructConvertible, Chained {
    typealias CStruct = WGPUPrimitiveDepthClampingState

    public var clampDepth: Bool

    public var nextInChain: Chained?

    public init(clampDepth: Bool = false) {
        self.clampDepth = clampDepth
    }

    public init(clampDepth: Bool, nextInChain: Chained?) {
        self.clampDepth = clampDepth
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUPrimitiveDepthClampingState>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        var cStruct = WGPUPrimitiveDepthClampingState(
            chain: WGPUChainedStruct(next: chainedCStruct, sType: WGPUSType_PrimitiveDepthClampingState), 
            clampDepth: self.clampDepth
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

public struct DepthStencilState: CStructConvertible, Extensible {
    typealias CStruct = WGPUDepthStencilState

    public var format: TextureFormat
    public var depthWriteEnabled: Bool
    public var depthCompare: CompareFunction
    public var stencilFront: StencilFaceState
    public var stencilBack: StencilFaceState
    public var stencilReadMask: UInt32
    public var stencilWriteMask: UInt32
    public var depthBias: Int32
    public var depthBiasSlopeScale: Float
    public var depthBiasClamp: Float

    public var nextInChain: Chained?

    public init(format: TextureFormat, depthWriteEnabled: Bool = false, depthCompare: CompareFunction = .always, stencilFront: StencilFaceState = StencilFaceState(), stencilBack: StencilFaceState = StencilFaceState(), stencilReadMask: UInt32 = 0xFFFFFFFF, stencilWriteMask: UInt32 = 0xFFFFFFFF, depthBias: Int32 = 0, depthBiasSlopeScale: Float = 0.0, depthBiasClamp: Float = 0.0) {
        self.format = format
        self.depthWriteEnabled = depthWriteEnabled
        self.depthCompare = depthCompare
        self.stencilFront = stencilFront
        self.stencilBack = stencilBack
        self.stencilReadMask = stencilReadMask
        self.stencilWriteMask = stencilWriteMask
        self.depthBias = depthBias
        self.depthBiasSlopeScale = depthBiasSlopeScale
        self.depthBiasClamp = depthBiasClamp
    }

    public init(format: TextureFormat, depthWriteEnabled: Bool, depthCompare: CompareFunction, stencilFront: StencilFaceState, stencilBack: StencilFaceState, stencilReadMask: UInt32, stencilWriteMask: UInt32, depthBias: Int32, depthBiasSlopeScale: Float, depthBiasClamp: Float, nextInChain: Chained?) {
        self.format = format
        self.depthWriteEnabled = depthWriteEnabled
        self.depthCompare = depthCompare
        self.stencilFront = stencilFront
        self.stencilBack = stencilBack
        self.stencilReadMask = stencilReadMask
        self.stencilWriteMask = stencilWriteMask
        self.depthBias = depthBias
        self.depthBiasSlopeScale = depthBiasSlopeScale
        self.depthBiasClamp = depthBiasClamp
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUDepthStencilState>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        return try self.stencilFront.withCStruct { cStruct_stencilFront in
        return try self.stencilBack.withCStruct { cStruct_stencilBack in
        var cStruct = WGPUDepthStencilState(
            nextInChain: chainedCStruct, 
            format: self.format.cValue, 
            depthWriteEnabled: self.depthWriteEnabled, 
            depthCompare: self.depthCompare.cValue, 
            stencilFront: cStruct_stencilFront.pointee, 
            stencilBack: cStruct_stencilBack.pointee, 
            stencilReadMask: self.stencilReadMask, 
            stencilWriteMask: self.stencilWriteMask, 
            depthBias: self.depthBias, 
            depthBiasSlopeScale: self.depthBiasSlopeScale, 
            depthBiasClamp: self.depthBiasClamp
        )
        return try body(&cStruct)
        }
        }
        }
    }
}

public struct MultisampleState: CStructConvertible, Extensible {
    typealias CStruct = WGPUMultisampleState

    public var count: UInt32
    public var mask: UInt32
    public var alphaToCoverageEnabled: Bool

    public var nextInChain: Chained?

    public init(count: UInt32 = 1, mask: UInt32 = 0xFFFFFFFF, alphaToCoverageEnabled: Bool = false) {
        self.count = count
        self.mask = mask
        self.alphaToCoverageEnabled = alphaToCoverageEnabled
    }

    public init(count: UInt32, mask: UInt32, alphaToCoverageEnabled: Bool, nextInChain: Chained?) {
        self.count = count
        self.mask = mask
        self.alphaToCoverageEnabled = alphaToCoverageEnabled
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUMultisampleState>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        var cStruct = WGPUMultisampleState(
            nextInChain: chainedCStruct, 
            count: self.count, 
            mask: self.mask, 
            alphaToCoverageEnabled: self.alphaToCoverageEnabled
        )
        return try body(&cStruct)
        }
    }
}

public struct FragmentState: CStructConvertible, Extensible {
    typealias CStruct = WGPUFragmentState

    public var module: ShaderModule
    public var entryPoint: String
    public var constants: [ConstantEntry]
    public var targets: [ColorTargetState]

    public var nextInChain: Chained?

    public init(module: ShaderModule, entryPoint: String, constants: [ConstantEntry] = [], targets: [ColorTargetState]) {
        self.module = module
        self.entryPoint = entryPoint
        self.constants = constants
        self.targets = targets
    }

    public init(module: ShaderModule, entryPoint: String, constants: [ConstantEntry], targets: [ColorTargetState], nextInChain: Chained?) {
        self.module = module
        self.entryPoint = entryPoint
        self.constants = constants
        self.targets = targets
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUFragmentState>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        return try self.module.withUnsafeHandle { handle_module in
        return try self.entryPoint.withCString { cString_entryPoint in
        return try self.constants.withCStructBufferPointer { buffer_constants in
        return try self.targets.withCStructBufferPointer { buffer_targets in
        var cStruct = WGPUFragmentState(
            nextInChain: chainedCStruct, 
            module: handle_module, 
            entryPoint: cString_entryPoint, 
            constantCount: .init(buffer_constants.count), 
            constants: buffer_constants.baseAddress, 
            targetCount: .init(buffer_targets.count), 
            targets: buffer_targets.baseAddress
        )
        return try body(&cStruct)
        }
        }
        }
        }
        }
    }
}

public struct ColorTargetState: CStructConvertible, Extensible {
    typealias CStruct = WGPUColorTargetState

    public var format: TextureFormat
    public var blend: BlendState?
    public var writeMask: ColorWriteMask

    public var nextInChain: Chained?

    public init(format: TextureFormat, blend: BlendState? = nil, writeMask: ColorWriteMask = .all) {
        self.format = format
        self.blend = blend
        self.writeMask = writeMask
    }

    public init(format: TextureFormat, blend: BlendState?, writeMask: ColorWriteMask, nextInChain: Chained?) {
        self.format = format
        self.blend = blend
        self.writeMask = writeMask
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUColorTargetState>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        return try self.blend.withOptionalCStruct { cStruct_blend in
        var cStruct = WGPUColorTargetState(
            nextInChain: chainedCStruct, 
            format: self.format.cValue, 
            blend: cStruct_blend, 
            writeMask: self.writeMask.rawValue
        )
        return try body(&cStruct)
        }
        }
    }
}

public struct BlendState: CStructConvertible {
    typealias CStruct = WGPUBlendState

    public var color: BlendComponent
    public var alpha: BlendComponent

    public init(color: BlendComponent = BlendComponent(), alpha: BlendComponent = BlendComponent()) {
        self.color = color
        self.alpha = alpha
    }

    init(cStruct: WGPUBlendState) {
        self.color = .init(cStruct: cStruct.color)
        self.alpha = .init(cStruct: cStruct.alpha)
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUBlendState>) throws -> R) rethrows -> R {
        return try self.color.withCStruct { cStruct_color in
        return try self.alpha.withCStruct { cStruct_alpha in
        var cStruct = WGPUBlendState(
            color: cStruct_color.pointee, 
            alpha: cStruct_alpha.pointee
        )
        return try body(&cStruct)
        }
        }
    }
}

public struct RenderPipelineDescriptor: CStructConvertible, Extensible {
    typealias CStruct = WGPURenderPipelineDescriptor

    public var label: String?
    public var layout: PipelineLayout?
    public var vertex: VertexState
    public var primitive: PrimitiveState
    public var depthStencil: DepthStencilState?
    public var multisample: MultisampleState
    public var fragment: FragmentState?

    public var nextInChain: Chained?

    public init(label: String? = nil, layout: PipelineLayout? = nil, vertex: VertexState, primitive: PrimitiveState = PrimitiveState(), depthStencil: DepthStencilState? = nil, multisample: MultisampleState = MultisampleState(), fragment: FragmentState? = nil) {
        self.label = label
        self.layout = layout
        self.vertex = vertex
        self.primitive = primitive
        self.depthStencil = depthStencil
        self.multisample = multisample
        self.fragment = fragment
    }

    public init(label: String?, layout: PipelineLayout?, vertex: VertexState, primitive: PrimitiveState, depthStencil: DepthStencilState?, multisample: MultisampleState, fragment: FragmentState?, nextInChain: Chained?) {
        self.label = label
        self.layout = layout
        self.vertex = vertex
        self.primitive = primitive
        self.depthStencil = depthStencil
        self.multisample = multisample
        self.fragment = fragment
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPURenderPipelineDescriptor>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        return try self.label.withOptionalCString { cString_label in
        return try self.layout.withOptionalHandle { handle_layout in
        return try self.vertex.withCStruct { cStruct_vertex in
        return try self.primitive.withCStruct { cStruct_primitive in
        return try self.depthStencil.withOptionalCStruct { cStruct_depthStencil in
        return try self.multisample.withCStruct { cStruct_multisample in
        return try self.fragment.withOptionalCStruct { cStruct_fragment in
        var cStruct = WGPURenderPipelineDescriptor(
            nextInChain: chainedCStruct, 
            label: cString_label, 
            layout: handle_layout, 
            vertex: cStruct_vertex.pointee, 
            primitive: cStruct_primitive.pointee, 
            depthStencil: cStruct_depthStencil, 
            multisample: cStruct_multisample.pointee, 
            fragment: cStruct_fragment
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

    public init(label: String? = nil, addressModeU: AddressMode = .clampToEdge, addressModeV: AddressMode = .clampToEdge, addressModeW: AddressMode = .clampToEdge, magFilter: FilterMode = .nearest, minFilter: FilterMode = .nearest, mipmapFilter: FilterMode = .nearest, lodMinClamp: Float = 0.0, lodMaxClamp: Float = 1000.0, compare: CompareFunction = .undefined, maxAnisotropy: UInt16 = 1) {
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
    }

    public init(label: String?, addressModeU: AddressMode, addressModeV: AddressMode, addressModeW: AddressMode, magFilter: FilterMode, minFilter: FilterMode, mipmapFilter: FilterMode, lodMinClamp: Float, lodMaxClamp: Float, compare: CompareFunction, maxAnisotropy: UInt16, nextInChain: Chained?) {
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

public struct ShaderModuleDescriptor: CStructConvertible, Extensible {
    typealias CStruct = WGPUShaderModuleDescriptor

    public var label: String?

    public var nextInChain: Chained?

    public init(label: String? = nil) {
        self.label = label
    }

    public init(label: String?, nextInChain: Chained?) {
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

    public init(code: [UInt32]) {
        self.code = code
    }

    public init(code: [UInt32], nextInChain: Chained?) {
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

    public init(source: String) {
        self.source = source
    }

    public init(source: String, nextInChain: Chained?) {
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

public struct StencilFaceState: CStructConvertible {
    typealias CStruct = WGPUStencilFaceState

    public var compare: CompareFunction
    public var failOp: StencilOperation
    public var depthFailOp: StencilOperation
    public var passOp: StencilOperation

    public init(compare: CompareFunction = .always, failOp: StencilOperation = .keep, depthFailOp: StencilOperation = .keep, passOp: StencilOperation = .keep) {
        self.compare = compare
        self.failOp = failOp
        self.depthFailOp = depthFailOp
        self.passOp = passOp
    }

    init(cStruct: WGPUStencilFaceState) {
        self.compare = .init(cValue: cStruct.compare)
        self.failOp = .init(cValue: cStruct.failOp)
        self.depthFailOp = .init(cValue: cStruct.depthFailOp)
        self.passOp = .init(cValue: cStruct.passOp)
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUStencilFaceState>) throws -> R) rethrows -> R {
        var cStruct = WGPUStencilFaceState(
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

    public init(label: String? = nil) {
        self.label = label
    }

    public init(label: String?, nextInChain: Chained?) {
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

    public init(selector: String) {
        self.selector = selector
    }

    public init(selector: String, nextInChain: Chained?) {
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

    public init(layer: UnsafeMutableRawPointer!) {
        self.layer = layer
    }

    public init(layer: UnsafeMutableRawPointer!, nextInChain: Chained?) {
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

    public init(hinstance: UnsafeMutableRawPointer!, hwnd: UnsafeMutableRawPointer!) {
        self.hinstance = hinstance
        self.hwnd = hwnd
    }

    public init(hinstance: UnsafeMutableRawPointer!, hwnd: UnsafeMutableRawPointer!, nextInChain: Chained?) {
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

    public init(display: UnsafeMutableRawPointer!, window: UInt32) {
        self.display = display
        self.window = window
    }

    public init(display: UnsafeMutableRawPointer!, window: UInt32, nextInChain: Chained?) {
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

public struct SurfaceDescriptorFromWindowsCoreWindow: CStructConvertible, Chained {
    typealias CStruct = WGPUSurfaceDescriptorFromWindowsCoreWindow

    public var coreWindow: UnsafeMutableRawPointer!

    public var nextInChain: Chained?

    public init(coreWindow: UnsafeMutableRawPointer!) {
        self.coreWindow = coreWindow
    }

    public init(coreWindow: UnsafeMutableRawPointer!, nextInChain: Chained?) {
        self.coreWindow = coreWindow
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUSurfaceDescriptorFromWindowsCoreWindow>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        var cStruct = WGPUSurfaceDescriptorFromWindowsCoreWindow(
            chain: WGPUChainedStruct(next: chainedCStruct, sType: WGPUSType_SurfaceDescriptorFromWindowsCoreWindow), 
            coreWindow: self.coreWindow
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

public struct SurfaceDescriptorFromWindowsSwapChainPanel: CStructConvertible, Chained {
    typealias CStruct = WGPUSurfaceDescriptorFromWindowsSwapChainPanel

    public var swapChainPanel: UnsafeMutableRawPointer!

    public var nextInChain: Chained?

    public init(swapChainPanel: UnsafeMutableRawPointer!) {
        self.swapChainPanel = swapChainPanel
    }

    public init(swapChainPanel: UnsafeMutableRawPointer!, nextInChain: Chained?) {
        self.swapChainPanel = swapChainPanel
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUSurfaceDescriptorFromWindowsSwapChainPanel>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        var cStruct = WGPUSurfaceDescriptorFromWindowsSwapChainPanel(
            chain: WGPUChainedStruct(next: chainedCStruct, sType: WGPUSType_SurfaceDescriptorFromWindowsSwapChainPanel), 
            swapChainPanel: self.swapChainPanel
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

    public init(label: String? = nil, usage: TextureUsage, format: TextureFormat, width: UInt32, height: UInt32, presentMode: PresentMode, implementation: UInt64) {
        self.label = label
        self.usage = usage
        self.format = format
        self.width = width
        self.height = height
        self.presentMode = presentMode
        self.implementation = implementation
    }

    public init(label: String?, usage: TextureUsage, format: TextureFormat, width: UInt32, height: UInt32, presentMode: PresentMode, implementation: UInt64, nextInChain: Chained?) {
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

public struct TextureDataLayout: CStructConvertible, Extensible {
    typealias CStruct = WGPUTextureDataLayout

    public var offset: UInt64
    public var bytesPerRow: UInt32
    public var rowsPerImage: UInt32

    public var nextInChain: Chained?

    public init(offset: UInt64, bytesPerRow: UInt32 = UInt32(WGPU_COPY_STRIDE_UNDEFINED), rowsPerImage: UInt32 = UInt32(WGPU_COPY_STRIDE_UNDEFINED)) {
        self.offset = offset
        self.bytesPerRow = bytesPerRow
        self.rowsPerImage = rowsPerImage
    }

    public init(offset: UInt64, bytesPerRow: UInt32, rowsPerImage: UInt32, nextInChain: Chained?) {
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

    public init(label: String? = nil, usage: TextureUsage, dimension: TextureDimension = .type2d, size: Extent3d, format: TextureFormat, mipLevelCount: UInt32 = 1, sampleCount: UInt32 = 1) {
        self.label = label
        self.usage = usage
        self.dimension = dimension
        self.size = size
        self.format = format
        self.mipLevelCount = mipLevelCount
        self.sampleCount = sampleCount
    }

    public init(label: String?, usage: TextureUsage, dimension: TextureDimension, size: Extent3d, format: TextureFormat, mipLevelCount: UInt32, sampleCount: UInt32, nextInChain: Chained?) {
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

    public init(label: String? = nil, format: TextureFormat = .undefined, dimension: TextureViewDimension = .typeUndefined, baseMipLevel: UInt32 = 0, mipLevelCount: UInt32 = UInt32(WGPU_MIP_LEVEL_COUNT_UNDEFINED), baseArrayLayer: UInt32 = 0, arrayLayerCount: UInt32 = UInt32(WGPU_ARRAY_LAYER_COUNT_UNDEFINED), aspect: TextureAspect = .all) {
        self.label = label
        self.format = format
        self.dimension = dimension
        self.baseMipLevel = baseMipLevel
        self.mipLevelCount = mipLevelCount
        self.baseArrayLayer = baseArrayLayer
        self.arrayLayerCount = arrayLayerCount
        self.aspect = aspect
    }

    public init(label: String?, format: TextureFormat, dimension: TextureViewDimension, baseMipLevel: UInt32, mipLevelCount: UInt32, baseArrayLayer: UInt32, arrayLayerCount: UInt32, aspect: TextureAspect, nextInChain: Chained?) {
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

public struct DawnTextureInternalUsageDescriptor: CStructConvertible, Chained {
    typealias CStruct = WGPUDawnTextureInternalUsageDescriptor

    public var internalUsage: TextureUsage

    public var nextInChain: Chained?

    public init(internalUsage: TextureUsage = .none) {
        self.internalUsage = internalUsage
    }

    public init(internalUsage: TextureUsage, nextInChain: Chained?) {
        self.internalUsage = internalUsage
        self.nextInChain = nextInChain
    }

    func withCStruct<R>(_ body: (UnsafePointer<WGPUDawnTextureInternalUsageDescriptor>) throws -> R) rethrows -> R {
        return try self.nextInChain.withOptionalChainedCStruct { chainedCStruct in
        var cStruct = WGPUDawnTextureInternalUsageDescriptor(
            chain: WGPUChainedStruct(next: chainedCStruct, sType: WGPUSType_DawnTextureInternalUsageDescriptor), 
            internalUsage: self.internalUsage.rawValue
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

