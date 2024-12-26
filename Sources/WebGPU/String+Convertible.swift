import CWebGPU

extension String: ConvertibleFromC, ConvertibleToCWithClosure {
    typealias CType = WGPUStringView
    
    init(cValue: CType) {
        if cValue.length == WGPU_STRLEN {
            self.init(cString: cValue.data)
        } else {
            let bytes = UnsafeRawBufferPointer(start: cValue.data, count: cValue.length)
            self.init(decoding: bytes, as: UTF8.self)
        }
    }
    
    func withCValue<R>(_ body: (CType) throws -> R) rethrows -> R {
        var copy = self
        return try copy.withUTF8 { utf8String in
            return try utf8String.withMemoryRebound(to: CChar.self) { cString in
                let cValue = CType(data: cString.baseAddress, length: cString.count)
                return try body(cValue)
            }
        }
    }
}

extension Optional<String> {
    init(cValue: String.CType) {
        if cValue.data == nil && cValue.length == WGPU_STRLEN {
            self = nil
        } else {
            self = String(cValue: cValue)
        }
    }
    
    func withCValue<R>(_ body: (String.CType) throws -> R) rethrows -> R {
        if let value = self {
            return try value.withCValue(body)
        } else {
            return try body(String.CType(data: nil, length: Int(bitPattern: UInt(WGPU_STRLEN))))
        }
    }
}
