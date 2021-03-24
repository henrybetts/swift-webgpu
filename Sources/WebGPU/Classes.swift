import CWebGPU

public class BindGroup {
    let object: WGPUBindGroup!

    init(object: WGPUBindGroup!) {
        self.object = object
    }
}

public class BindGroupLayout {
    let object: WGPUBindGroupLayout!

    init(object: WGPUBindGroupLayout!) {
        self.object = object
    }
}

public class Buffer {
    let object: WGPUBuffer!

    init(object: WGPUBuffer!) {
        self.object = object
    }

    public func mapAsync(mode: MapMode, offset: Int, size: Int, callback: BufferMapCallback) {
        wgpuBufferMapAsync(
            self.object, 
            mode.rawValue, 
            offset, 
            size, 
            bufferMapCallback, 
            Unmanaged.passRetained(callback as AnyObject).toOpaque()
        )
    }

    public func getMappedRange(offset: Int, size: Int) -> UnsafeMutableRawPointer! {
        let result = wgpuBufferGetMappedRange(
            self.object, 
            offset, 
            size
        )
        return result
    }

    public func getConstMappedRange(offset: Int, size: Int) -> UnsafeRawPointer! {
        let result = wgpuBufferGetConstMappedRange(
            self.object, 
            offset, 
            size
        )
        return result
    }

    public func unmap() {
        wgpuBufferUnmap(
            self.object
        )
    }

    public func destroy() {
        wgpuBufferDestroy(
            self.object
        )
    }
}

public class CommandBuffer {
    let object: WGPUCommandBuffer!

    init(object: WGPUCommandBuffer!) {
        self.object = object
    }
}

public class CommandEncoder {
    let object: WGPUCommandEncoder!

    init(object: WGPUCommandEncoder!) {
        self.object = object
    }

    public func finish(descriptor: CommandBufferDescriptor? = nil) -> CommandBuffer {
        descriptor.withOptionalCStruct { cStruct_descriptor in
        let result = wgpuCommandEncoderFinish(
            self.object, 
            cStruct_descriptor
        )
        return .init(object: result)
        }
    }

    public func beginComputePass(descriptor: ComputePassDescriptor? = nil) -> ComputePassEncoder {
        descriptor.withOptionalCStruct { cStruct_descriptor in
        let result = wgpuCommandEncoderBeginComputePass(
            self.object, 
            cStruct_descriptor
        )
        return .init(object: result)
        }
    }

    public func beginRenderPass(descriptor: RenderPassDescriptor) -> RenderPassEncoder {
        descriptor.withCStruct { cStruct_descriptor in
        let result = wgpuCommandEncoderBeginRenderPass(
            self.object, 
            cStruct_descriptor
        )
        return .init(object: result)
        }
    }

    public func copyBufferToBuffer(source: Buffer, sourceOffset: UInt64, destination: Buffer, destinationOffset: UInt64, size: UInt64) {
        wgpuCommandEncoderCopyBufferToBuffer(
            self.object, 
            source.object, 
            sourceOffset, 
            destination.object, 
            destinationOffset, 
            size
        )
    }

    public func copyBufferToTexture(source: BufferCopyView, destination: TextureCopyView, copySize: Extent3d) {
        source.withCStruct { cStruct_source in
        destination.withCStruct { cStruct_destination in
        copySize.withCStruct { cStruct_copySize in
        wgpuCommandEncoderCopyBufferToTexture(
            self.object, 
            cStruct_source, 
            cStruct_destination, 
            cStruct_copySize
        )
        }
        }
        }
    }

    public func copyTextureToBuffer(source: TextureCopyView, destination: BufferCopyView, copySize: Extent3d) {
        source.withCStruct { cStruct_source in
        destination.withCStruct { cStruct_destination in
        copySize.withCStruct { cStruct_copySize in
        wgpuCommandEncoderCopyTextureToBuffer(
            self.object, 
            cStruct_source, 
            cStruct_destination, 
            cStruct_copySize
        )
        }
        }
        }
    }

    public func copyTextureToTexture(source: TextureCopyView, destination: TextureCopyView, copySize: Extent3d) {
        source.withCStruct { cStruct_source in
        destination.withCStruct { cStruct_destination in
        copySize.withCStruct { cStruct_copySize in
        wgpuCommandEncoderCopyTextureToTexture(
            self.object, 
            cStruct_source, 
            cStruct_destination, 
            cStruct_copySize
        )
        }
        }
        }
    }

