protocol DefaultFallbackProtocol: HasDefaultValue & Decodable {}

@propertyWrapper
struct DefaultFallback<T: HasDefaultValue & Decodable> {
    var wrappedValue: T
}

extension DefaultFallback: DefaultFallbackProtocol {
    init() {
        self.wrappedValue = T()
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.wrappedValue = (try? container.decode(T.self)) ?? T()
    }
}

extension KeyedDecodingContainer {
    // This is used to override the default decoding behavior to allow a value to avoid a missing key Error
    func decode<T>(_ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> T where T: DefaultFallbackProtocol {
        return try decodeIfPresent(T.self, forKey: key) ?? T()
    }
}
