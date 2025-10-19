/// A property wrapper that provides a default value during decoding if the value is missing.
@propertyWrapper
struct DefaultFallback<T: HasDefaultValue & Decodable> : HasDefaultValue, Decodable {
    var wrappedValue: T

    init() {
        self.wrappedValue = T()
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.wrappedValue = (try container.decode(T.self))
    }
}

extension KeyedDecodingContainer {
    // This is used to override the default decoding behavior to allow a value to avoid a missing key error
    func decode<T>(_ type: DefaultFallback<T>.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> DefaultFallback<T> {
        return try decodeIfPresent(type, forKey: key) ?? DefaultFallback()
    }
}
