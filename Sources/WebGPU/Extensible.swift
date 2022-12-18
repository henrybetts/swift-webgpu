import CWebGPU

public protocol Extensible {
    var nextInChain: Chained? { get }
}

public protocol Chained: Extensible {
    func withChainedStruct<R>(_ body: (UnsafePointer<WGPUChainedStruct>) throws -> R) rethrows -> R
}
