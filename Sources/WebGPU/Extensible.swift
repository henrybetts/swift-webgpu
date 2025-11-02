import CWebGPU

public protocol Extensible {
    var nextInChain: Chained? { get }
}

public protocol Chained: Extensible {
    func withChainedStruct<R>(_ body: (UnsafePointer<WGPUChainedStruct>) throws -> R) rethrows -> R
}

extension Optional<Chained> {
    func withChainedStruct<R>(_ body: (UnsafePointer<WGPUChainedStruct>?) throws -> R) rethrows -> R {
        if let chainedStruct = self {
            return try chainedStruct.withChainedStruct(body)
        } else {
            return try body(nil)
        }
    }
}
