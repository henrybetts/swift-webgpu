#include <dawn/webgpu.h>

typedef struct DawnNativeInstanceImpl* DawnNativeInstance;
typedef struct DawnNativeAdapterImpl* DawnNativeAdapter;

typedef struct DawnProcTable DawnProcTable;
const DawnProcTable* dawnNativeGetProcs();

DawnNativeInstance dawnNativeCreateInstance();
WGPUInstance dawnNativeInstanceGet(DawnNativeInstance instance);
void dawnNativeInstanceDiscoverDefaultAdapters(DawnNativeInstance instance);
void dawnNativeInstanceEnumerateAdapters(DawnNativeInstance instance, size_t* adaptersCount, DawnNativeAdapter* adapters);
void dawnNativeInstanceRelease(DawnNativeInstance instance);

WGPUAdapter dawnNativeAdapterGet(DawnNativeAdapter adapter);
void dawnNativeAdapterGetProperties(DawnNativeAdapter adapter, WGPUAdapterProperties* properties);
WGPUDevice dawnNativeAdapterCreateDevice(DawnNativeInstance adapter);
void dawnNativeAdapterRelease(DawnNativeAdapter adapter);

