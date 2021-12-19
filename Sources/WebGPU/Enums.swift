import CWebGPU

public enum RequestAdapterStatus: WGPURequestAdapterStatus.RawValue {
    case success = 0
    case unavailable = 1
    case error = 2
    case unknown = 3

    init(cValue: WGPURequestAdapterStatus) {
        self.init(rawValue: cValue.rawValue)!
    }

    var cValue: WGPURequestAdapterStatus {
        return WGPURequestAdapterStatus(rawValue: self.rawValue)
    }
}

public enum AdapterType: WGPUAdapterType.RawValue {
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

public enum AddressMode: WGPUAddressMode.RawValue {
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

public enum BackendType: WGPUBackendType.RawValue {
    case null = 0
    case webgpu = 1
    case d3d11 = 2
    case d3d12 = 3
    case metal = 4
    case vulkan = 5
    case opengl = 6
    case opengles = 7

    init(cValue: WGPUBackendType) {
        self.init(rawValue: cValue.rawValue)!
    }

    var cValue: WGPUBackendType {
        return WGPUBackendType(rawValue: self.rawValue)
    }
}

public enum BufferBindingType: WGPUBufferBindingType.RawValue {
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

public enum SamplerBindingType: WGPUSamplerBindingType.RawValue {
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

public enum TextureSampleType: WGPUTextureSampleType.RawValue {
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

public enum StorageTextureAccess: WGPUStorageTextureAccess.RawValue {
    case undefined = 0
    case writeOnly = 1

    init(cValue: WGPUStorageTextureAccess) {
        self.init(rawValue: cValue.rawValue)!
    }

    var cValue: WGPUStorageTextureAccess {
        return WGPUStorageTextureAccess(rawValue: self.rawValue)
    }
}

public enum BlendFactor: WGPUBlendFactor.RawValue {
    case zero = 0
    case one = 1
    case src = 2
    case oneMinusSrc = 3
    case srcAlpha = 4
    case oneMinusSrcAlpha = 5
    case dst = 6
    case oneMinusDst = 7
    case dstAlpha = 8
    case oneMinusDstAlpha = 9
    case srcAlphaSaturated = 10
    case constant = 11
    case oneMinusConstant = 12

    init(cValue: WGPUBlendFactor) {
        self.init(rawValue: cValue.rawValue)!
    }

    var cValue: WGPUBlendFactor {
        return WGPUBlendFactor(rawValue: self.rawValue)
    }
}

public enum BlendOperation: WGPUBlendOperation.RawValue {
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

public enum BufferMapAsyncStatus: WGPUBufferMapAsyncStatus.RawValue {
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

public enum CompareFunction: WGPUCompareFunction.RawValue {
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

public enum CompilationInfoRequestStatus: WGPUCompilationInfoRequestStatus.RawValue {
    case success = 0
    case error = 1
    case deviceLost = 2
    case unknown = 3

    init(cValue: WGPUCompilationInfoRequestStatus) {
        self.init(rawValue: cValue.rawValue)!
    }

    var cValue: WGPUCompilationInfoRequestStatus {
        return WGPUCompilationInfoRequestStatus(rawValue: self.rawValue)
    }
}

public enum CompilationMessageType: WGPUCompilationMessageType.RawValue {
    case error = 0
    case warning = 1
    case info = 2

    init(cValue: WGPUCompilationMessageType) {
        self.init(rawValue: cValue.rawValue)!
    }

    var cValue: WGPUCompilationMessageType {
        return WGPUCompilationMessageType(rawValue: self.rawValue)
    }
}

public enum AlphaMode: WGPUAlphaMode.RawValue {
    case premultiplied = 0
    case unpremultiplied = 1

    init(cValue: WGPUAlphaMode) {
        self.init(rawValue: cValue.rawValue)!
    }

    var cValue: WGPUAlphaMode {
        return WGPUAlphaMode(rawValue: self.rawValue)
    }
}

public enum CreatePipelineAsyncStatus: WGPUCreatePipelineAsyncStatus.RawValue {
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

public enum CullMode: WGPUCullMode.RawValue {
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

public enum DeviceLostReason: WGPUDeviceLostReason.RawValue {
    case undefined = 0
    case destroyed = 1

    init(cValue: WGPUDeviceLostReason) {
        self.init(rawValue: cValue.rawValue)!
    }

    var cValue: WGPUDeviceLostReason {
        return WGPUDeviceLostReason(rawValue: self.rawValue)
    }
}

public enum ErrorFilter: WGPUErrorFilter.RawValue {
    case validation = 0
    case outOfMemory = 1

