protocol ConvertibleFromC {
    associatedtype CType
    init(cValue: CType)
}

extension ConvertibleFromC {
    init(cPointer: UnsafePointer<CType>) {
        self.init(cValue: cPointer.pointee)
    }
}


protocol ConvertibleToC {
    associatedtype CType
    var cValue: CType { get }
}


protocol ConvertibleToCWithClosure {
    associatedtype CType
    func withCValue<R>(_ body: (CType) throws -> R) rethrows -> R
}

extension ConvertibleToCWithClosure {
    func withCPointer<R>(_ body: (UnsafePointer<CType>) throws -> R) rethrows -> R {
        return try withCValue { value in
            return try withUnsafePointer(to: value) {
                return try body($0)
            }
        }
    }
}
