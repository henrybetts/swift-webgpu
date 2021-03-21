/* String */
extension Optional where Wrapped == String {
    func withOptionalCString<R>(_ body: (UnsafePointer<CChar>?) throws -> R) rethrows -> R {
        guard let s = self else { return try body(nil) }
        return try s.withCString(body)
    }
}