    init(cValue: WGPUErrorFilter) {
        self.init(rawValue: cValue.rawValue)!
    }

    var cValue: WGPUErrorFilter {
        return WGPUErrorFilter(rawValue: self.rawValue)
    }
}

public enum ErrorType: WGPUErrorType.RawValue {
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

public enum LoggingType: WGPULoggingType.RawValue {
    case verbose = 0
    case info = 1
    case warning = 2
    case error = 3

    init(cValue: WGPULoggingType) {
        self.init(rawValue: cValue.rawValue)!
    }

    var cValue: WGPULoggingType {
        return WGPULoggingType(rawValue: self.rawValue)
    }
}

public enum FeatureName: WGPUFeatureName.RawValue {
    case undefined = 0
    case depth24UnormStencil8 = 2
    case depth32FloatStencil8 = 3
    case timestampQuery = 4
    case pipelineStatisticsQuery = 5
    case textureCompressionBc = 6
    case textureCompressionEtc2 = 7
    case textureCompressionAstc = 8
    case indirectFirstInstance = 9
    case depthClamping = 1000
    case dawnShaderFloat16 = 1001
    case dawnInternalUsages = 1002
    case dawnMultiPlanarFormats = 1003

    init(cValue: WGPUFeatureName) {
        self.init(rawValue: cValue.rawValue)!
    }

    var cValue: WGPUFeatureName {
        return WGPUFeatureName(rawValue: self.rawValue)
    }
}

public enum FilterMode: WGPUFilterMode.RawValue {
    case nearest = 0
    case linear = 1

    init(cValue: WGPUFilterMode) {
        self.init(rawValue: cValue.rawValue)!
    }

    var cValue: WGPUFilterMode {
        return WGPUFilterMode(rawValue: self.rawValue)
    }
}

public enum FrontFace: WGPUFrontFace.RawValue {
    case ccw = 0
    case cw = 1

    init(cValue: WGPUFrontFace) {
        self.init(rawValue: cValue.rawValue)!
    }

    var cValue: WGPUFrontFace {
        return WGPUFrontFace(rawValue: self.rawValue)
    }
}

public enum IndexFormat: WGPUIndexFormat.RawValue {
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

public enum VertexStepMode: WGPUVertexStepMode.RawValue {
    case vertex = 0
    case instance = 1

    init(cValue: WGPUVertexStepMode) {
        self.init(rawValue: cValue.rawValue)!
    }

    var cValue: WGPUVertexStepMode {
        return WGPUVertexStepMode(rawValue: self.rawValue)
    }
}

public enum LoadOp: WGPULoadOp.RawValue {
    case clear = 0
    case load = 1

    init(cValue: WGPULoadOp) {
        self.init(rawValue: cValue.rawValue)!
    }

    var cValue: WGPULoadOp {
        return WGPULoadOp(rawValue: self.rawValue)
    }
}

public enum StoreOp: WGPUStoreOp.RawValue {
    case store = 0
    case discard = 1

    init(cValue: WGPUStoreOp) {
        self.init(rawValue: cValue.rawValue)!
    }

    var cValue: WGPUStoreOp {
        return WGPUStoreOp(rawValue: self.rawValue)
    }
}

public enum PipelineStatisticName: WGPUPipelineStatisticName.RawValue {
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

public enum PowerPreference: WGPUPowerPreference.RawValue {
    case undefined = 0
    case lowPower = 1
    case highPerformance = 2

    init(cValue: WGPUPowerPreference) {
        self.init(rawValue: cValue.rawValue)!
    }

    var cValue: WGPUPowerPreference {
        return WGPUPowerPreference(rawValue: self.rawValue)
    }
}

public enum PresentMode: WGPUPresentMode.RawValue {
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

public enum PrimitiveTopology: WGPUPrimitiveTopology.RawValue {
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

public enum QueryType: WGPUQueryType.RawValue {
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

public enum QueueWorkDoneStatus: WGPUQueueWorkDoneStatus.RawValue {
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

public enum RequestDeviceStatus: WGPURequestDeviceStatus.RawValue {
    case success = 0
    case error = 1
    case unknown = 2

    init(cValue: WGPURequestDeviceStatus) {
        self.init(rawValue: cValue.rawValue)!
    }