    public func injectValidationError(message: String) {
        message.withCString { cString_message in
        wgpuCommandEncoderInjectValidationError(
            self.object, 
            cString_message
        )
        }
    }

    public func insertDebugMarker(markerLabel: String) {
        markerLabel.withCString { cString_markerLabel in
        wgpuCommandEncoderInsertDebugMarker(
            self.object, 
            cString_markerLabel
        )
        }
    }

    public func popDebugGroup() {
        wgpuCommandEncoderPopDebugGroup(
            self.object
        )
    }

    public func pushDebugGroup(groupLabel: String) {
        groupLabel.withCString { cString_groupLabel in
        wgpuCommandEncoderPushDebugGroup(
            self.object, 
            cString_groupLabel
        )
        }
    }

    public func resolveQuerySet(_ querySet: QuerySet, firstQuery: UInt32, queryCount: UInt32, destination: Buffer, destinationOffset: UInt64) {
        wgpuCommandEncoderResolveQuerySet(
            self.object, 
            querySet.object, 
            firstQuery, 
            queryCount, 
            destination.object, 
            destinationOffset
        )
    }

    public func writeTimestamp(querySet: QuerySet, queryIndex: UInt32) {
        wgpuCommandEncoderWriteTimestamp(
            self.object, 
            querySet.object, 
            queryIndex
        )
    }
}

public class ComputePassEncoder {
    let object: WGPUComputePassEncoder!

    init(object: WGPUComputePassEncoder!) {
        self.object = object
    }

    public func insertDebugMarker(markerLabel: String) {
        markerLabel.withCString { cString_markerLabel in
        wgpuComputePassEncoderInsertDebugMarker(
            self.object, 
            cString_markerLabel
        )
        }
    }

    public func popDebugGroup() {
        wgpuComputePassEncoderPopDebugGroup(
            self.object
        )
    }

    public func pushDebugGroup(groupLabel: String) {
        groupLabel.withCString { cString_groupLabel in
        wgpuComputePassEncoderPushDebugGroup(
            self.object, 
            cString_groupLabel
        )
        }
    }

    public func setPipeline(_ pipeline: ComputePipeline) {
        wgpuComputePassEncoderSetPipeline(
            self.object, 
            pipeline.object
        )
    }

    public func setBindGroup(groupIndex: UInt32, group: BindGroup, dynamicOffsets: [UInt32]? = nil) {
        dynamicOffsets.withOptionalUnsafeBufferPointer { buffer_dynamicOffsets in
        wgpuComputePassEncoderSetBindGroup(
            self.object, 
            groupIndex, 
            group.object, 
            .init(buffer_dynamicOffsets.count), 
            buffer_dynamicOffsets.baseAddress
        )
        }
    }

    public func writeTimestamp(querySet: QuerySet, queryIndex: UInt32) {
        wgpuComputePassEncoderWriteTimestamp(
            self.object, 
            querySet.object, 
            queryIndex
        )
    }

    public func dispatch(x: UInt32, y: UInt32 = 1, z: UInt32 = 1) {
        wgpuComputePassEncoderDispatch(
            self.object, 
            x, 
            y, 
            z
        )
    }

    public func dispatchIndirect(indirectBuffer: Buffer, indirectOffset: UInt64) {
        wgpuComputePassEncoderDispatchIndirect(
            self.object, 
            indirectBuffer.object, 
            indirectOffset
        )
    }

    public func endPass() {
        wgpuComputePassEncoderEndPass(
            self.object
        )
    }
}

public class ComputePipeline {
    let object: WGPUComputePipeline!

    init(object: WGPUComputePipeline!) {
        self.object = object
    }

    public func getBindGroupLayout(groupIndex: UInt32) -> BindGroupLayout {
        let result = wgpuComputePipelineGetBindGroupLayout(
            self.object, 
            groupIndex
        )
        return .init(object: result)
    }
}

public class Device {
    let object: WGPUDevice!

    init(object: WGPUDevice!) {
        self.object = object
    }

    public func createBindGroup(descriptor: BindGroupDescriptor) -> BindGroup {
        descriptor.withCStruct { cStruct_descriptor in
        let result = wgpuDeviceCreateBindGroup(
            self.object, 
            cStruct_descriptor
        )
        return .init(object: result)
        }
    }

