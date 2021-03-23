extern "C" {
#include "dawn_native.h"
}
#include <dawn_native/DawnNative.h>

const DawnProcTable* dawnNativeGetProcs() {
    return &dawn_native::GetProcs();
}
