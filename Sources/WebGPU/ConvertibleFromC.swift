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