    public func createBindGroupLayout(descriptor: BindGroupLayoutDescriptor) -> BindGroupLayout {
        descriptor.withCStruct { cStruct_descriptor in
        let result = wgpuDeviceCreateBindGroupLayout(
            self.object, 
            cStruct_descriptor
        )
        return .init(object: result)
        }
    }

    public func createBuffer(descriptor: BufferDescriptor) -> Buffer {
        descriptor.withCStruct { cStruct_descriptor in
        let result = wgpuDeviceCreateBuffer(
            self.object, 
            cStruct_descriptor
        )
        return .init(object: result)
        }
    }

    public func createErrorBuffer() -> Buffer {
        let result = wgpuDeviceCreateErrorBuffer(
            self.object
        )
        return .init(object: result)
    }

    public func createCommandEncoder(descriptor: CommandEncoderDescriptor? = nil) -> CommandEncoder {
        descriptor.withOptionalCStruct { cStruct_descriptor in
        let result = wgpuDeviceCreateCommandEncoder(
            self.object, 
            cStruct_descriptor
        )
        return .init(object: result)
        }
    }

    public func createComputePipeline(descriptor: ComputePipelineDescriptor) -> ComputePipeline {
        descriptor.withCStruct { cStruct_descriptor in
        let result = wgpuDeviceCreateComputePipeline(
            self.object, 
            cStruct_descriptor
        )
        return .init(object: result)
        }
    }

    public func createComputePipelineAsync(descriptor: ComputePipelineDescriptor, callback: CreateComputePipelineAsyncCallback) {
        descriptor.withCStruct { cStruct_descriptor in
        wgpuDeviceCreateComputePipelineAsync(
            self.object, 
            cStruct_descriptor, 
            createComputePipelineAsyncCallback, 
            Unmanaged.passRetained(callback as AnyObject).toOpaque()
        )
        }
    }

    public func createPipelineLayout(descriptor: PipelineLayoutDescriptor) -> PipelineLayout {
        descriptor.withCStruct { cStruct_descriptor in
        let result = wgpuDeviceCreatePipelineLayout(
            self.object, 
            cStruct_descriptor
        )
        return .init(object: result)
        }
    }

    public func createQuerySet(descriptor: QuerySetDescriptor) -> QuerySet {
        descriptor.withCStruct { cStruct_descriptor in
        let result = wgpuDeviceCreateQuerySet(
            self.object, 
            cStruct_descriptor
        )
        return .init(object: result)
        }
    }

    public func createRenderPipelineAsync(descriptor: RenderPipelineDescriptor, callback: CreateRenderPipelineAsyncCallback) {
        descriptor.withCStruct { cStruct_descriptor in
        wgpuDeviceCreateRenderPipelineAsync(
            self.object, 
            cStruct_descriptor, 
            createRenderPipelineAsyncCallback, 
            Unmanaged.passRetained(callback as AnyObject).toOpaque()
        )
        }
    }

    public func createRenderBundleEncoder(descriptor: RenderBundleEncoderDescriptor) -> RenderBundleEncoder {
        descriptor.withCStruct { cStruct_descriptor in
        let result = wgpuDeviceCreateRenderBundleEncoder(
            self.object, 
            cStruct_descriptor
        )
        return .init(object: result)
        }
    }

    public func createRenderPipeline(descriptor: RenderPipelineDescriptor) -> RenderPipeline {
        descriptor.withCStruct { cStruct_descriptor in
        let result = wgpuDeviceCreateRenderPipeline(
            self.object, 
            cStruct_descriptor
        )
        return .init(object: result)
        }
    }

    public func createSampler(descriptor: SamplerDescriptor? = nil) -> Sampler {
        descriptor.withOptionalCStruct { cStruct_descriptor in
        let result = wgpuDeviceCreateSampler(
            self.object, 
            cStruct_descriptor
        )
        return .init(object: result)
        }
    }

    public func createShaderModule(descriptor: ShaderModuleDescriptor) -> ShaderModule {
        descriptor.withCStruct { cStruct_descriptor in
        let result = wgpuDeviceCreateShaderModule(
            self.object, 
            cStruct_descriptor
        )
        return .init(object: result)
        }
    }

