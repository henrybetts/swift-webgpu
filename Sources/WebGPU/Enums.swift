import CWebGPU

public enum AdapterType: UInt32 {
    case discreteGpu = 0
    case integratedGpu = 1
    case cpu = 2
    case unknown = 3

    init(cValue: WGPUAdapterType) {
        self.init(rawValue: cValue.rawValue)!
    }

    var cValue: WGPUAdapterType {
        return WGPUAdapterType(rawValue: self.rawValue)
    }
}

public enum AddressMode: UInt32 {
    case `repeat` = 0
    case mirrorRepeat = 1
    case clampToEdge = 2

    init(cValue: WGPUAddressMode) {
        self.init(rawValue: cValue.rawValue)!
    }

    var cValue: WGPUAddressMode {
        return WGPUAddressMode(rawValue: self.rawValue)
    }
}

public enum BackendType: UInt32 {
    case null = 0
    case d3d11 = 1
    case d3d12 = 2
    case metal = 3
    case vulkan = 4
    case opengl = 5
    case opengles = 6

    init(cValue: WGPUBackendType) {
        self.init(rawValue: cValue.rawValue)!
    }

    var cValue: WGPUBackendType {
        return WGPUBackendType(rawValue: self.rawValue)
    }
}

public enum BufferBindingType: UInt32 {
    case undefined = 0
    case uniform = 1
    case storage = 2
    case readOnlyStorage = 3

    init(cValue: WGPUBufferBindingType) {
        self.init(rawValue: cValue.rawValue)!
    }

    var cValue: WGPUBufferBindingType {
        return WGPUBufferBindingType(rawValue: self.rawValue)
    }
}

public enum SamplerBindingType: UInt32 {
    case undefined = 0
    case filtering = 1
    case nonFiltering = 2
    case comparison = 3

    init(cValue: WGPUSamplerBindingType) {
        self.init(rawValue: cValue.rawValue)!
    }

    var cValue: WGPUSamplerBindingType {
        return WGPUSamplerBindingType(rawValue: self.rawValue)
    }
}

public enum TextureSampleType: UInt32 {
    case undefined = 0
    case float = 1
    case unfilterableFloat = 2
    case depth = 3
    case sint = 4
    case uint = 5

    init(cValue: WGPUTextureSampleType) {
        self.init(rawValue: cValue.rawValue)!
    }

    var cValue: WGPUTextureSampleType {
        return WGPUTextureSampleType(rawValue: self.rawValue)
    }
}

public enum StorageTextureAccess: UInt32 {
    case undefined = 0
    case readOnly = 1
    case writeOnly = 2

    init(cValue: WGPUStorageTextureAccess) {
        self.init(rawValue: cValue.rawValue)!
    }

    var cValue: WGPUStorageTextureAccess {
        return WGPUStorageTextureAccess(rawValue: self.rawValue)
    }
}

public enum BindingType: UInt32 {
    case undefined = 0
    case uniformBuffer = 1
    case storageBuffer = 2
    case readonlyStorageBuffer = 3
    case sampler = 4
    case comparisonSampler = 5
    case sampledTexture = 6
    case multisampledTexture = 7
    case readonlyStorageTexture = 8
    case writeonlyStorageTexture = 9

    init(cValue: WGPUBindingType) {
        self.init(rawValue: cValue.rawValue)!
    }

    var cValue: WGPUBindingType {
        return WGPUBindingType(rawValue: self.rawValue)
    }
}

public enum BlendFactor: UInt32 {
    case zero = 0
    case one = 1
    case srcColor = 2
    case oneMinusSrcColor = 3
    case srcAlpha = 4
    case oneMinusSrcAlpha = 5
    case dstColor = 6
    case oneMinusDstColor = 7
    case dstAlpha = 8
    case oneMinusDstAlpha = 9
    case srcAlphaSaturated = 10
    case blendColor = 11
    case oneMinusBlendColor = 12

    init(cValue: WGPUBlendFactor) {
        self.init(rawValue: cValue.rawValue)!
    }

    var cValue: WGPUBlendFactor {
        return WGPUBlendFactor(rawValue: self.rawValue)
    }
}

public enum BlendOperation: UInt32 {
    case add = 0
    case subtract = 1
    case reverseSubtract = 2
    case min = 3
    case max = 4

    init(cValue: WGPUBlendOperation) {
        self.init(rawValue: cValue.rawValue)!
    }

    var cValue: WGPUBlendOperation {
        return WGPUBlendOperation(rawValue: self.rawValue)
    }
}

