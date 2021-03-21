import CWebGPU

// MARK: Generic
extension Optional {
    func withOptionalUnsafeBufferPointer<T, R>(_ body: (UnsafeBufferPointer<T>) throws -> R) rethrows -> R where Wrapped == Array<T> {
        guard let array = self else { return try body(UnsafeBufferPointer(start: nil, count: 0)) }
        return try array.withUnsafeBufferPointer(body)
    }
}


// MARK: String
extension Optional where Wrapped == String {
    func withOptionalCString<R>(_ body: (UnsafePointer<CChar>?) throws -> R) rethrows -> R {
        guard let s = self else { return try body(nil) }
        return try s.withCString(body)
    }
}


// MARK: Struct
protocol CStructConvertible {
    associatedtype CStruct
    func withCStruct<R>(_ body: (UnsafePointer<CStruct>) throws -> R) rethrows -> R
}

extension Optional where Wrapped: CStructConvertible {
    func withOptionalCStruct<R>(_ body: (UnsafePointer<Wrapped.CStruct>?) throws -> R) rethrows -> R {
        guard let s = self else { return try body(nil) }
        return try s.withCStruct(body)
    }
}

func _withCStructBufferPointer<S: CStructConvertible, I: IteratorProtocol, R>(to array: inout [S.CStruct], appending iterator: inout I, _ body: (UnsafeBufferPointer<S.CStruct>) throws -> R) rethrows -> R where I.Element == S {
    if let structure = iterator.next() {
        return try structure.withCStruct { cStruct in
            array.append(cStruct.pointee)
            return try _withCStructBufferPointer(to: &array, appending: &iterator, body)
        }
    }else{
        return try array.withUnsafeBufferPointer { ptr in
            try body(ptr)
        }
    }
}

extension Array where Element: CStructConvertible {
    func withCStructBufferPointer<R>(_ body: (UnsafeBufferPointer<Element.CStruct>) throws -> R) rethrows -> R {
        var cStructs: [Element.CStruct] = []
        cStructs.reserveCapacity(self.count)
        var iterator = makeIterator()
        return try _withCStructBufferPointer(to: &cStructs, appending: &iterator, body)
    }
}


// MARK: Extensible
public protocol Extensible {
    var nextInChain: Chained? { get }
}

public protocol Chained: Extensible {
    func withChainedCStruct<R>(_ body: (UnsafePointer<WGPUChainedStruct>) throws -> R) rethrows -> R
}

extension Optional where Wrapped == Chained {
    func withOptionalChainedCStruct<R>(_ body: (UnsafePointer<WGPUChainedStruct>?) throws -> R) rethrows -> R {
        guard let s = self else { return try body(nil) }
        return try s.withChainedCStruct(body)
    }
}