    public func createSwapChain(surface: Surface? = nil, descriptor: SwapChainDescriptor) -> SwapChain {
        descriptor.withCStruct { cStruct_descriptor in
        let result = wgpuDeviceCreateSwapChain(
            self.object, 
            surface?.object, 
            cStruct_descriptor
        )
        return .init(object: result)
        }
    }

    public func createTexture(descriptor: TextureDescriptor) -> Texture {
        descriptor.withCStruct { cStruct_descriptor in
        let result = wgpuDeviceCreateTexture(
            self.object, 
            cStruct_descriptor
        )
        return .init(object: result)
        }
    }

    public var queue: Queue {
        let result = wgpuDeviceGetQueue(
            self.object
        )
        return .init(object: result)
    }

    public var defaultQueue: Queue {
        let result = wgpuDeviceGetDefaultQueue(
            self.object
        )
        return .init(object: result)
    }

    public func injectError(type: ErrorType, message: String) {
        message.withCString { cString_message in
        wgpuDeviceInjectError(
            self.object, 
            type.cValue, 
            cString_message
        )
        }
    }

    public func loseForTesting() {
        wgpuDeviceLoseForTesting(
            self.object
        )
    }

    public func tick() {
        wgpuDeviceTick(
            self.object
        )
    }

    public func setUncapturedErrorCallback(_ callback: ErrorCallback) {
        wgpuDeviceSetUncapturedErrorCallback(
            self.object, 
            errorCallback, 
            Unmanaged.passRetained(callback as AnyObject).toOpaque()
        )
    }

    public func setDeviceLostCallback(_ callback: DeviceLostCallback) {
        wgpuDeviceSetDeviceLostCallback(
            self.object, 
            deviceLostCallback, 
            Unmanaged.passRetained(callback as AnyObject).toOpaque()
        )
    }

    public func pushErrorScope(filter: ErrorFilter) {
        wgpuDevicePushErrorScope(
            self.object, 
            filter.cValue
        )
    }

    public func popErrorScope(callback: ErrorCallback) -> Bool {
        let result = wgpuDevicePopErrorScope(
            self.object, 
            errorCallback, 
            Unmanaged.passRetained(callback as AnyObject).toOpaque()
        )
        return result
    }
}

public class Fence {
    let object: WGPUFence!

    init(object: WGPUFence!) {
        self.object = object
    }

    public var completedValue: UInt64 {
        let result = wgpuFenceGetCompletedValue(
            self.object
        )
        return result
    }

    public func onCompletion(value: UInt64, callback: FenceOnCompletionCallback) {
        wgpuFenceOnCompletion(
            self.object, 
            value, 
            fenceOnCompletionCallback, 
            Unmanaged.passRetained(callback as AnyObject).toOpaque()
        )
    }
}

public class Instance {
    let object: WGPUInstance!

    init(object: WGPUInstance!) {
        self.object = object
    }

    public func createSurface(descriptor: SurfaceDescriptor) -> Surface {
        descriptor.withCStruct { cStruct_descriptor in
        let result = wgpuInstanceCreateSurface(
            self.object, 
            cStruct_descriptor
        )
        return .init(object: result)
        }
    }
}

public class PipelineLayout {
    let object: WGPUPipelineLayout!

    init(object: WGPUPipelineLayout!) {
        self.object = object
    }
}

public class QuerySet {
    let object: WGPUQuerySet!

    init(object: WGPUQuerySet!) {
        self.object = object
    }

    public func destroy() {
        wgpuQuerySetDestroy(
            self.object
        )
    }
}

public class Queue {
    let object: WGPUQueue!

    init(object: WGPUQueue!) {
        self.object = object
    }

    public func submit(commands: [CommandBuffer]) {
        commands.map { $0.object }.withUnsafeBufferPointer { buffer_commands in 
        wgpuQueueSubmit(
            self.object, 
            .init(buffer_commands.count), 
            buffer_commands.baseAddress
        )
        }
    }

    public func signal(fence: Fence, signalValue: UInt64) {
        wgpuQueueSignal(
            self.object, 
            fence.object, 
            signalValue
        )
    }

    public func createFence(descriptor: FenceDescriptor? = nil) -> Fence {
        descriptor.withOptionalCStruct { cStruct_descriptor in
        let result = wgpuQueueCreateFence(
            self.object, 
            cStruct_descriptor
        )
        return .init(object: result)
        }
    }