public enum BufferMapAsyncStatus: UInt32 {
    case success = 0
    case error = 1
    case unknown = 2
    case deviceLost = 3
    case destroyedBeforeCallback = 4
    case unmappedBeforeCallback = 5

    init(cValue: WGPUBufferMapAsyncStatus) {
        self.init(rawValue: cValue.rawValue)!
    }

    var cValue: WGPUBufferMapAsyncStatus {
        return WGPUBufferMapAsyncStatus(rawValue: self.rawValue)
    }
}

public enum CompareFunction: UInt32 {
    case undefined = 0
    case never = 1
    case less = 2
    case lessEqual = 3
    case greater = 4
    case greaterEqual = 5
    case equal = 6
    case notEqual = 7
    case always = 8

    init(cValue: WGPUCompareFunction) {
        self.init(rawValue: cValue.rawValue)!
    }

    var cValue: WGPUCompareFunction {
        return WGPUCompareFunction(rawValue: self.rawValue)
    }
}

public enum CreatePipelineAsyncStatus: UInt32 {
    case success = 0
    case error = 1
    case deviceLost = 2
    case deviceDestroyed = 3
    case unknown = 4

    init(cValue: WGPUCreatePipelineAsyncStatus) {
        self.init(rawValue: cValue.rawValue)!
    }

    var cValue: WGPUCreatePipelineAsyncStatus {
        return WGPUCreatePipelineAsyncStatus(rawValue: self.rawValue)
    }
}

public enum CullMode: UInt32 {
    case none = 0
    case front = 1
    case back = 2

    init(cValue: WGPUCullMode) {
        self.init(rawValue: cValue.rawValue)!
    }

    var cValue: WGPUCullMode {
        return WGPUCullMode(rawValue: self.rawValue)
    }
}

public enum ErrorFilter: UInt32 {
    case none = 0
    case validation = 1
    case outOfMemory = 2

    init(cValue: WGPUErrorFilter) {
        self.init(rawValue: cValue.rawValue)!
    }

    var cValue: WGPUErrorFilter {
        return WGPUErrorFilter(rawValue: self.rawValue)
    }
}

public enum ErrorType: UInt32 {
    case noError = 0
    case validation = 1
    case outOfMemory = 2
    case unknown = 3
    case deviceLost = 4

    init(cValue: WGPUErrorType) {
        self.init(rawValue: cValue.rawValue)!
    }

    var cValue: WGPUErrorType {
        return WGPUErrorType(rawValue: self.rawValue)
    }
}

public enum FenceCompletionStatus: UInt32 {
    case success = 0
    case error = 1
    case unknown = 2
    case deviceLost = 3

    init(cValue: WGPUFenceCompletionStatus) {
        self.init(rawValue: cValue.rawValue)!
    }

    var cValue: WGPUFenceCompletionStatus {
        return WGPUFenceCompletionStatus(rawValue: self.rawValue)
    }
}

public enum FilterMode: UInt32 {
    case nearest = 0
    case linear = 1

    init(cValue: WGPUFilterMode) {
        self.init(rawValue: cValue.rawValue)!
    }

    var cValue: WGPUFilterMode {
        return WGPUFilterMode(rawValue: self.rawValue)
    }
}

public enum FrontFace: UInt32 {
    case ccw = 0
    case cw = 1

    init(cValue: WGPUFrontFace) {
        self.init(rawValue: cValue.rawValue)!
    }

    var cValue: WGPUFrontFace {
        return WGPUFrontFace(rawValue: self.rawValue)
    }
}

public enum IndexFormat: UInt32 {
    case undefined = 0
    case uint16 = 1
    case uint32 = 2

    init(cValue: WGPUIndexFormat) {
        self.init(rawValue: cValue.rawValue)!
    }

    var cValue: WGPUIndexFormat {
        return WGPUIndexFormat(rawValue: self.rawValue)
    }
}

public enum InputStepMode: UInt32 {
    case vertex = 0
    case instance = 1

    init(cValue: WGPUInputStepMode) {
        self.init(rawValue: cValue.rawValue)!
    }

    var cValue: WGPUInputStepMode {
        return WGPUInputStepMode(rawValue: self.rawValue)
    }
}

public enum LoadOp: UInt32 {
    case clear = 0
    case load = 1

    init(cValue: WGPULoadOp) {
        self.init(rawValue: cValue.rawValue)!
    }

    var cValue: WGPULoadOp {
        return WGPULoadOp(rawValue: self.rawValue)
    }
}

public enum StoreOp: UInt32 {
    case store = 0
    case clear = 1

    init(cValue: WGPUStoreOp) {
        self.init(rawValue: cValue.rawValue)!
    }

