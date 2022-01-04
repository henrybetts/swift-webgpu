#include <dawn/webgpu.h>

typedef struct DawnNativeInstanceImpl* DawnNativeInstance;
typedef struct DawnNativeAdapterImpl* DawnNativeAdapter;

typedef struct DawnProcTable DawnProcTable;
const DawnProcTable* dawnNativeGetProcs();

DawnNativeInstance dawnNativeCreateInstance();
WGPUInstance dawnNativeInstanceGetObject(DawnNativeInstance instance);
void dawnNativeInstanceDiscoverDefaultAdapters(WGPUInstance instance);
void dawnNativeInstanceEnumerateAdapters(WGPUInstance instance, size_t* adaptersCount, DawnNativeAdapter* adapters);
void dawnNativeInstanceRelease(DawnNativeInstance instance);


void dawnNativeAdapterGetProperties(DawnNativeAdapter adapter, WGPUAdapterProperties* properties);
WGPUDevice dawnNativeAdapterCreateDevice(DawnNativeInstance adapter);
void dawnNativeAdapterRelease(DawnNativeAdapter adapter);

