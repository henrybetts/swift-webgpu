import CWebGPU

public typealias Proc = () -> ()

public typealias RequestAdapterCallback = (RequestAdapterStatus, Adapter, String?) -> ()

public typealias BufferMapCallback = (BufferMapAsyncStatus) -> ()

public typealias CompilationInfoCallback = (CompilationInfoRequestStatus, CompilationInfo) -> ()

public typealias CreateComputePipelineAsyncCallback = (CreatePipelineAsyncStatus, ComputePipeline, String) -> ()

public typealias CreateRenderPipelineAsyncCallback = (CreatePipelineAsyncStatus, RenderPipeline, String) -> ()

public typealias DeviceLostCallback = (DeviceLostReason, String) -> ()

public typealias ErrorCallback = (ErrorType, String) -> ()

public typealias QueueWorkDoneCallback = (QueueWorkDoneStatus) -> ()

public typealias RequestDeviceCallback = (RequestDeviceStatus, Device, String?) -> ()

