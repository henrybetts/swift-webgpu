class Type: Taggable {
    let name: String
    let category: Category
    let tags: Set<String>
    
    init(name: String, data: TypeData) {
        self.name = name
        self.category = data.category
        self.tags = data.tags
    }
    
    func link(model: Model) {}
    
    var cName: String {
        return "WGPU" + name.pascalCased(preservingCasing: true)
    }
    
    var swiftName: String {
        return name.pascalCased()
    }
    
    func swiftValue(from value: Any) -> String {
        return String(describing: value)
    }
}


class NonconvertibleType: Type {
    override var swiftName: String {
        return cName
    }
}
