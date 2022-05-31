import CWebGPU


// MARK: String
extension Optional where Wrapped == String {
    func withOptionalCString<R>(_ body: (UnsafePointer<CChar>?) throws -> R) rethrows -> R {
        guard let s = self else { return try body(nil) }
        return try s.withCString(body)
    }
}

func _withCStringBufferPointer<I: IteratorProtocol, R>(to array: inout [UnsafePointer<CChar>?], appending iterator: inout I, _ body: (UnsafeBufferPointer<UnsafePointer<CChar>?>) throws -> R) rethrows -> R where I.Element == String {
    if let string = iterator.next() {
        return try string.withCString { cString in
            array.append(cString)
            return try _withCStringBufferPointer(to: &array, appending: &iterator, body)
        }
    }else{
        return try array.withUnsafeBufferPointer { ptr in
            try body(ptr)
        }
    }
}

extension Array where Element == String {
    func withCStringBufferPointer<R>(_ body: (UnsafeBufferPointer<UnsafePointer<CChar>?>) throws -> R) rethrows -> R {
        var cStrings: [UnsafePointer<CChar>?] = []
        cStrings.reserveCapacity(self.count)
        var iterator = makeIterator()
        return try _withCStringBufferPointer(to: &cStrings, appending: &iterator, body)
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


// MARK: Object
protocol Object {
    func withUnsafeHandle<R>(_ body: (OpaquePointer) throws -> R) rethrows -> R
}

extension Optional where Wrapped: Object {
    func withOptionalHandle<R>(_ body: (OpaquePointer?) throws -> R) rethrows -> R {
        guard let object = self else { return try body(nil) }
        return try object.withUnsafeHandle(body)
    }
}

func _withHandleBufferPointer<I: IteratorProtocol, R>(to array: inout [OpaquePointer?], appending iterator: inout I, _ body: (UnsafeBufferPointer<OpaquePointer?>) throws -> R) rethrows -> R where I.Element: Object {
    if let object = iterator.next() {
        return try object.withUnsafeHandle { handle in
            array.append(handle)
            return try _withHandleBufferPointer(to: &array, appending: &iterator, body)
        }
    }else{
        return try array.withUnsafeBufferPointer { ptr in
            try body(ptr)
        }
    }
}

extension Array where Element: Object {
    func withHandleBufferPointer<R>(_ body: (UnsafeBufferPointer<OpaquePointer?>) throws -> R) rethrows -> R {
        var handles: [OpaquePointer?] = []
        handles.reserveCapacity(self.count)
        var iterator = makeIterator()
        return try _withHandleBufferPointer(to: &handles, appending: &iterator, body)
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


// MARK: Callback
class UserData<T> {
    let value: T
    let retained: Bool
    
    init(_ value: T, retained: Bool = false) {
        self.value = value
        self.retained = retained
    }
    
    func toOpaque() -> UnsafeMutableRawPointer {
        if self.retained {
            return Unmanaged.passRetained(self).toOpaque()
        } else {
            return Unmanaged.passUnretained(self).toOpaque()
        }
    }
    
    static func passRetained(_ value: T) -> UnsafeMutableRawPointer {
        return UserData(value, retained: true).toOpaque()
    }
    
    static func takeValue(_ ptr: UnsafeRawPointer) -> T {
        let unmanaged = Unmanaged<UserData<T>>.fromOpaque(ptr)
        let userData = unmanaged.takeUnretainedValue()
        if userData.retained {
            unmanaged.release()
        }
        return userData.value
    }
}