    public func onSubmittedWorkDone(signalValue: UInt64, callback: QueueWorkDoneCallback) {
        wgpuQueueOnSubmittedWorkDone(
            self.object, 
            signalValue, 
            queueWorkDoneCallback, 
            Unmanaged.passRetained(callback as AnyObject).toOpaque()
        )
    }

    public func writeBuffer(_ buffer: Buffer, bufferOffset: UInt64, data: UnsafeRawBufferPointer) {
        wgpuQueueWriteBuffer(
            self.object, 
            buffer.object, 
            bufferOffset, 
            data.baseAddress, 
            .init(data.count)
        )
    }

    public func writeTexture(destination: TextureCopyView, data: UnsafeRawBufferPointer, dataLayout: TextureDataLayout, writeSize: Extent3d) {
        destination.withCStruct { cStruct_destination in
        dataLayout.withCStruct { cStruct_dataLayout in
        writeSize.withCStruct { cStruct_writeSize in
        wgpuQueueWriteTexture(
            self.object, 
            cStruct_destination, 
            data.baseAddress, 
            .init(data.count), 
            cStruct_dataLayout, 
            cStruct_writeSize
        )
        }
        }
        }
    }

    public func copyTextureForBrowser(source: TextureCopyView, destination: TextureCopyView, copySize: Extent3d, options: CopyTextureForBrowserOptions) {
        source.withCStruct { cStruct_source in
        destination.withCStruct { cStruct_destination in
        copySize.withCStruct { cStruct_copySize in
        options.withCStruct { cStruct_options in
        wgpuQueueCopyTextureForBrowser(
            self.object, 
            cStruct_source, 
            cStruct_destination, 
            cStruct_copySize, 
            cStruct_options
        )
        }
        }
        }
        }
    }
}

public class RenderBundle {
    let object: WGPURenderBundle!

    init(object: WGPURenderBundle!) {
        self.object = object
    }
}

public class RenderBundleEncoder {
    let object: WGPURenderBundleEncoder!

    init(object: WGPURenderBundleEncoder!) {
        self.object = object
    }

    public func setPipeline(_ pipeline: RenderPipeline) {
        wgpuRenderBundleEncoderSetPipeline(
            self.object, 
            pipeline.object
        )
    }

    public func setBindGroup(groupIndex: UInt32, group: BindGroup, dynamicOffsets: [UInt32]? = nil) {
        dynamicOffsets.withOptionalUnsafeBufferPointer { buffer_dynamicOffsets in
        wgpuRenderBundleEncoderSetBindGroup(
            self.object, 
            groupIndex, 
            group.object, 
            .init(buffer_dynamicOffsets.count), 
            buffer_dynamicOffsets.baseAddress
        )
        }
    }

    public func draw(vertexCount: UInt32, instanceCount: UInt32 = 1, firstVertex: UInt32 = 0, firstInstance: UInt32 = 0) {
        wgpuRenderBundleEncoderDraw(
            self.object, 
            vertexCount, 
            instanceCount, 
            firstVertex, 
            firstInstance
        )
    }

    public func drawIndexed(indexCount: UInt32, instanceCount: UInt32 = 1, firstIndex: UInt32 = 0, baseVertex: Int32 = 0, firstInstance: UInt32 = 0) {
        wgpuRenderBundleEncoderDrawIndexed(
            self.object, 
            indexCount, 
            instanceCount, 
            firstIndex, 
            baseVertex, 
            firstInstance
        )
    }

    public func drawIndirect(indirectBuffer: Buffer, indirectOffset: UInt64) {
        wgpuRenderBundleEncoderDrawIndirect(
            self.object, 
            indirectBuffer.object, 
            indirectOffset
        )
    }

    public func drawIndexedIndirect(indirectBuffer: Buffer, indirectOffset: UInt64) {
        wgpuRenderBundleEncoderDrawIndexedIndirect(
            self.object, 
            indirectBuffer.object, 
            indirectOffset
        )
    }

    public func insertDebugMarker(markerLabel: String) {
        markerLabel.withCString { cString_markerLabel in
        wgpuRenderBundleEncoderInsertDebugMarker(
            self.object, 
            cString_markerLabel
        )
        }
    }

    public func popDebugGroup() {
        wgpuRenderBundleEncoderPopDebugGroup(
            self.object
        )
    }

    public func pushDebugGroup(groupLabel: String) {
        groupLabel.withCString { cString_groupLabel in
        wgpuRenderBundleEncoderPushDebugGroup(
            self.object, 
            cString_groupLabel
        )
        }
    }

