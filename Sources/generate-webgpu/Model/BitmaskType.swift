class BitmaskType: EnumType {
    var cEnumName: String {
        return super.cName
    }
    
    override var cName: String {
        return cEnumName + "Flags"
    }
}
