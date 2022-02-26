import CWebGPU

func requestAdapterCallback(status: WGPURequestAdapterStatus, adapter: WGPUAdapter!, message: UnsafePointer<CChar>!, userdata: UnsafeMutableRawPointer!) {
    let swiftCallback = UserData<RequestAdapterCallback>.takeValue(userdata)
    swiftCallback(
        .init(cValue: status), 
        .init(handle: adapter), 
        message != nil ? String(cString: message) : nil
    )
}

func bufferMapCallback(status: WGPUBufferMapAsyncStatus, userdata: UnsafeMutableRawPointer!) {
    let swiftCallback = UserData<BufferMapCallback>.takeValue(userdata)
    swiftCallback(
        .init(cValue: status)
    )
}

func compilationInfoCallback(status: WGPUCompilationInfoRequestStatus, compilationInfo: UnsafePointer<WGPUCompilationInfo>!, userdata: UnsafeMutableRawPointer!) {
    let swiftCallback = UserData<CompilationInfoCallback>.takeValue(userdata)
    swiftCallback(
        .init(cValue: status), 
        .init(cStruct: compilationInfo.pointee)
    )
}

func createComputePipelineAsyncCallback(status: WGPUCreatePipelineAsyncStatus, pipeline: WGPUComputePipeline!, message: UnsafePointer<CChar>!, userdata: UnsafeMutableRawPointer!) {
    let swiftCallback = UserData<CreateComputePipelineAsyncCallback>.takeValue(userdata)
    swiftCallback(
        .init(cValue: status), 
        .init(handle: pipeline), 
        String(cString: message)
    )
}

func createRenderPipelineAsyncCallback(status: WGPUCreatePipelineAsyncStatus, pipeline: WGPURenderPipeline!, message: UnsafePointer<CChar>!, userdata: UnsafeMutableRawPointer!) {
    let swiftCallback = UserData<CreateRenderPipelineAsyncCallback>.takeValue(userdata)
    swiftCallback(
        .init(cValue: status), 
        .init(handle: pipeline), 
        String(cString: message)
    )
}

func deviceLostCallback(reason: WGPUDeviceLostReason, message: UnsafePointer<CChar>!, userdata: UnsafeMutableRawPointer!) {
    let swiftCallback = UserData<DeviceLostCallback>.takeValue(userdata)
    swiftCallback(
        .init(cValue: reason), 
        String(cString: message)
    )
}

func errorCallback(type: WGPUErrorType, message: UnsafePointer<CChar>!, userdata: UnsafeMutableRawPointer!) {
    let swiftCallback = UserData<ErrorCallback>.takeValue(userdata)
    swiftCallback(
        .init(cValue: type), 
        String(cString: message)
    )
}

func queueWorkDoneCallback(status: WGPUQueueWorkDoneStatus, userdata: UnsafeMutableRawPointer!) {
    let swiftCallback = UserData<QueueWorkDoneCallback>.takeValue(userdata)
    swiftCallback(
        .init(cValue: status)
    )
}

func requestDeviceCallback(status: WGPURequestDeviceStatus, device: WGPUDevice!, message: UnsafePointer<CChar>!, userdata: UnsafeMutableRawPointer!) {
    let swiftCallback = UserData<RequestDeviceCallback>.takeValue(userdata)
    swiftCallback(
        .init(cValue: status), 
        .init(handle: device), 
        message != nil ? String(cString: message) : nil
    )
}

