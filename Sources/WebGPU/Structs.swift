import CWebGPU

public struct AdapterProperties {
    public var deviceId: UInt32
    public var vendorId: UInt32
    public var name: UnsafePointer<CChar>!
    public var driverDescription: UnsafePointer<CChar>!
    public var adapterType: WGPUAdapterType
    public var backendType: WGPUBackendType
}

public struct BindGroupEntry {
    public var binding: UInt32
    public var buffer: WGPUBuffer
    public var offset: UInt64
    public var size: UInt64
    public var sampler: WGPUSampler
    public var textureView: WGPUTextureView
}

public struct BindGroupDescriptor {
    public var label: UnsafePointer<CChar>!
    public var layout: WGPUBindGroupLayout
    public var entryCount: UInt32
    public var entries: UnsafePointer<WGPUBindGroupEntry>!
}

public struct BufferBindingLayout {
    public var type: WGPUBufferBindingType
    public var hasDynamicOffset: Bool
    public var minBindingSize: UInt64
}

public struct SamplerBindingLayout {
    public var type: WGPUSamplerBindingType
}

public struct TextureBindingLayout {
    public var sampleType: WGPUTextureSampleType
    public var viewDimension: WGPUTextureViewDimension
    public var multisampled: Bool
}

public struct StorageTextureBindingLayout {
    public var access: WGPUStorageTextureAccess
    public var format: WGPUTextureFormat
    public var viewDimension: WGPUTextureViewDimension
}

public struct BindGroupLayoutEntry {
    public var binding: UInt32
    public var visibility: WGPUShaderStage
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
}

public struct BindGroupLayoutDescriptor {
    public var label: UnsafePointer<CChar>!
    public var entryCount: UInt32
    public var entries: UnsafePointer<WGPUBindGroupLayoutEntry>!
}

public struct BlendDescriptor {
    public var operation: WGPUBlendOperation
    public var srcFactor: WGPUBlendFactor
    public var dstFactor: WGPUBlendFactor
}

public struct ColorStateDescriptor {
    public var format: WGPUTextureFormat
    public var alphaBlend: WGPUBlendDescriptor
    public var colorBlend: WGPUBlendDescriptor
    public var writeMask: WGPUColorWriteMask
}

public struct BufferCopyView {
    public var layout: WGPUTextureDataLayout
    public var buffer: WGPUBuffer
}

public struct BufferDescriptor {
    public var label: UnsafePointer<CChar>!
    public var usage: WGPUBufferUsage
    public var size: UInt64
    public var mappedAtCreation: Bool
}

public struct Color {
    public var r: Double
    public var g: Double
    public var b: Double
    public var a: Double
}

public struct CommandBufferDescriptor {
    public var label: UnsafePointer<CChar>!
}

public struct CommandEncoderDescriptor {
    public var label: UnsafePointer<CChar>!
}

public struct ComputePassDescriptor {
    public var label: UnsafePointer<CChar>!
}

public struct ComputePipelineDescriptor {
    public var label: UnsafePointer<CChar>!
    public var layout: WGPUPipelineLayout
    public var computeStage: WGPUProgrammableStageDescriptor
}

public struct CopyTextureForBrowserOptions {
    public var flipy: Bool
}

public struct DeviceProperties {
    public var textureCompressionBc: Bool
    public var shaderFloat16: Bool
    public var pipelineStatisticsQuery: Bool
    public var timestampQuery: Bool
    public var multiPlanarFormats: Bool
}

public struct DepthStencilStateDescriptor {
    public var format: WGPUTextureFormat
    public var depthWriteEnabled: Bool
    public var depthCompare: WGPUCompareFunction
    public var stencilFront: WGPUStencilStateFaceDescriptor
    public var stencilBack: WGPUStencilStateFaceDescriptor
    public var stencilReadMask: UInt32
    public var stencilWriteMask: UInt32
}

public struct Extent3d {
    public var width: UInt32
    public var height: UInt32
    public var depth: UInt32
}

public struct FenceDescriptor {
    public var label: UnsafePointer<CChar>!
    public var initialValue: UInt64
}

public struct InstanceDescriptor {
}

public struct VertexAttribute {
    public var format: WGPUVertexFormat
    public var offset: UInt64
    public var shaderLocation: UInt32
}

public struct VertexBufferLayout {
    public var arrayStride: UInt64
    public var stepMode: WGPUInputStepMode
    public var attributeCount: UInt32
    public var attributes: UnsafePointer<WGPUVertexAttribute>!
}

public struct VertexStateDescriptor {
    public var indexFormat: WGPUIndexFormat
    public var vertexBufferCount: UInt32
    public var vertexBuffers: UnsafePointer<WGPUVertexBufferLayout>!
}

