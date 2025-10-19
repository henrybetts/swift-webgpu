/// A protocol for types that have an empty initializer - or a "default value".
protocol HasDefaultValue {
    init()
}

extension Array: HasDefaultValue {}
extension Set: HasDefaultValue {}
extension Bool: HasDefaultValue {}
