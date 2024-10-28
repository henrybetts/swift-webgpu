extern "C" {
#include "dawn_native.h"
}
#include <dawn/native/DawnNative.h>

const DawnProcTable* dawnNativeGetProcs() {
    return &dawn::native::GetProcs();
}

DawnNativeInstance dawnNativeCreateInstance() {
    auto instance = new dawn::native::Instance();
    return reinterpret_cast<DawnNativeInstance>(instance);
}

WGPUInstance dawnNativeInstanceGet(DawnNativeInstance cInstance) {
    auto instance = reinterpret_cast<dawn::native::Instance*>(cInstance);
    return instance->Get();
}

void dawnNativeInstanceEnumerateAdapters(DawnNativeInstance cInstance, size_t* adaptersCount, DawnNativeAdapter* cAdapters) {
    auto instance = reinterpret_cast<dawn::native::Instance*>(cInstance);
    auto adapters = instance->EnumerateAdapters();
    if (cAdapters == NULL) {
        *adaptersCount = adapters.size();
    } else {
        size_t count = std::min(*adaptersCount, adapters.size());
        for (size_t i=0; i<count; i++) {
            auto adapter = new dawn::native::Adapter(adapters[i]);
            cAdapters[i] = reinterpret_cast<DawnNativeAdapter>(adapter);
        }
        *adaptersCount = count;
    }
}

void dawnNativeInstanceRelease(DawnNativeInstance cInstance) {
    auto instance = reinterpret_cast<dawn::native::Instance*>(cInstance);
    delete instance;
}

WGPUAdapter dawnNativeAdapterGet(DawnNativeAdapter cAdapter) {
    auto adapter = reinterpret_cast<dawn::native::Adapter*>(cAdapter);
    return adapter->Get();
}

WGPUStatus dawnNativeAdapterGetInfo(DawnNativeAdapter cAdapter, WGPUAdapterInfo* info) {
    auto adapter = reinterpret_cast<dawn::native::Adapter*>(cAdapter);
    return WGPUStatus(adapter->GetInfo(info));
}

WGPUDevice dawnNativeAdapterCreateDevice(DawnNativeInstance cAdapter) {
    auto adapter = reinterpret_cast<dawn::native::Adapter*>(cAdapter);
    return adapter->CreateDevice();
}

void dawnNativeAdapterRelease(DawnNativeAdapter cAdapter) {
    auto adapter = reinterpret_cast<dawn::native::Adapter*>(cAdapter);
    delete adapter;
}
