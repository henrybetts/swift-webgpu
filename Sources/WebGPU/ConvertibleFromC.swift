protocol ConvertibleFromC {
    associatedtype CType
    init(cValue: CType)
}

extension String: ConvertibleFromC {
    typealias CType = UnsafePointer<CChar>
    
    init(cValue: UnsafePointer<CChar>) {
        self.init(cString: cValue)
    }
}

extension Optional where Wrapped: ConvertibleFromC {
    init(cValue: Wrapped.CType?) {
        if let cValue = cValue {
            self = Wrapped(cValue: cValue)
        } else {
            self = nil
        }
    }
    
    init(cValue: UnsafePointer<Wrapped.CType>?) {
        if let cValue = cValue {
            self = Wrapped(cValue: cValue.pointee)
        } else {
            self = nil
        }
    }
}

extension Array where Element: ConvertibleFromC {
    init(cValue: UnsafeBufferPointer<Element.CType>) {
        self = cValue.map { .init(cValue: $0) }
    }
    
    init(cValue: UnsafeBufferPointer<Element.CType?>) {
        self = cValue.map { .init(cValue: $0!) }
    }
}

extension Array {
    init(cValue: UnsafeBufferPointer<Element>) {
        self.init(cValue)
    }
}

extension Optional {
    init<T>(cValue: UnsafeBufferPointer<T>?) where Wrapped == Array<T> {
        if let cValue = cValue {
            self = Wrapped(cValue: cValue)
        } else {
            self = nil
        }
    }
}
