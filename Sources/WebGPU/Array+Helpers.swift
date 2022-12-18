extension Array where Element: ConvertibleFromC {
    init(cValues: UnsafeBufferPointer<Element.CType>) {
        self = cValues.map { .init(cValue: $0) }
    }
}

extension Array where Element: ConvertibleToC {
    func withCValues<R>(_ body: (UnsafeBufferPointer<Element.CType>) throws -> R) rethrows -> R {
        return try self.map { $0.cValue }.withUnsafeBufferPointer(body)
    }
}

extension Array where Element: ConvertibleToCWithClosure {
    func withCValues<R>(_ body: (UnsafeBufferPointer<Element.CType>) throws -> R) rethrows -> R {
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

// UnsafeRawBufferPointer is treated like an array
extension UnsafeRawBufferPointer {
    func withUnsafeBufferPointer<R>(_ body: (UnsafeRawBufferPointer) throws -> R) rethrows -> R {
        return try body(self)
    }
}
