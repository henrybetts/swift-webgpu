/* String */
extension Optional where Wrapped == String {
    func withOptionalCString<R>(_ body: (UnsafePointer<CChar>?) throws -> R) rethrows -> R {
        guard let s = self else { return try body(nil) }
        return try s.withCString(body)
    }
}


/* Struct */
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