public struct Origin3d {
    public var x: UInt32
    public var y: UInt32
    public var z: UInt32
}

public struct PipelineLayoutDescriptor {
    public var label: UnsafePointer<CChar>!
    public var bindGroupLayoutCount: UInt32
    public var bindGroupLayouts: UnsafePointer<WGPUBindGroupLayout>!
}

public struct ProgrammableStageDescriptor {
    public var module: WGPUShaderModule
    public var entryPoint: UnsafePointer<CChar>!
}

public struct QuerySetDescriptor {
    public var label: UnsafePointer<CChar>!
    public var type: WGPUQueryType
    public var count: UInt32
    public var pipelineStatistics: UnsafePointer<WGPUPipelineStatisticName>!
    public var pipelineStatisticsCount: UInt32
}

public struct RasterizationStateDescriptor {
    public var frontFace: WGPUFrontFace
    public var cullMode: WGPUCullMode
    public var depthBias: Int32
    public var depthBiasSlopeScale: Float
    public var depthBiasClamp: Float
}

public struct RenderBundleDescriptor {
    public var label: UnsafePointer<CChar>!
}

public struct RenderBundleEncoderDescriptor {
    public var label: UnsafePointer<CChar>!
    public var colorFormatsCount: UInt32
    public var colorFormats: UnsafePointer<WGPUTextureFormat>!
    public var depthStencilFormat: WGPUTextureFormat
    public var sampleCount: UInt32
}

public struct RenderPassColorAttachmentDescriptor {
    public var attachment: WGPUTextureView
    public var resolveTarget: WGPUTextureView
    public var loadOp: WGPULoadOp
    public var storeOp: WGPUStoreOp
    public var clearColor: WGPUColor
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
}

public struct RenderPassDescriptor {
    public var label: UnsafePointer<CChar>!
    public var colorAttachmentCount: UInt32
    public var colorAttachments: UnsafePointer<WGPURenderPassColorAttachmentDescriptor>!
    public var depthStencilAttachment: UnsafePointer<WGPURenderPassDepthStencilAttachmentDescriptor>!
    public var occlusionQuerySet: WGPUQuerySet
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
}

public struct RenderPipelineDescriptorDummyExtension {
    public var dummyStage: WGPUProgrammableStageDescriptor
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
}

public struct SamplerDescriptorDummyAnisotropicFiltering {
    public var maxAnisotropy: Float
}

public struct ShaderModuleDescriptor {
    public var label: UnsafePointer<CChar>!
}

public struct ShaderModuleSpirvDescriptor {
    public var codeSize: UInt32
    public var code: UnsafePointer<UInt32>!
}

public struct ShaderModuleWgslDescriptor {
    public var source: UnsafePointer<CChar>!
}

public struct StencilStateFaceDescriptor {
    public var compare: WGPUCompareFunction
    public var failOp: WGPUStencilOperation
    public var depthFailOp: WGPUStencilOperation
    public var passOp: WGPUStencilOperation
}

public struct SurfaceDescriptor {
    public var label: UnsafePointer<CChar>!
}

public struct SurfaceDescriptorFromCanvasHtmlSelector {
    public var selector: UnsafePointer<CChar>!
}

public struct SurfaceDescriptorFromMetalLayer {
    public var layer: UnsafeMutableRawPointer!
}

public struct SurfaceDescriptorFromWindowsHwnd {
    public var hinstance: UnsafeMutableRawPointer!
    public var hwnd: UnsafeMutableRawPointer!
}

public struct SurfaceDescriptorFromXlib {
    public var display: UnsafeMutableRawPointer!
    public var window: UInt32
}

public struct SwapChainDescriptor {
    public var label: UnsafePointer<CChar>!
    public var usage: WGPUTextureUsage
    public var format: WGPUTextureFormat
    public var width: UInt32
    public var height: UInt32
    public var presentMode: WGPUPresentMode
    public var implementation: UInt64
}

public struct TextureCopyView {
    public var texture: WGPUTexture
    public var mipLevel: UInt32
    public var origin: WGPUOrigin3D
    public var aspect: WGPUTextureAspect
}

public struct TextureDataLayout {
    public var offset: UInt64
    public var bytesPerRow: UInt32
    public var rowsPerImage: UInt32
}

public struct TextureDescriptor {
    public var label: UnsafePointer<CChar>!
    public var usage: WGPUTextureUsage
    public var dimension: WGPUTextureDimension
    public var size: WGPUExtent3D
    public var format: WGPUTextureFormat
    public var mipLevelCount: UInt32
    public var sampleCount: UInt32
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
}

