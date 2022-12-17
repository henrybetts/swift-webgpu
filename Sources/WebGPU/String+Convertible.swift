extension String: ConvertibleFromC, ConvertibleToCWithClosure {
    typealias CType = UnsafePointer<CChar>?
    
    init(cValue: UnsafePointer<CChar>?) {
        self.init(cString: cValue!)
    }
    
    func withCValue<R>(_ body: (UnsafePointer<CChar>?) throws -> R) rethrows -> R {
        return try withCString(body)
    }
}
