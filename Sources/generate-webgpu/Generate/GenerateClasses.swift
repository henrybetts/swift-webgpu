func generateClasses(model: Model) -> String {
    return code {
        "import CWebGPU"
        ""
        
        for type in model.types(of: ObjectType.self) {
            block("public class \(type.swiftName)") {
                "private let handle: \(type.cName)"
                ""
                
                "/// Create a wrapper around an existing handle."
                "///"
                "/// The ownership of the handle is transferred to this class."
                "///"
                "/// - Parameter handle: The handle to wrap."
                block("public init(handle: \(type.cName)!)") {
                    "self.handle = handle"
                }
                ""
                
                block("deinit") {
                    "\(type.releaseMethodName)(handle)"
                }
                ""
                
                "/// Calls the given closure with the underlying handle."
                "///"
                "/// The underlying handle is guaranteed not to be released before the closure returns."
                "///"
                "/// - Parameter body: A closure to call with the underlying handle."
                block("public func withUnsafeHandle<R>(_ body: (\(type.cName)) throws -> R) rethrows -> R") {
                    block("return try withExtendedLifetime(self)") {
                        "return try body(handle)"
                    }
                }
            }
            ""
        }
    }
}
