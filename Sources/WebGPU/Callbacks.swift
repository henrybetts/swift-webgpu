import CWebGPU

public typealias BufferMapCallback = (BufferMapAsyncStatus) -> ()

func bufferMapCallback(status: WGPUBufferMapAsyncStatus, userdata: UnsafeMutableRawPointer!) {
    let swiftCallback = Unmanaged<AnyObject>.fromOpaque(userdata).takeRetainedValue() as! BufferMapCallback
    swiftCallback(
        .init(cValue: status)
    )
}

public typealias CreateComputePipelineAsyncCallback = (CreatePipelineAsyncStatus, ComputePipeline, String) -> ()

func createComputePipelineAsyncCallback(status: WGPUCreatePipelineAsyncStatus, pipeline: WGPUComputePipeline!, message: UnsafePointer<CChar>!, userdata: UnsafeMutableRawPointer!) {
    let swiftCallback = Unmanaged<AnyObject>.fromOpaque(userdata).takeRetainedValue() as! CreateComputePipelineAsyncCallback
    swiftCallback(
        .init(cValue: status), 
        .init(object: pipeline), 
        String(cString: message)
    )
}

public typealias CreateRenderPipelineAsyncCallback = (CreatePipelineAsyncStatus, RenderPipeline, String) -> ()

func createRenderPipelineAsyncCallback(status: WGPUCreatePipelineAsyncStatus, pipeline: WGPURenderPipeline!, message: UnsafePointer<CChar>!, userdata: UnsafeMutableRawPointer!) {
    let swiftCallback = Unmanaged<AnyObject>.fromOpaque(userdata).takeRetainedValue() as! CreateRenderPipelineAsyncCallback
    swiftCallback(
        .init(cValue: status), 
        .init(object: pipeline), 
        String(cString: message)
    )
}

public typealias DeviceLostCallback = (String) -> ()

func deviceLostCallback(message: UnsafePointer<CChar>!, userdata: UnsafeMutableRawPointer!) {
    let swiftCallback = Unmanaged<AnyObject>.fromOpaque(userdata).takeRetainedValue() as! DeviceLostCallback
    swiftCallback(
        String(cString: message)
    )
}

public typealias ErrorCallback = (ErrorType, String) -> ()

func errorCallback(type: WGPUErrorType, message: UnsafePointer<CChar>!, userdata: UnsafeMutableRawPointer!) {
    let swiftCallback = Unmanaged<AnyObject>.fromOpaque(userdata).takeRetainedValue() as! ErrorCallback
    swiftCallback(
        .init(cValue: type), 
        String(cString: message)
    )
}

public typealias FenceOnCompletionCallback = (FenceCompletionStatus) -> ()

func fenceOnCompletionCallback(status: WGPUFenceCompletionStatus, userdata: UnsafeMutableRawPointer!) {
    let swiftCallback = Unmanaged<AnyObject>.fromOpaque(userdata).takeRetainedValue() as! FenceOnCompletionCallback
    swiftCallback(
        .init(cValue: status)
    )
}

public typealias QueueWorkDoneCallback = (QueueWorkDoneStatus) -> ()

func queueWorkDoneCallback(status: WGPUQueueWorkDoneStatus, userdata: UnsafeMutableRawPointer!) {
    let swiftCallback = Unmanaged<AnyObject>.fromOpaque(userdata).takeRetainedValue() as! QueueWorkDoneCallback
    swiftCallback(
        .init(cValue: status)
    )
}

