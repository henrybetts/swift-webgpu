extension Optional<Float> {
    init(cValue: Float) {
        if cValue.isNaN {
            self = nil
        } else {
            self = cValue
        }
    }
    
    var cValue: Float {
        return self ?? .nan
    }
}