    var cValue: WGPURequestDeviceStatus {
        return WGPURequestDeviceStatus(rawValue: self.rawValue)
    }
}

public enum StencilOperation: WGPUStencilOperation.RawValue {
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

public enum SType: WGPUSType.RawValue {
    case invalid = 0
    case surfaceDescriptorFromMetalLayer = 1
    case surfaceDescriptorFromWindowsHwnd = 2
    case surfaceDescriptorFromXlib = 3
    case surfaceDescriptorFromCanvasHtmlSelector = 4
    case shaderModuleSpirvDescriptor = 5
    case shaderModuleWgslDescriptor = 6
    case surfaceDescriptorFromWindowsCoreWindow = 8
    case externalTextureBindingEntry = 9
    case externalTextureBindingLayout = 10
    case surfaceDescriptorFromWindowsSwapChainPanel = 11
    case dawnTextureInternalUsageDescriptor = 1000
    case primitiveDepthClampingState = 1001

    init(cValue: WGPUSType) {
        self.init(rawValue: cValue.rawValue)!
    }

    var cValue: WGPUSType {
        return WGPUSType(rawValue: self.rawValue)
    }
}

public enum TextureAspect: WGPUTextureAspect.RawValue {
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

public enum TextureComponentType: WGPUTextureComponentType.RawValue {
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

public enum TextureDimension: WGPUTextureDimension.RawValue {
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

public enum TextureFormat: WGPUTextureFormat.RawValue {
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
    case stencil8 = 37
    case depth16Unorm = 38
    case depth24Plus = 39
    case depth24PlusStencil8 = 40
    case depth24UnormStencil8 = 41
    case depth32Float = 42
    case depth32FloatStencil8 = 43
    case bc1RgbaUnorm = 44
    case bc1RgbaUnormSrgb = 45
    case bc2RgbaUnorm = 46
    case bc2RgbaUnormSrgb = 47
    case bc3RgbaUnorm = 48
    case bc3RgbaUnormSrgb = 49
    case bc4RUnorm = 50
    case bc4RSnorm = 51
    case bc5RgUnorm = 52
    case bc5RgSnorm = 53
    case bc6hRgbUfloat = 54
    case bc6hRgbFloat = 55
    case bc7RgbaUnorm = 56
    case bc7RgbaUnormSrgb = 57
    case etc2Rgb8Unorm = 58
    case etc2Rgb8UnormSrgb = 59
    case etc2Rgb8a1Unorm = 60
    case etc2Rgb8a1UnormSrgb = 61
    case etc2Rgba8Unorm = 62
    case etc2Rgba8UnormSrgb = 63
    case eacR11Unorm = 64
    case eacR11Snorm = 65
    case eacRg11Unorm = 66
    case eacRg11Snorm = 67
    case astc4x4Unorm = 68
    case astc4x4UnormSrgb = 69
    case astc5x4Unorm = 70
    case astc5x4UnormSrgb = 71
    case astc5x5Unorm = 72
    case astc5x5UnormSrgb = 73
    case astc6x5Unorm = 74
    case astc6x5UnormSrgb = 75
    case astc6x6Unorm = 76
    case astc6x6UnormSrgb = 77
    case astc8x5Unorm = 78
    case astc8x5UnormSrgb = 79
    case astc8x6Unorm = 80
    case astc8x6UnormSrgb = 81
    case astc8x8Unorm = 82
    case astc8x8UnormSrgb = 83
    case astc10x5Unorm = 84
    case astc10x5UnormSrgb = 85
    case astc10x6Unorm = 86
    case astc10x6UnormSrgb = 87
    case astc10x8Unorm = 88
    case astc10x8UnormSrgb = 89
    case astc10x10Unorm = 90
    case astc10x10UnormSrgb = 91
    case astc12x10Unorm = 92
    case astc12x10UnormSrgb = 93
    case astc12x12Unorm = 94
    case astc12x12UnormSrgb = 95
    case r8Bg8Biplanar420Unorm = 96

    init(cValue: WGPUTextureFormat) {
        self.init(rawValue: cValue.rawValue)!
    }

    var cValue: WGPUTextureFormat {
        return WGPUTextureFormat(rawValue: self.rawValue)
    }
}

public enum TextureViewDimension: WGPUTextureViewDimension.RawValue {
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

public enum VertexFormat: WGPUVertexFormat.RawValue {
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

    init(cValue: WGPUVertexFormat) {
        self.init(rawValue: cValue.rawValue)!
    }

    var cValue: WGPUVertexFormat {
        return WGPUVertexFormat(rawValue: self.rawValue)
    }
}

