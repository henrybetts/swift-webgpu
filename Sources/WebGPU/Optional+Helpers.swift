extension Optional {
    init<T>(_ buffer: UnsafeBufferPointer<T>) where Wrapped == Array<T> {
        if !buffer.isEmpty {
            self = Wrapped(buffer)
        } else {
            self = nil
        }
    }
    
    func withUnsafeBufferPointer<T, R>(_ body: (UnsafeBufferPointer<T>) throws -> R) rethrows -> R where Wrapped == Array<T> {
        if let value = self {
            return try value.withUnsafeBufferPointer(body)
        } else {
            return try body(UnsafeBufferPointer<T>(start: nil, count: 0))
        }
    }
}

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

extension Optional {
    init<T: ConvertibleFromC>(cValues: UnsafeBufferPointer<T.CType>) where Wrapped == Array<T> {
        if !cValues.isEmpty {
            self = Wrapped(cValues: cValues)
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
