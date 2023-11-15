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
