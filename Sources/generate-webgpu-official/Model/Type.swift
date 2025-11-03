/// A base class for all types in the WebGPU model.
class Type {
    let name: String
    
    init(name: String) {
        self.name = name
    }

    func link(model: WebGPUModel) {}
    
    var cName: String {
        return "WGPU" + name.pascalCased(preservingCasing: true)
    }
    
    var swiftName: String {
        return name.pascalCased()
    }
    
    func swiftValue(from value: String) -> String? {
        return nil
    }
}