    var cValue: WGPUStoreOp {
        return WGPUStoreOp(rawValue: self.rawValue)
    }
}

public enum PipelineStatisticName: UInt32 {
    case vertexShaderInvocations = 0
    case clipperInvocations = 1
    case clipperPrimitivesOut = 2
    case fragmentShaderInvocations = 3
    case computeShaderInvocations = 4

    init(cValue: WGPUPipelineStatisticName) {
        self.init(rawValue: cValue.rawValue)!
    }

    var cValue: WGPUPipelineStatisticName {
        return WGPUPipelineStatisticName(rawValue: self.rawValue)
    }
}

public enum PresentMode: UInt32 {
    case immediate = 0
    case mailbox = 1
    case fifo = 2

    init(cValue: WGPUPresentMode) {
        self.init(rawValue: cValue.rawValue)!
    }

    var cValue: WGPUPresentMode {
        return WGPUPresentMode(rawValue: self.rawValue)
    }
}

public enum PrimitiveTopology: UInt32 {
    case pointList = 0
    case lineList = 1
    case lineStrip = 2
    case triangleList = 3
    case triangleStrip = 4

    init(cValue: WGPUPrimitiveTopology) {
        self.init(rawValue: cValue.rawValue)!
    }

    var cValue: WGPUPrimitiveTopology {
        return WGPUPrimitiveTopology(rawValue: self.rawValue)
    }
}

public enum QueryType: UInt32 {
    case occlusion = 0
    case pipelineStatistics = 1
    case timestamp = 2

    init(cValue: WGPUQueryType) {
        self.init(rawValue: cValue.rawValue)!
    }

    var cValue: WGPUQueryType {
        return WGPUQueryType(rawValue: self.rawValue)
    }
}

public enum QueueWorkDoneStatus: UInt32 {
    case success = 0
    case error = 1
    case unknown = 2
    case deviceLost = 3

    init(cValue: WGPUQueueWorkDoneStatus) {
        self.init(rawValue: cValue.rawValue)!
    }

    var cValue: WGPUQueueWorkDoneStatus {
        return WGPUQueueWorkDoneStatus(rawValue: self.rawValue)
    }
}

public enum StencilOperation: UInt32 {
    case keep = 0
    case zero = 1
    case replace = 2
    case invert = 3
    case incrementClamp = 4
    case decrementClamp = 5
    case incrementWrap = 6
    case decrementWrap = 7

    init(cValue: WGPUStencilOperation) {
        self.init(rawValue: cValue.rawValue)!
    }

    var cValue: WGPUStencilOperation {
        return WGPUStencilOperation(rawValue: self.rawValue)
    }
}

public enum SType: UInt32 {
    case invalid = 0
    case surfaceDescriptorFromMetalLayer = 1
    case surfaceDescriptorFromWindowsHwnd = 2
    case surfaceDescriptorFromXlib = 3
    case surfaceDescriptorFromCanvasHtmlSelector = 4
    case shaderModuleSpirvDescriptor = 5
    case shaderModuleWgslDescriptor = 6
    case samplerDescriptorDummyAnisotropicFiltering = 7
    case renderPipelineDescriptorDummyExtension = 8

    init(cValue: WGPUSType) {
        self.init(rawValue: cValue.rawValue)!
    }

    var cValue: WGPUSType {
        return WGPUSType(rawValue: self.rawValue)
    }
}

public enum TextureAspect: UInt32 {
    case all = 0
    case stencilOnly = 1
    case depthOnly = 2
    case plane0Only = 3
    case plane1Only = 4

    init(cValue: WGPUTextureAspect) {
        self.init(rawValue: cValue.rawValue)!
    }

    var cValue: WGPUTextureAspect {
        return WGPUTextureAspect(rawValue: self.rawValue)
    }
}

public enum TextureComponentType: UInt32 {
    case float = 0
    case sint = 1
    case uint = 2
    case depthComparison = 3

    init(cValue: WGPUTextureComponentType) {
        self.init(rawValue: cValue.rawValue)!
    }

    var cValue: WGPUTextureComponentType {
        return WGPUTextureComponentType(rawValue: self.rawValue)
    }
}

public enum TextureDimension: UInt32 {
    case type1d = 0
    case type2d = 1
    case type3d = 2

    init(cValue: WGPUTextureDimension) {
        self.init(rawValue: cValue.rawValue)!
    }

    var cValue: WGPUTextureDimension {
        return WGPUTextureDimension(rawValue: self.rawValue)
    }
}

