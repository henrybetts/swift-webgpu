extension String: CodingKey {
    public init?(stringValue: String) {
        self.init(stringValue)
    }
    
    public init?(intValue: Int) {
        return nil
    }
    
    public var stringValue: String {
        return self
    }
    
    public var intValue: Int? {
        return nil
    }
}
