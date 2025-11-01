// generates the Swift classes that wrap WebGPU objects.
func generateObjects(model: WebGPUModel) -> String {
    return code {
        "import CWebGPU"
        ""
        
        for type in model.types(of: ObjectType.self) {
            block("public class \(type.swiftName): ConvertibleFromC, ConvertibleToCWithClosure") {
                "typealias CType = \(type.cName)?"
                ""
                
                "private let _object: \(type.cName)"
                ""
                
                "/// Create a wrapper around an existing WebGPU object."
                "///"
                "/// The ownership of the object is transferred to this class."
                "///"
                "/// - Parameter object: The object to wrap."
                block("public init(object: \(type.cName))") {
                    "self._object = object"
                }
                ""
                
                block("required convenience init(cValue: \(type.cName)?)") {
                    "self.init(object: cValue!)"
                }
                ""
                
                block("deinit") {
                    "\(type.releaseFunctionName)(_object)"
                }
                ""
                
                "/// Calls the given closure with the underlying WebGPU object."
                "///"
                "/// The underlying object is guaranteed not to be released before the closure returns."
                "///"
                "/// - Parameter body: A closure to call with the underlying object."
                block("public func withUnsafeObject<R>(_ body: (\(type.cName)) throws -> R) rethrows -> R") {
                    block("return try withExtendedLifetime(self)") {
                        "return try body(_object)"
                    }
                }
                ""
                
                block("func withCValue<R>(_ body: (\(type.cName)?) throws -> R) rethrows -> R") {
                    "return try withUnsafeObject(body)"
                }

                for method in type.methods {
                    ""
                    generateFunction(method)
                }
            }
            ""
        }
    }
}
