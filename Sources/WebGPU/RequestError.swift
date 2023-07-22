public struct RequestError<Status: RawRepresentable>: Error {
    public let status: Status
    public let message: String?
}

extension RequestError: CustomStringConvertible {
    public var description: String {
        if let message = message {
            return "\(message) (\(status))"
        } else {
            return String(describing: status)
        }
    }
}
