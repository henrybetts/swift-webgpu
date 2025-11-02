extension Array {    
    init(cValue: UnsafeBufferPointer<Element>) {
        self.init(cValue)
    }
    
    init(cValue: UnsafeBufferPointer<Element.CType>) where Element: ConvertibleFromC {
        self = cValue.map { .init(cValue: $0) }
    }
    
    func withCValue<R>(_ body: (UnsafeBufferPointer<Element>) throws -> R) rethrows -> R {
        return try withUnsafeBufferPointer(body)
    }
    
    func withCValue<R>(_ body: (UnsafeBufferPointer<Element.CType>) throws -> R) rethrows -> R where Element: ConvertibleToC {
        return try self.map { $0.cValue }.withUnsafeBufferPointer(body)
    }
    
    func withCValue<R>(_ body: (UnsafeBufferPointer<Element.CType>) throws -> R) rethrows -> R where Element: ConvertibleToCWithClosure {
        var cValues: [Element.CType] = []
        cValues.reserveCapacity(count)
        var iterator = makeIterator()
        return try _withCValues(&cValues, appending: &iterator, body: body)
    }
}

func _withCValues<I: IteratorProtocol, R>(_ cValues: inout [I.Element.CType], appending iterator: inout I, body: (UnsafeBufferPointer<I.Element.CType>) throws -> R) rethrows -> R where I.Element: ConvertibleToCWithClosure {
    if let value = iterator.next() {
        return try value.withCValue{ cValue in
            cValues.append(cValue)
            return try _withCValues(&cValues, appending: &iterator, body: body)
        }
    }else{
        return try cValues.withUnsafeBufferPointer { buffer in
            try body(buffer)
        }
    }
}
