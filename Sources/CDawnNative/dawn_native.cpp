extern "C" {
#include "dawn_native.h"
}
#include <dawn/native/DawnNative.h>

const DawnProcTable* dawnNativeGetProcs() {
    return &dawn_native::GetProcs();
}

DawnNativeInstance dawnNativeCreateInstance() {
    auto instance = new dawn_native::Instance();
    return reinterpret_cast<DawnNativeInstance>(instance);
}

WGPUInstance dawnNativeInstanceGet(DawnNativeInstance cInstance) {
    auto instance = reinterpret_cast<dawn_native::Instance*>(cInstance);
    return instance->Get();
}

void dawnNativeInstanceEnumerateAdapters(DawnNativeInstance cInstance, size_t* adaptersCount, DawnNativeAdapter* cAdapters) {
    auto instance = reinterpret_cast<dawn_native::Instance*>(cInstance);
    auto adapters = instance->EnumerateAdapters();
    if (cAdapters == NULL) {
        *adaptersCount = adapters.size();
    } else {
        size_t count = std::min(*adaptersCount, adapters.size());
        for (size_t i=0; i<count; i++) {
            auto adapter = new dawn_native::Adapter(adapters[i]);
            cAdapters[i] = reinterpret_cast<DawnNativeAdapter>(adapter);
        }
        *adaptersCount = count;
    }
}

void dawnNativeInstanceRelease(DawnNativeInstance cInstance) {
    auto instance = reinterpret_cast<dawn_native::Instance*>(cInstance);
    delete instance;
}

WGPUAdapter dawnNativeAdapterGet(DawnNativeAdapter cAdapter) {
    auto adapter = reinterpret_cast<dawn_native::Adapter*>(cAdapter);
    return adapter->Get();
}

void dawnNativeAdapterGetProperties(DawnNativeAdapter cAdapter, WGPUAdapterProperties* properties) {
    auto adapter = reinterpret_cast<dawn_native::Adapter*>(cAdapter);
    adapter->GetProperties(reinterpret_cast<wgpu::AdapterProperties*>(properties));
}

WGPUDevice dawnNativeAdapterCreateDevice(DawnNativeInstance cAdapter) {
    auto adapter = reinterpret_cast<dawn_native::Adapter*>(cAdapter);
    return adapter->CreateDevice();
}

void dawnNativeAdapterRelease(DawnNativeAdapter cAdapter) {
    auto adapter = reinterpret_cast<dawn_native::Adapter*>(cAdapter);
    delete adapter;
}
