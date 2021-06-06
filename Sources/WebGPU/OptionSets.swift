import CWebGPU

public struct BufferUsage: OptionSet {
    public let rawValue: UInt32

    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }

    public static let none = BufferUsage([])
    public static let mapRead = BufferUsage(rawValue: 1)
    public static let mapWrite = BufferUsage(rawValue: 2)
    public static let copySrc = BufferUsage(rawValue: 4)
    public static let copyDst = BufferUsage(rawValue: 8)
    public static let index = BufferUsage(rawValue: 16)
    public static let vertex = BufferUsage(rawValue: 32)
    public static let uniform = BufferUsage(rawValue: 64)
    public static let storage = BufferUsage(rawValue: 128)
    public static let indirect = BufferUsage(rawValue: 256)
    public static let queryResolve = BufferUsage(rawValue: 512)
}

public struct ColorWriteMask: OptionSet {
    public let rawValue: UInt32

    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }

    public static let none = ColorWriteMask([])
    public static let red = ColorWriteMask(rawValue: 1)
    public static let green = ColorWriteMask(rawValue: 2)
    public static let blue = ColorWriteMask(rawValue: 4)
    public static let alpha = ColorWriteMask(rawValue: 8)
    public static let all = ColorWriteMask(rawValue: 15)
}

public struct MapMode: OptionSet {
    public let rawValue: UInt32

    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }

    public static let none = MapMode([])
    public static let read = MapMode(rawValue: 1)
    public static let write = MapMode(rawValue: 2)
}

public struct ShaderStage: OptionSet {
    public let rawValue: UInt32

    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }

    public static let none = ShaderStage([])
    public static let vertex = ShaderStage(rawValue: 1)
    public static let fragment = ShaderStage(rawValue: 2)
    public static let compute = ShaderStage(rawValue: 4)
}

public struct TextureUsage: OptionSet {
    public let rawValue: UInt32

    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }

    public static let none = TextureUsage([])
    public static let copySrc = TextureUsage(rawValue: 1)
    public static let copyDst = TextureUsage(rawValue: 2)
    public static let sampled = TextureUsage(rawValue: 4)
    public static let storage = TextureUsage(rawValue: 8)
    public static let renderAttachment = TextureUsage(rawValue: 16)
    public static let present = TextureUsage(rawValue: 32)
}

