import CWebGPU

extension Bool: ConvertibleFromC, ConvertibleToC {
  typealias CType = WGPUBool
  
  init(cValue: CType) {
    self = cValue != 0
  }
  
  var cValue: WGPUBool {
    return self ? 1 : 0
  }
}

extension Optional<Bool> {
    init(cValue: WGPUOptionalBool) {
        switch cValue {
        case WGPUOptionalBool_True:
            self = true
        case WGPUOptionalBool_False:
            self = false
        default:
            self = nil
        }
    }
    
    var cValue: WGPUOptionalBool {
        switch self {
        case .some(true):
            return WGPUOptionalBool_True
        case .some(false):
            return WGPUOptionalBool_False
        case nil:
            return WGPUOptionalBool_Undefined
        }
    }
}
