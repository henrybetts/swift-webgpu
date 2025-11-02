import CWebGPU

extension Optional where Wrapped: ConvertibleFromC {
    init<T>(cValue: Wrapped.CType) where Wrapped.CType == Optional<T> {
        if let cValue = cValue {
            self = Wrapped(cValue: cValue)
        } else {
            self = nil
        }
    }

    init(cPointer: UnsafePointer<Wrapped.CType>?) {
        if let cPointer = cPointer {
            self = Wrapped(cPointer: cPointer)
        } else {
            self = nil
        }
    }
}


extension Optional where Wrapped: ConvertibleToCWithClosure {
    func withCValue<T, R>(_ body: (Wrapped.CType) throws -> R) rethrows -> R where Wrapped.CType == Optional<T> {
        if let value = self {
            return try value.withCValue(body)
        } else {
            return try body(nil)
        }
    }
    
    func withCPointer<R>(_ body: (UnsafePointer<Wrapped.CType>?) throws -> R) rethrows -> R {
        if let value = self {
            return try value.withCPointer(body)
        } else {
            return try body(nil)
        }
    }
}
