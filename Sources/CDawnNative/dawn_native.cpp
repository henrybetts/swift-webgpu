extern "C" {
#include "dawn_native.h"
}
#include <dawn_native/DawnNative.h>

const DawnProcTable* dawnNativeGetProcs() {
    return &dawn_native::GetProcs();
}

DawnNativeInstance dawnNativeCreateInstance() {
    auto instance = new dawn_native::Instance();
    return reinterpret_cast<DawnNativeInstance>(instance);
}

WGPUInstance dawnNativeInstanceGetObject(DawnNativeInstance cInstance) {
    auto instance = reinterpret_cast<dawn_native::Instance*>(cInstance);
    return instance->Get();
}

void dawnNativeInstanceDiscoverDefaultAdapters(WGPUInstance cInstance) {
    auto instance = reinterpret_cast<dawn_native::Instance*>(cInstance);
    instance->DiscoverDefaultAdapters();
}

void dawnNativeInstanceEnumerateAdapters(WGPUInstance cInstance, size_t* adaptersCount, DawnNativeAdapter* cAdapters) {
    auto instance = reinterpret_cast<dawn_native::Instance*>(cInstance);
    auto adapters = instance->GetAdapters();
    if (cAdapters == NULL) {
        *adaptersCount = adapters.size();
    } else {
        size_t count = std::min(*adaptersCount, adapters.size());
        for (size_t i=0; i<count; i++) {
            auto adapter = new dawn_native::Adapter(adapters[i]);
            cAdapters[i] = reinterpret_cast<DawnNativeAdapter>(adapter);
        }
    }
}

void dawnNativeInstanceRelease(DawnNativeInstance cInstance) {
    auto instance = reinterpret_cast<dawn_native::Instance*>(cInstance);
    delete instance;
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
