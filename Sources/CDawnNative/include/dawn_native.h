#include <dawn/webgpu.h>
#include <dawn/dawn_proc_table.h>

typedef struct DawnNativeInstanceImpl* DawnNativeInstance;
typedef struct DawnNativeAdapterImpl* DawnNativeAdapter;

const DawnProcTable* dawnNativeGetProcs();

DawnNativeInstance dawnNativeCreateInstance();
WGPUInstance dawnNativeInstanceGet(DawnNativeInstance instance);
void dawnNativeInstanceEnumerateAdapters(DawnNativeInstance instance, size_t* adaptersCount, DawnNativeAdapter* adapters);
void dawnNativeInstanceRelease(DawnNativeInstance instance);

WGPUAdapter dawnNativeAdapterGet(DawnNativeAdapter adapter);
void dawnNativeAdapterGetProperties(DawnNativeAdapter adapter, WGPUAdapterProperties* properties);
WGPUDevice dawnNativeAdapterCreateDevice(DawnNativeInstance adapter);
void dawnNativeAdapterRelease(DawnNativeAdapter adapter);