    public func setVertexBuffer(slot: UInt32, buffer: Buffer, offset: UInt64 = 0, size: UInt64 = 0) {
        wgpuRenderBundleEncoderSetVertexBuffer(
            self.object, 
            slot, 
            buffer.object, 
            offset, 
            size
        )
    }

    public func setIndexBuffer(_ buffer: Buffer, format: IndexFormat, offset: UInt64 = 0, size: UInt64 = 0) {
        wgpuRenderBundleEncoderSetIndexBuffer(
            self.object, 
            buffer.object, 
            format.cValue, 
            offset, 
            size
        )
    }

    public func setIndexBufferWithFormat(buffer: Buffer, format: IndexFormat, offset: UInt64 = 0, size: UInt64 = 0) {
        wgpuRenderBundleEncoderSetIndexBufferWithFormat(
            self.object, 
            buffer.object, 
            format.cValue, 
            offset, 
            size
        )
    }

    public func finish(descriptor: RenderBundleDescriptor? = nil) -> RenderBundle {
        descriptor.withOptionalCStruct { cStruct_descriptor in
        let result = wgpuRenderBundleEncoderFinish(
            self.object, 
            cStruct_descriptor
        )
        return .init(object: result)
        }
    }
}

public class RenderPassEncoder {
    let object: WGPURenderPassEncoder!

    init(object: WGPURenderPassEncoder!) {
        self.object = object
    }

    public func setPipeline(_ pipeline: RenderPipeline) {
        wgpuRenderPassEncoderSetPipeline(
            self.object, 
            pipeline.object
        )
    }

    public func setBindGroup(groupIndex: UInt32, group: BindGroup, dynamicOffsets: [UInt32]? = nil) {
        dynamicOffsets.withOptionalUnsafeBufferPointer { buffer_dynamicOffsets in
        wgpuRenderPassEncoderSetBindGroup(
            self.object, 
            groupIndex, 
            group.object, 
            .init(buffer_dynamicOffsets.count), 
            buffer_dynamicOffsets.baseAddress
        )
        }
    }

    public func draw(vertexCount: UInt32, instanceCount: UInt32 = 1, firstVertex: UInt32 = 0, firstInstance: UInt32 = 0) {
        wgpuRenderPassEncoderDraw(
            self.object, 
            vertexCount, 
            instanceCount, 
            firstVertex, 
            firstInstance
        )
    }

    public func drawIndexed(indexCount: UInt32, instanceCount: UInt32 = 1, firstIndex: UInt32 = 0, baseVertex: Int32 = 0, firstInstance: UInt32 = 0) {
        wgpuRenderPassEncoderDrawIndexed(
            self.object, 
            indexCount, 
            instanceCount, 
            firstIndex, 
            baseVertex, 
            firstInstance
        )
    }

    public func drawIndirect(indirectBuffer: Buffer, indirectOffset: UInt64) {
        wgpuRenderPassEncoderDrawIndirect(
            self.object, 
            indirectBuffer.object, 
            indirectOffset
        )
    }

    public func drawIndexedIndirect(indirectBuffer: Buffer, indirectOffset: UInt64) {
        wgpuRenderPassEncoderDrawIndexedIndirect(
            self.object, 
            indirectBuffer.object, 
            indirectOffset
        )
    }

    public func executeBundles(bundles: [RenderBundle]) {
        bundles.map { $0.object }.withUnsafeBufferPointer { buffer_bundles in 
        wgpuRenderPassEncoderExecuteBundles(
            self.object, 
            .init(buffer_bundles.count), 
            buffer_bundles.baseAddress
        )
        }
    }

    public func insertDebugMarker(markerLabel: String) {
        markerLabel.withCString { cString_markerLabel in
        wgpuRenderPassEncoderInsertDebugMarker(
            self.object, 
            cString_markerLabel
        )
        }
    }

    public func popDebugGroup() {
        wgpuRenderPassEncoderPopDebugGroup(
            self.object
        )
    }

    public func pushDebugGroup(groupLabel: String) {
        groupLabel.withCString { cString_groupLabel in
        wgpuRenderPassEncoderPushDebugGroup(
            self.object, 
            cString_groupLabel
        )
        }
    }

    public func setStencilReference(_ reference: UInt32) {
        wgpuRenderPassEncoderSetStencilReference(
            self.object, 
            reference
        )
    }

