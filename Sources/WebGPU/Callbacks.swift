import CWebGPU

public typealias BufferMapCallback = (BufferMapAsyncStatus) -> ()

func bufferMapCallback(status: WGPUBufferMapAsyncStatus, userdata: UnsafeMutableRawPointer!) {
    let swiftCallback = UserData<BufferMapCallback>.takeValue(userdata)
    swiftCallback(
        .init(cValue: status)
    )
}

public typealias CompilationInfoCallback = (CompilationInfoRequestStatus, CompilationInfo) -> ()

func compilationInfoCallback(status: WGPUCompilationInfoRequestStatus, compilationInfo: UnsafePointer<WGPUCompilationInfo>!, userdata: UnsafeMutableRawPointer!) {
    let swiftCallback = UserData<CompilationInfoCallback>.takeValue(userdata)
    swiftCallback(
        .init(cValue: status), 
        .init(cStruct: compilationInfo.pointee)
    )
}

public typealias CreateComputePipelineAsyncCallback = (CreatePipelineAsyncStatus, ComputePipeline, String) -> ()

func createComputePipelineAsyncCallback(status: WGPUCreatePipelineAsyncStatus, pipeline: WGPUComputePipeline!, message: UnsafePointer<CChar>!, userdata: UnsafeMutableRawPointer!) {
    let swiftCallback = UserData<CreateComputePipelineAsyncCallback>.takeValue(userdata)
    swiftCallback(
        .init(cValue: status), 
        .init(handle: pipeline), 
        String(cString: message)
    )
}

public typealias CreateRenderPipelineAsyncCallback = (CreatePipelineAsyncStatus, RenderPipeline, String) -> ()

func createRenderPipelineAsyncCallback(status: WGPUCreatePipelineAsyncStatus, pipeline: WGPURenderPipeline!, message: UnsafePointer<CChar>!, userdata: UnsafeMutableRawPointer!) {
    let swiftCallback = UserData<CreateRenderPipelineAsyncCallback>.takeValue(userdata)
    swiftCallback(
        .init(cValue: status), 
        .init(handle: pipeline), 
        String(cString: message)
    )
}

public typealias DeviceLostCallback = (String) -> ()

func deviceLostCallback(message: UnsafePointer<CChar>!, userdata: UnsafeMutableRawPointer!) {
    let swiftCallback = UserData<DeviceLostCallback>.takeValue(userdata)
    swiftCallback(
        String(cString: message)
    )
}

public typealias ErrorCallback = (ErrorType, String) -> ()

func errorCallback(type: WGPUErrorType, message: UnsafePointer<CChar>!, userdata: UnsafeMutableRawPointer!) {
    let swiftCallback = UserData<ErrorCallback>.takeValue(userdata)
    swiftCallback(
        .init(cValue: type), 
        String(cString: message)
    )
}

public typealias LoggingCallback = (LoggingType, String) -> ()

func loggingCallback(type: WGPULoggingType, message: UnsafePointer<CChar>!, userdata: UnsafeMutableRawPointer!) {
    let swiftCallback = UserData<LoggingCallback>.takeValue(userdata)
    swiftCallback(
        .init(cValue: type), 
        String(cString: message)
    )
}

public typealias QueueWorkDoneCallback = (QueueWorkDoneStatus) -> ()

func queueWorkDoneCallback(status: WGPUQueueWorkDoneStatus, userdata: UnsafeMutableRawPointer!) {
    let swiftCallback = UserData<QueueWorkDoneCallback>.takeValue(userdata)
    swiftCallback(
        .init(cValue: status)
    )
}