public enum TextureFormat: UInt32 {
    case undefined = 0
    case r8Unorm = 1
    case r8Snorm = 2
    case r8Uint = 3
    case r8Sint = 4
    case r16Uint = 5
    case r16Sint = 6
    case r16Float = 7
    case rg8Unorm = 8
    case rg8Snorm = 9
    case rg8Uint = 10
    case rg8Sint = 11
    case r32Float = 12
    case r32Uint = 13
    case r32Sint = 14
    case rg16Uint = 15
    case rg16Sint = 16
    case rg16Float = 17
    case rgba8Unorm = 18
    case rgba8UnormSrgb = 19
    case rgba8Snorm = 20
    case rgba8Uint = 21
    case rgba8Sint = 22
    case bgra8Unorm = 23
    case bgra8UnormSrgb = 24
    case rgb10A2Unorm = 25
    case rg11B10Ufloat = 26
    case rgb9E5Ufloat = 27
    case rg32Float = 28
    case rg32Uint = 29
    case rg32Sint = 30
    case rgba16Uint = 31
    case rgba16Sint = 32
    case rgba16Float = 33
    case rgba32Float = 34
    case rgba32Uint = 35
    case rgba32Sint = 36
    case depth32Float = 37
    case depth24Plus = 38
    case stencil8 = 39
    case depth24PlusStencil8 = 40
    case bc1RgbaUnorm = 41
    case bc1RgbaUnormSrgb = 42
    case bc2RgbaUnorm = 43
    case bc2RgbaUnormSrgb = 44
    case bc3RgbaUnorm = 45
    case bc3RgbaUnormSrgb = 46
    case bc4RUnorm = 47
    case bc4RSnorm = 48
    case bc5RgUnorm = 49
    case bc5RgSnorm = 50
    case bc6hRgbUfloat = 51
    case bc6hRgbFloat = 52
    case bc7RgbaUnorm = 53
    case bc7RgbaUnormSrgb = 54
    case r8Bg8Biplanar420Unorm = 55

    init(cValue: WGPUTextureFormat) {
        self.init(rawValue: cValue.rawValue)!
    }

    var cValue: WGPUTextureFormat {
        return WGPUTextureFormat(rawValue: self.rawValue)
    }
}

public enum TextureViewDimension: UInt32 {
    case typeUndefined = 0
    case type1d = 1
    case type2d = 2
    case type2dArray = 3
    case typeCube = 4
    case typeCubeArray = 5
    case type3d = 6

    init(cValue: WGPUTextureViewDimension) {
        self.init(rawValue: cValue.rawValue)!
    }

    var cValue: WGPUTextureViewDimension {
        return WGPUTextureViewDimension(rawValue: self.rawValue)
    }
}

public enum VertexFormat: UInt32 {
    case undefined = 0
    case uint8x2 = 1
    case uint8x4 = 2
    case sint8x2 = 3
    case sint8x4 = 4
    case unorm8x2 = 5
    case unorm8x4 = 6
    case snorm8x2 = 7
    case snorm8x4 = 8
    case uint16x2 = 9
    case uint16x4 = 10
    case sint16x2 = 11
    case sint16x4 = 12
    case unorm16x2 = 13
    case unorm16x4 = 14
    case snorm16x2 = 15
    case snorm16x4 = 16
    case float16x2 = 17
    case float16x4 = 18
    case float32 = 19
    case float32x2 = 20
    case float32x3 = 21
    case float32x4 = 22
    case uint32 = 23
    case uint32x2 = 24
    case uint32x3 = 25
    case uint32x4 = 26
    case sint32 = 27
    case sint32x2 = 28
    case sint32x3 = 29
    case sint32x4 = 30
    case uchar2 = 101
    case uchar4 = 102
    case char2 = 103
    case char4 = 104
    case uchar2Norm = 105
    case uchar4Norm = 106
    case char2Norm = 107
    case char4Norm = 108
    case ushort2 = 109
    case ushort4 = 110
    case short2 = 111
    case short4 = 112
    case ushort2Norm = 113
    case ushort4Norm = 114
    case short2Norm = 115
    case short4Norm = 116
    case half2 = 117
    case half4 = 118
    case float = 119
    case float2 = 120
    case float3 = 121
    case float4 = 122
    case uint = 123
    case uint2 = 124
    case uint3 = 125
    case uint4 = 126
    case int = 127
    case int2 = 128
    case int3 = 129
    case int4 = 130

    init(cValue: WGPUVertexFormat) {
        self.init(rawValue: cValue.rawValue)!
    }

    var cValue: WGPUVertexFormat {
        return WGPUVertexFormat(rawValue: self.rawValue)
    }
}