    public func setBlendColor(_ color: Color) {
        color.withCStruct { cStruct_color in
        wgpuRenderPassEncoderSetBlendColor(
            self.object, 
            cStruct_color
        )
        }
    }

    public func setViewport(x: Float, y: Float, width: Float, height: Float, minDepth: Float, maxDepth: Float) {
        wgpuRenderPassEncoderSetViewport(
            self.object, 
            x, 
            y, 
            width, 
            height, 
            minDepth, 
            maxDepth
        )
    }

    public func setScissorRect(x: UInt32, y: UInt32, width: UInt32, height: UInt32) {
        wgpuRenderPassEncoderSetScissorRect(
            self.object, 
            x, 
            y, 
            width, 
            height
        )
    }

    public func setVertexBuffer(slot: UInt32, buffer: Buffer, offset: UInt64 = 0, size: UInt64 = 0) {
        wgpuRenderPassEncoderSetVertexBuffer(
            self.object, 
            slot, 
            buffer.object, 
            offset, 
            size
        )
    }

    public func setIndexBuffer(_ buffer: Buffer, format: IndexFormat, offset: UInt64 = 0, size: UInt64 = 0) {
        wgpuRenderPassEncoderSetIndexBuffer(
            self.object, 
            buffer.object, 
            format.cValue, 
            offset, 
            size
        )
    }

    public func setIndexBufferWithFormat(buffer: Buffer, format: IndexFormat, offset: UInt64 = 0, size: UInt64 = 0) {
        wgpuRenderPassEncoderSetIndexBufferWithFormat(
            self.object, 
            buffer.object, 
            format.cValue, 
            offset, 
            size
        )
    }

    public func beginOcclusionQuery(queryIndex: UInt32) {
        wgpuRenderPassEncoderBeginOcclusionQuery(
            self.object, 
            queryIndex
        )
    }

    public func endOcclusionQuery() {
        wgpuRenderPassEncoderEndOcclusionQuery(
            self.object
        )
    }

    public func writeTimestamp(querySet: QuerySet, queryIndex: UInt32) {
        wgpuRenderPassEncoderWriteTimestamp(
            self.object, 
            querySet.object, 
            queryIndex
        )
    }

    public func endPass() {
        wgpuRenderPassEncoderEndPass(
            self.object
        )
    }
}

public class RenderPipeline {
    let object: WGPURenderPipeline!

    init(object: WGPURenderPipeline!) {
        self.object = object
    }

    public func getBindGroupLayout(groupIndex: UInt32) -> BindGroupLayout {
        let result = wgpuRenderPipelineGetBindGroupLayout(
            self.object, 
            groupIndex
        )
        return .init(object: result)
    }
}

public class Sampler {
    let object: WGPUSampler!

    init(object: WGPUSampler!) {
        self.object = object
    }
}

public class ShaderModule {
    let object: WGPUShaderModule!

    init(object: WGPUShaderModule!) {
        self.object = object
    }
}

public class Surface {
    let object: WGPUSurface!

    init(object: WGPUSurface!) {
        self.object = object
    }
}

public class SwapChain {
    let object: WGPUSwapChain!

    init(object: WGPUSwapChain!) {
        self.object = object
    }

    public func configure(format: TextureFormat, allowedUsage: TextureUsage, width: UInt32, height: UInt32) {
        wgpuSwapChainConfigure(
            self.object, 
            format.cValue, 
            allowedUsage.rawValue, 
            width, 
            height
        )
    }

    public var currentTextureView: TextureView {
        let result = wgpuSwapChainGetCurrentTextureView(
            self.object
        )
        return .init(object: result)
    }

    public func present() {
        wgpuSwapChainPresent(
            self.object
        )
    }
}

public class Texture {
    let object: WGPUTexture!

    init(object: WGPUTexture!) {
        self.object = object
    }

    public func createView(descriptor: TextureViewDescriptor? = nil) -> TextureView {
        descriptor.withOptionalCStruct { cStruct_descriptor in
        let result = wgpuTextureCreateView(
            self.object, 
            cStruct_descriptor
        )
        return .init(object: result)
        }
    }

    public func destroy() {
        wgpuTextureDestroy(
            self.object
        )
    }
}

public class TextureView {
    let object: WGPUTextureView!

    init(object: WGPUTextureView!) {
        self.object = object
    }
}

