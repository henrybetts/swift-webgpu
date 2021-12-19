import CWebGPU

public class Adapter: Object {
    private let handle: WGPUAdapter!

    /// Create a wrapper around an existing handle.
    ///
    /// The ownership of the handle is transferred to this class.
    ///
    /// - Parameter handle: The handle to wrap.
    public init(handle: WGPUAdapter!) {
        self.handle = handle
    }

    deinit {
        wgpuAdapterRelease(self.handle)
    }

    /// Calls the given closure with the underlying handle.
    ///
    /// The underlying handle is guaranteed not to be released before the closure returns.
    ///
    /// - Parameter body: A closure to call with the underlying handle.
    public func withUnsafeHandle<R>(_ body: (WGPUAdapter) throws -> R) rethrows -> R {
        return try withExtendedLifetime(self) {
            return try body(self.handle)
        }
    }

    public func getLimits(_ limits: UnsafeMutablePointer<WGPUSupportedLimits>!) -> Bool {
        self.withUnsafeHandle { handle_self in
            let result = wgpuAdapterGetLimits(
                handle_self, 
                limits
            )
            return result
        }
    }

    public func getProperties(_ properties: UnsafeMutablePointer<WGPUAdapterProperties>!) {
        self.withUnsafeHandle { handle_self in
            wgpuAdapterGetProperties(
                handle_self, 
                properties
            )
        }
    }

    public func hasFeature(_ feature: FeatureName) -> Bool {
        self.withUnsafeHandle { handle_self in
            let result = wgpuAdapterHasFeature(
                handle_self, 
                feature.cValue
            )
            return result
        }
    }

    public func enumerateFeatures(_ features: UnsafeMutablePointer<WGPUFeatureName>!) -> UInt32 {
        self.withUnsafeHandle { handle_self in
            let result = wgpuAdapterEnumerateFeatures(
                handle_self, 
                features.cValue
            )
            return result
        }
    }

    public func requestDevice(descriptor: DeviceDescriptor, callback: @escaping RequestDeviceCallback) {
        self.withUnsafeHandle { handle_self in
            descriptor.withCStruct { cStruct_descriptor in
            wgpuAdapterRequestDevice(
                handle_self, 
                cStruct_descriptor, 
                requestDeviceCallback, 
                UserData.passRetained(callback)
            )
            }
        }
    }
}

public class BindGroup: Object {
    private let handle: WGPUBindGroup!

    /// Create a wrapper around an existing handle.
    ///
    /// The ownership of the handle is transferred to this class.
    ///
    /// - Parameter handle: The handle to wrap.
    public init(handle: WGPUBindGroup!) {
        self.handle = handle
    }

    deinit {
        wgpuBindGroupRelease(self.handle)
    }

    /// Calls the given closure with the underlying handle.
    ///
    /// The underlying handle is guaranteed not to be released before the closure returns.
    ///
    /// - Parameter body: A closure to call with the underlying handle.
    public func withUnsafeHandle<R>(_ body: (WGPUBindGroup) throws -> R) rethrows -> R {
        return try withExtendedLifetime(self) {
            return try body(self.handle)
        }
    }

    public func setLabel(_ label: String) {
        self.withUnsafeHandle { handle_self in
            label.withCString { cString_label in
            wgpuBindGroupSetLabel(
                handle_self, 
                cString_label
            )
            }
        }
    }
}

public class BindGroupLayout: Object {
    private let handle: WGPUBindGroupLayout!

    /// Create a wrapper around an existing handle.
    ///
    /// The ownership of the handle is transferred to this class.
    ///
    /// - Parameter handle: The handle to wrap.
    public init(handle: WGPUBindGroupLayout!) {
        self.handle = handle
    }

    deinit {
        wgpuBindGroupLayoutRelease(self.handle)
    }

    /// Calls the given closure with the underlying handle.
    ///
    /// The underlying handle is guaranteed not to be released before the closure returns.
    ///
    /// - Parameter body: A closure to call with the underlying handle.
    public func withUnsafeHandle<R>(_ body: (WGPUBindGroupLayout) throws -> R) rethrows -> R {
        return try withExtendedLifetime(self) {
            return try body(self.handle)
        }
    }

    public func setLabel(_ label: String) {
        self.withUnsafeHandle { handle_self in
            label.withCString { cString_label in
            wgpuBindGroupLayoutSetLabel(
                handle_self, 
                cString_label
            )
            }
        }
    }
}

public class Buffer: Object {
    private let handle: WGPUBuffer!

    /// Create a wrapper around an existing handle.
    ///
    /// The ownership of the handle is transferred to this class.
    ///
    /// - Parameter handle: The handle to wrap.
    public init(handle: WGPUBuffer!) {
        self.handle = handle
    }

    deinit {
        wgpuBufferRelease(self.handle)
    }

    /// Calls the given closure with the underlying handle.
    ///
    /// The underlying handle is guaranteed not to be released before the closure returns.
    ///
    /// - Parameter body: A closure to call with the underlying handle.
    public func withUnsafeHandle<R>(_ body: (WGPUBuffer) throws -> R) rethrows -> R {
        return try withExtendedLifetime(self) {
            return try body(self.handle)
        }
    }

    public func mapAsync(mode: MapMode, offset: Int, size: Int, callback: @escaping BufferMapCallback) {
        self.withUnsafeHandle { handle_self in
            wgpuBufferMapAsync(
                handle_self, 
                mode.rawValue, 
                offset, 
                size, 
                bufferMapCallback, 
                UserData.passRetained(callback)
            )
        }
    }

    public func getMappedRange(offset: Int, size: Int) -> UnsafeMutableRawPointer! {
        self.withUnsafeHandle { handle_self in
            let result = wgpuBufferGetMappedRange(
                handle_self, 
                offset, 
                size
            )
            return result
        }
    }

    public func getConstMappedRange(offset: Int, size: Int) -> UnsafeRawPointer! {
        self.withUnsafeHandle { handle_self in
            let result = wgpuBufferGetConstMappedRange(
                handle_self, 
                offset, 
                size
            )
            return result
        }
    }

    public func setLabel(_ label: String) {
        self.withUnsafeHandle { handle_self in
            label.withCString { cString_label in
            wgpuBufferSetLabel(
                handle_self, 
                cString_label
            )
            }
        }
    }

    public func unmap() {
        self.withUnsafeHandle { handle_self in
            wgpuBufferUnmap(
                handle_self
            )
        }
    }

    public func destroy() {
        self.withUnsafeHandle { handle_self in
            wgpuBufferDestroy(
                handle_self
            )
        }
    }
}

public class CommandBuffer: Object {
    private let handle: WGPUCommandBuffer!

    /// Create a wrapper around an existing handle.
    ///
    /// The ownership of the handle is transferred to this class.
    ///
    /// - Parameter handle: The handle to wrap.
    public init(handle: WGPUCommandBuffer!) {
        self.handle = handle
    }

    deinit {
        wgpuCommandBufferRelease(self.handle)
    }

    /// Calls the given closure with the underlying handle.
    ///
    /// The underlying handle is guaranteed not to be released before the closure returns.
    ///
    /// - Parameter body: A closure to call with the underlying handle.
    public func withUnsafeHandle<R>(_ body: (WGPUCommandBuffer) throws -> R) rethrows -> R {
        return try withExtendedLifetime(self) {
            return try body(self.handle)
        }
    }

    public func setLabel(_ label: String) {
        self.withUnsafeHandle { handle_self in
            label.withCString { cString_label in
            wgpuCommandBufferSetLabel(
                handle_self, 
                cString_label
            )
            }
        }
    }
}

public class CommandEncoder: Object {
    private let handle: WGPUCommandEncoder!

    /// Create a wrapper around an existing handle.
    ///
    /// The ownership of the handle is transferred to this class.
    ///
    /// - Parameter handle: The handle to wrap.
    public init(handle: WGPUCommandEncoder!) {
        self.handle = handle
    }

    deinit {
        wgpuCommandEncoderRelease(self.handle)
    }

    /// Calls the given closure with the underlying handle.
    ///
    /// The underlying handle is guaranteed not to be released before the closure returns.
    ///
    /// - Parameter body: A closure to call with the underlying handle.
    public func withUnsafeHandle<R>(_ body: (WGPUCommandEncoder) throws -> R) rethrows -> R {
        return try withExtendedLifetime(self) {
            return try body(self.handle)
        }
    }

    public func finish(descriptor: CommandBufferDescriptor? = nil) -> CommandBuffer {
        self.withUnsafeHandle { handle_self in
            descriptor.withOptionalCStruct { cStruct_descriptor in
            let result = wgpuCommandEncoderFinish(
                handle_self, 
                cStruct_descriptor
            )
            return .init(handle: result)
            }
        }
    }

    public func beginComputePass(descriptor: ComputePassDescriptor? = nil) -> ComputePassEncoder {
        self.withUnsafeHandle { handle_self in
            descriptor.withOptionalCStruct { cStruct_descriptor in
            let result = wgpuCommandEncoderBeginComputePass(
                handle_self, 
                cStruct_descriptor
            )
            return .init(handle: result)
            }
        }
    }

    public func beginRenderPass(descriptor: RenderPassDescriptor) -> RenderPassEncoder {
        self.withUnsafeHandle { handle_self in
            descriptor.withCStruct { cStruct_descriptor in
            let result = wgpuCommandEncoderBeginRenderPass(
                handle_self, 
                cStruct_descriptor
            )
            return .init(handle: result)
            }
        }
    }

    public func copyBufferToBuffer(source: Buffer, sourceOffset: UInt64, destination: Buffer, destinationOffset: UInt64, size: UInt64) {
        self.withUnsafeHandle { handle_self in
            source.withUnsafeHandle { handle_source in
            destination.withUnsafeHandle { handle_destination in
            wgpuCommandEncoderCopyBufferToBuffer(
                handle_self, 
                handle_source, 
                sourceOffset, 
                handle_destination, 
                destinationOffset, 
                size
            )
            }
            }
        }
    }

    public func copyBufferToTexture(source: ImageCopyBuffer, destination: ImageCopyTexture, copySize: Extent3d) {
        self.withUnsafeHandle { handle_self in
            source.withCStruct { cStruct_source in
            destination.withCStruct { cStruct_destination in
            copySize.withCStruct { cStruct_copySize in
            wgpuCommandEncoderCopyBufferToTexture(
                handle_self, 
                cStruct_source, 
                cStruct_destination, 
                cStruct_copySize
            )
            }
            }
            }
        }
    }

    public func copyTextureToBuffer(source: ImageCopyTexture, destination: ImageCopyBuffer, copySize: Extent3d) {
        self.withUnsafeHandle { handle_self in
            source.withCStruct { cStruct_source in
            destination.withCStruct { cStruct_destination in
            copySize.withCStruct { cStruct_copySize in
            wgpuCommandEncoderCopyTextureToBuffer(
                handle_self, 
                cStruct_source, 
                cStruct_destination, 
                cStruct_copySize
            )
            }
            }
            }
        }
    }

    public func copyTextureToTexture(source: ImageCopyTexture, destination: ImageCopyTexture, copySize: Extent3d) {
        self.withUnsafeHandle { handle_self in
            source.withCStruct { cStruct_source in
            destination.withCStruct { cStruct_destination in
            copySize.withCStruct { cStruct_copySize in
            wgpuCommandEncoderCopyTextureToTexture(
                handle_self, 
                cStruct_source, 
                cStruct_destination, 
                cStruct_copySize
            )
            }
            }
            }
        }
    }

    public func copyTextureToTextureInternal(source: ImageCopyTexture, destination: ImageCopyTexture, copySize: Extent3d) {
        self.withUnsafeHandle { handle_self in
            source.withCStruct { cStruct_source in
            destination.withCStruct { cStruct_destination in
            copySize.withCStruct { cStruct_copySize in
            wgpuCommandEncoderCopyTextureToTextureInternal(
                handle_self, 
                cStruct_source, 
                cStruct_destination, 
                cStruct_copySize
            )
            }
            }
            }
        }
    }

    public func clearBuffer(_ buffer: Buffer, offset: UInt64, size: UInt64 = UInt64(WGPU_WHOLE_SIZE)) {
        self.withUnsafeHandle { handle_self in
            buffer.withUnsafeHandle { handle_buffer in
            wgpuCommandEncoderClearBuffer(
                handle_self, 
                handle_buffer, 
                offset, 
                size
            )
            }
        }
    }

    public func injectValidationError(message: String) {
        self.withUnsafeHandle { handle_self in
            message.withCString { cString_message in
            wgpuCommandEncoderInjectValidationError(
                handle_self, 
                cString_message
            )
            }
        }
    }

    public func insertDebugMarker(markerLabel: String) {
        self.withUnsafeHandle { handle_self in
            markerLabel.withCString { cString_markerLabel in
            wgpuCommandEncoderInsertDebugMarker(
                handle_self, 
                cString_markerLabel
            )
            }
        }
    }

    public func popDebugGroup() {
        self.withUnsafeHandle { handle_self in
            wgpuCommandEncoderPopDebugGroup(
                handle_self
            )
        }
    }

    public func pushDebugGroup(groupLabel: String) {
        self.withUnsafeHandle { handle_self in
            groupLabel.withCString { cString_groupLabel in
            wgpuCommandEncoderPushDebugGroup(
                handle_self, 
                cString_groupLabel
            )
            }
        }
    }

    public func resolveQuerySet(_ querySet: QuerySet, firstQuery: UInt32, queryCount: UInt32, destination: Buffer, destinationOffset: UInt64) {
        self.withUnsafeHandle { handle_self in
            querySet.withUnsafeHandle { handle_querySet in
            destination.withUnsafeHandle { handle_destination in
            wgpuCommandEncoderResolveQuerySet(
                handle_self, 
                handle_querySet, 
                firstQuery, 
                queryCount, 
                handle_destination, 
                destinationOffset
            )
            }
            }
        }
    }

    public func writeBuffer(_ buffer: Buffer, bufferOffset: UInt64, data: [UInt8]) {
        self.withUnsafeHandle { handle_self in
            buffer.withUnsafeHandle { handle_buffer in
            data.withUnsafeBufferPointer { buffer_data in
            wgpuCommandEncoderWriteBuffer(
                handle_self, 
                handle_buffer, 
                bufferOffset, 
                buffer_data.baseAddress, 
                .init(buffer_data.count)
            )
            }
            }
        }
    }

    public func writeTimestamp(querySet: QuerySet, queryIndex: UInt32) {
        self.withUnsafeHandle { handle_self in
            querySet.withUnsafeHandle { handle_querySet in
            wgpuCommandEncoderWriteTimestamp(
                handle_self, 
                handle_querySet, 
                queryIndex
            )
            }
        }
    }

    public func setLabel(_ label: String) {
        self.withUnsafeHandle { handle_self in
            label.withCString { cString_label in
            wgpuCommandEncoderSetLabel(
                handle_self, 
                cString_label
            )
            }
        }
    }
}

public class ComputePassEncoder: Object {
    private let handle: WGPUComputePassEncoder!

    /// Create a wrapper around an existing handle.
    ///
    /// The ownership of the handle is transferred to this class.
    ///
    /// - Parameter handle: The handle to wrap.
    public init(handle: WGPUComputePassEncoder!) {
        self.handle = handle
    }

    deinit {
        wgpuComputePassEncoderRelease(self.handle)
    }

    /// Calls the given closure with the underlying handle.
    ///
    /// The underlying handle is guaranteed not to be released before the closure returns.
    ///
    /// - Parameter body: A closure to call with the underlying handle.
    public func withUnsafeHandle<R>(_ body: (WGPUComputePassEncoder) throws -> R) rethrows -> R {
        return try withExtendedLifetime(self) {
            return try body(self.handle)
        }
    }

    public func insertDebugMarker(markerLabel: String) {
        self.withUnsafeHandle { handle_self in
            markerLabel.withCString { cString_markerLabel in
            wgpuComputePassEncoderInsertDebugMarker(
                handle_self, 
                cString_markerLabel
            )
            }
        }
    }

    public func popDebugGroup() {
        self.withUnsafeHandle { handle_self in
            wgpuComputePassEncoderPopDebugGroup(
                handle_self
            )
        }
    }

    public func pushDebugGroup(groupLabel: String) {
        self.withUnsafeHandle { handle_self in
            groupLabel.withCString { cString_groupLabel in
            wgpuComputePassEncoderPushDebugGroup(
                handle_self, 
                cString_groupLabel
            )
            }
        }
    }

    public func setPipeline(_ pipeline: ComputePipeline) {
        self.withUnsafeHandle { handle_self in
            pipeline.withUnsafeHandle { handle_pipeline in
            wgpuComputePassEncoderSetPipeline(
                handle_self, 
                handle_pipeline
            )
            }
        }
    }

    public func setBindGroup(groupIndex: UInt32, group: BindGroup, dynamicOffsets: [UInt32] = []) {
        self.withUnsafeHandle { handle_self in
            group.withUnsafeHandle { handle_group in
            dynamicOffsets.withUnsafeBufferPointer { buffer_dynamicOffsets in
            wgpuComputePassEncoderSetBindGroup(
                handle_self, 
                groupIndex, 
                handle_group, 
                .init(buffer_dynamicOffsets.count), 
                buffer_dynamicOffsets.baseAddress
            )
            }
            }
        }
    }

    public func writeTimestamp(querySet: QuerySet, queryIndex: UInt32) {
        self.withUnsafeHandle { handle_self in
            querySet.withUnsafeHandle { handle_querySet in
            wgpuComputePassEncoderWriteTimestamp(
                handle_self, 
                handle_querySet, 
                queryIndex
            )
            }
        }
    }

    public func dispatch(x: UInt32, y: UInt32 = 1, z: UInt32 = 1) {
        self.withUnsafeHandle { handle_self in
            wgpuComputePassEncoderDispatch(
                handle_self, 
                x, 
                y, 
                z
            )
        }
    }

    public func dispatchIndirect(indirectBuffer: Buffer, indirectOffset: UInt64) {
        self.withUnsafeHandle { handle_self in
            indirectBuffer.withUnsafeHandle { handle_indirectBuffer in
            wgpuComputePassEncoderDispatchIndirect(
                handle_self, 
                handle_indirectBuffer, 
                indirectOffset
            )
            }
        }
    }

    public func endPass() {
        self.withUnsafeHandle { handle_self in
            wgpuComputePassEncoderEndPass(
                handle_self
            )
        }
    }

    public func setLabel(_ label: String) {
        self.withUnsafeHandle { handle_self in
            label.withCString { cString_label in
            wgpuComputePassEncoderSetLabel(
                handle_self, 
                cString_label
            )
            }
        }
    }
}

public class ComputePipeline: Object {
    private let handle: WGPUComputePipeline!

    /// Create a wrapper around an existing handle.
    ///
    /// The ownership of the handle is transferred to this class.
    ///
    /// - Parameter handle: The handle to wrap.
    public init(handle: WGPUComputePipeline!) {
        self.handle = handle
    }

    deinit {
        wgpuComputePipelineRelease(self.handle)
    }

    /// Calls the given closure with the underlying handle.
    ///
    /// The underlying handle is guaranteed not to be released before the closure returns.
    ///
    /// - Parameter body: A closure to call with the underlying handle.
    public func withUnsafeHandle<R>(_ body: (WGPUComputePipeline) throws -> R) rethrows -> R {
        return try withExtendedLifetime(self) {
            return try body(self.handle)
        }
    }

    public func getBindGroupLayout(groupIndex: UInt32) -> BindGroupLayout {
        self.withUnsafeHandle { handle_self in
            let result = wgpuComputePipelineGetBindGroupLayout(
                handle_self, 
                groupIndex
            )
            return .init(handle: result)
        }
    }

    public func setLabel(_ label: String) {
        self.withUnsafeHandle { handle_self in
            label.withCString { cString_label in
            wgpuComputePipelineSetLabel(
                handle_self, 
                cString_label
            )
            }
        }
    }
}

public class Device: Object {
    private let handle: WGPUDevice!

    /// Create a wrapper around an existing handle.
    ///
    /// The ownership of the handle is transferred to this class.
    ///
    /// - Parameter handle: The handle to wrap.
    public init(handle: WGPUDevice!) {
        self.handle = handle
    }

    deinit {
        setUncapturedErrorCallback(nil)
        setLoggingCallback(nil)
        setDeviceLostCallback(nil)
        wgpuDeviceRelease(self.handle)
    }

    /// Calls the given closure with the underlying handle.
    ///
    /// The underlying handle is guaranteed not to be released before the closure returns.
    ///
    /// - Parameter body: A closure to call with the underlying handle.
    public func withUnsafeHandle<R>(_ body: (WGPUDevice) throws -> R) rethrows -> R {
        return try withExtendedLifetime(self) {
            return try body(self.handle)
        }
    }

    public func createBindGroup(descriptor: BindGroupDescriptor) -> BindGroup {
        self.withUnsafeHandle { handle_self in
            descriptor.withCStruct { cStruct_descriptor in
            let result = wgpuDeviceCreateBindGroup(
                handle_self, 
                cStruct_descriptor
            )
            return .init(handle: result)
            }
        }
    }

    public func createBindGroupLayout(descriptor: BindGroupLayoutDescriptor) -> BindGroupLayout {
        self.withUnsafeHandle { handle_self in
            descriptor.withCStruct { cStruct_descriptor in
            let result = wgpuDeviceCreateBindGroupLayout(
                handle_self, 
                cStruct_descriptor
            )
            return .init(handle: result)
            }
        }
    }

    public func createBuffer(descriptor: BufferDescriptor) -> Buffer {
        self.withUnsafeHandle { handle_self in
            descriptor.withCStruct { cStruct_descriptor in
            let result = wgpuDeviceCreateBuffer(
                handle_self, 
                cStruct_descriptor
            )
            return .init(handle: result)
            }
        }
    }

    public func createErrorBuffer() -> Buffer {
        self.withUnsafeHandle { handle_self in
            let result = wgpuDeviceCreateErrorBuffer(
                handle_self
            )
            return .init(handle: result)
        }
    }

    public func createCommandEncoder(descriptor: CommandEncoderDescriptor? = nil) -> CommandEncoder {
        self.withUnsafeHandle { handle_self in
            descriptor.withOptionalCStruct { cStruct_descriptor in
            let result = wgpuDeviceCreateCommandEncoder(
                handle_self, 
                cStruct_descriptor
            )
            return .init(handle: result)
            }
        }
    }

    public func createComputePipeline(descriptor: ComputePipelineDescriptor) -> ComputePipeline {
        self.withUnsafeHandle { handle_self in
            descriptor.withCStruct { cStruct_descriptor in
            let result = wgpuDeviceCreateComputePipeline(
                handle_self, 
                cStruct_descriptor
            )
            return .init(handle: result)
            }
        }
    }

    public func createComputePipelineAsync(descriptor: ComputePipelineDescriptor, callback: @escaping CreateComputePipelineAsyncCallback) {
        self.withUnsafeHandle { handle_self in
            descriptor.withCStruct { cStruct_descriptor in
            wgpuDeviceCreateComputePipelineAsync(
                handle_self, 
                cStruct_descriptor, 
                createComputePipelineAsyncCallback, 
                UserData.passRetained(callback)
            )
            }
        }
    }

    public func createExternalTexture(externalTextureDescriptor: ExternalTextureDescriptor) -> ExternalTexture {
        self.withUnsafeHandle { handle_self in
            externalTextureDescriptor.withCStruct { cStruct_externalTextureDescriptor in
            let result = wgpuDeviceCreateExternalTexture(
                handle_self, 
                cStruct_externalTextureDescriptor
            )
            return .init(handle: result)
            }
        }
    }

    public func createPipelineLayout(descriptor: PipelineLayoutDescriptor) -> PipelineLayout {
        self.withUnsafeHandle { handle_self in
            descriptor.withCStruct { cStruct_descriptor in
            let result = wgpuDeviceCreatePipelineLayout(
                handle_self, 
                cStruct_descriptor
            )
            return .init(handle: result)
            }
        }
    }

    public func createQuerySet(descriptor: QuerySetDescriptor) -> QuerySet {
        self.withUnsafeHandle { handle_self in
            descriptor.withCStruct { cStruct_descriptor in
            let result = wgpuDeviceCreateQuerySet(
                handle_self, 
                cStruct_descriptor
            )
            return .init(handle: result)
            }
        }
    }

    public func createRenderPipelineAsync(descriptor: RenderPipelineDescriptor, callback: @escaping CreateRenderPipelineAsyncCallback) {
        self.withUnsafeHandle { handle_self in
            descriptor.withCStruct { cStruct_descriptor in
            wgpuDeviceCreateRenderPipelineAsync(
                handle_self, 
                cStruct_descriptor, 
                createRenderPipelineAsyncCallback, 
                UserData.passRetained(callback)
            )
            }
        }
    }

    public func createRenderBundleEncoder(descriptor: RenderBundleEncoderDescriptor) -> RenderBundleEncoder {
        self.withUnsafeHandle { handle_self in
            descriptor.withCStruct { cStruct_descriptor in
            let result = wgpuDeviceCreateRenderBundleEncoder(
                handle_self, 
                cStruct_descriptor
            )
            return .init(handle: result)
            }
        }
    }

    public func createRenderPipeline(descriptor: RenderPipelineDescriptor) -> RenderPipeline {
        self.withUnsafeHandle { handle_self in
            descriptor.withCStruct { cStruct_descriptor in
            let result = wgpuDeviceCreateRenderPipeline(
                handle_self, 
                cStruct_descriptor
            )
            return .init(handle: result)
            }
        }
    }

    public func createSampler(descriptor: SamplerDescriptor? = nil) -> Sampler {
        self.withUnsafeHandle { handle_self in
            descriptor.withOptionalCStruct { cStruct_descriptor in
            let result = wgpuDeviceCreateSampler(
                handle_self, 
                cStruct_descriptor
            )
            return .init(handle: result)
            }
        }
    }

    public func createShaderModule(descriptor: ShaderModuleDescriptor) -> ShaderModule {
        self.withUnsafeHandle { handle_self in
            descriptor.withCStruct { cStruct_descriptor in
            let result = wgpuDeviceCreateShaderModule(
                handle_self, 
                cStruct_descriptor
            )
            return .init(handle: result)
            }
        }
    }

    public func createSwapChain(surface: Surface? = nil, descriptor: SwapChainDescriptor) -> SwapChain {
        self.withUnsafeHandle { handle_self in
            surface.withOptionalHandle { handle_surface in
            descriptor.withCStruct { cStruct_descriptor in
            let result = wgpuDeviceCreateSwapChain(
                handle_self, 
                handle_surface, 
                cStruct_descriptor
            )
            return .init(handle: result)
            }
            }
        }
    }

    public func createTexture(descriptor: TextureDescriptor) -> Texture {
        self.withUnsafeHandle { handle_self in
            descriptor.withCStruct { cStruct_descriptor in
            let result = wgpuDeviceCreateTexture(
                handle_self, 
                cStruct_descriptor
            )
            return .init(handle: result)
            }
        }
    }

    public func destroy() {
        self.withUnsafeHandle { handle_self in
            wgpuDeviceDestroy(
                handle_self
            )
        }
    }

    public func getLimits(_ limits: UnsafeMutablePointer<WGPUSupportedLimits>!) -> Bool {
        self.withUnsafeHandle { handle_self in
            let result = wgpuDeviceGetLimits(
                handle_self, 
                limits
            )
            return result
        }
    }

    public func hasFeature(_ feature: FeatureName) -> Bool {
        self.withUnsafeHandle { handle_self in
            let result = wgpuDeviceHasFeature(
                handle_self, 
                feature.cValue
            )
            return result
        }
    }

    public func enumerateFeatures(_ features: UnsafeMutablePointer<WGPUFeatureName>!) -> UInt32 {
        self.withUnsafeHandle { handle_self in
            let result = wgpuDeviceEnumerateFeatures(
                handle_self, 
                features.cValue
            )
            return result
        }
    }

    public var queue: Queue {
        self.withUnsafeHandle { handle_self in
            let result = wgpuDeviceGetQueue(
                handle_self
            )
            return .init(handle: result)
        }
    }

    public func injectError(type: ErrorType, message: String) {
        self.withUnsafeHandle { handle_self in
            message.withCString { cString_message in
            wgpuDeviceInjectError(
                handle_self, 
                type.cValue, 
                cString_message
            )
            }
        }
    }

    public func loseForTesting() {
        self.withUnsafeHandle { handle_self in
            wgpuDeviceLoseForTesting(
                handle_self
            )
        }
    }

    public func tick() {
        self.withUnsafeHandle { handle_self in
            wgpuDeviceTick(
                handle_self
            )
        }
    }

    var _setUncapturedErrorCallback: UserData<ErrorCallback>? = nil
    public func setUncapturedErrorCallback(_ callback: ErrorCallback?) {
        self.withUnsafeHandle { handle_self in
            if let callback = callback {
                let userData = UserData(callback)
                self._setUncapturedErrorCallback = userData
                wgpuDeviceSetUncapturedErrorCallback(handle_self, errorCallback, userData.toOpaque())
            } else {
                self._setUncapturedErrorCallback = nil
                wgpuDeviceSetUncapturedErrorCallback(handle_self, nil, nil)
            }
        }
    }

    var _setLoggingCallback: UserData<LoggingCallback>? = nil
    public func setLoggingCallback(_ callback: LoggingCallback?) {
        self.withUnsafeHandle { handle_self in
            if let callback = callback {
                let userData = UserData(callback)
                self._setLoggingCallback = userData
                wgpuDeviceSetLoggingCallback(handle_self, loggingCallback, userData.toOpaque())
            } else {
                self._setLoggingCallback = nil
                wgpuDeviceSetLoggingCallback(handle_self, nil, nil)
            }
        }
    }

    var _setDeviceLostCallback: UserData<DeviceLostCallback>? = nil
    public func setDeviceLostCallback(_ callback: DeviceLostCallback?) {
        self.withUnsafeHandle { handle_self in
            if let callback = callback {
                let userData = UserData(callback)
                self._setDeviceLostCallback = userData
                wgpuDeviceSetDeviceLostCallback(handle_self, deviceLostCallback, userData.toOpaque())
            } else {
                self._setDeviceLostCallback = nil
                wgpuDeviceSetDeviceLostCallback(handle_self, nil, nil)
            }
        }
    }

    public func pushErrorScope(filter: ErrorFilter) {
        self.withUnsafeHandle { handle_self in
            wgpuDevicePushErrorScope(
                handle_self, 
                filter.cValue
            )
        }
    }

    public func popErrorScope(callback: @escaping ErrorCallback) -> Bool {
        self.withUnsafeHandle { handle_self in
            let result = wgpuDevicePopErrorScope(
                handle_self, 
                errorCallback, 
                UserData.passRetained(callback)
            )
            return result
        }
    }
}

public class ExternalTexture: Object {
    private let handle: WGPUExternalTexture!

    /// Create a wrapper around an existing handle.
    ///
    /// The ownership of the handle is transferred to this class.
    ///
    /// - Parameter handle: The handle to wrap.
    public init(handle: WGPUExternalTexture!) {
        self.handle = handle
    }

    deinit {
        wgpuExternalTextureRelease(self.handle)
    }

    /// Calls the given closure with the underlying handle.
    ///
    /// The underlying handle is guaranteed not to be released before the closure returns.
    ///
    /// - Parameter body: A closure to call with the underlying handle.
    public func withUnsafeHandle<R>(_ body: (WGPUExternalTexture) throws -> R) rethrows -> R {
        return try withExtendedLifetime(self) {
            return try body(self.handle)
        }
    }

    public func setLabel(_ label: String) {
        self.withUnsafeHandle { handle_self in
            label.withCString { cString_label in
            wgpuExternalTextureSetLabel(
                handle_self, 
                cString_label
            )
            }
        }
    }

    public func destroy() {
        self.withUnsafeHandle { handle_self in
            wgpuExternalTextureDestroy(
                handle_self
            )
        }
    }
}

open class Instance: Object {
    private let handle: WGPUInstance!

    /// Create a wrapper around an existing handle.
    ///
    /// The ownership of the handle is transferred to this class.
    ///
    /// - Parameter handle: The handle to wrap.
    public init(handle: WGPUInstance!) {
        self.handle = handle
    }

    deinit {
        wgpuInstanceRelease(self.handle)
    }

    /// Calls the given closure with the underlying handle.
    ///
    /// The underlying handle is guaranteed not to be released before the closure returns.
    ///
    /// - Parameter body: A closure to call with the underlying handle.
    public func withUnsafeHandle<R>(_ body: (WGPUInstance) throws -> R) rethrows -> R {
        return try withExtendedLifetime(self) {
            return try body(self.handle)
        }
    }

    public func createSurface(descriptor: SurfaceDescriptor) -> Surface {
        self.withUnsafeHandle { handle_self in
            descriptor.withCStruct { cStruct_descriptor in
            let result = wgpuInstanceCreateSurface(
                handle_self, 
                cStruct_descriptor
            )
            return .init(handle: result)
            }
        }
    }

    public func requestAdapter(options: RequestAdapterOptions, callback: @escaping RequestAdapterCallback) {
        self.withUnsafeHandle { handle_self in
            options.withCStruct { cStruct_options in
            wgpuInstanceRequestAdapter(
                handle_self, 
                cStruct_options, 
                requestAdapterCallback, 
                UserData.passRetained(callback)
            )
            }
        }
    }
}

public class PipelineLayout: Object {
    private let handle: WGPUPipelineLayout!

    /// Create a wrapper around an existing handle.
    ///
    /// The ownership of the handle is transferred to this class.
    ///
    /// - Parameter handle: The handle to wrap.
    public init(handle: WGPUPipelineLayout!) {
        self.handle = handle
    }

    deinit {
        wgpuPipelineLayoutRelease(self.handle)
    }

    /// Calls the given closure with the underlying handle.
    ///
    /// The underlying handle is guaranteed not to be released before the closure returns.
    ///
    /// - Parameter body: A closure to call with the underlying handle.
    public func withUnsafeHandle<R>(_ body: (WGPUPipelineLayout) throws -> R) rethrows -> R {
        return try withExtendedLifetime(self) {
            return try body(self.handle)
        }
    }

    public func setLabel(_ label: String) {
        self.withUnsafeHandle { handle_self in
            label.withCString { cString_label in
            wgpuPipelineLayoutSetLabel(
                handle_self, 
                cString_label
            )
            }
        }
    }
}

public class QuerySet: Object {
    private let handle: WGPUQuerySet!

    /// Create a wrapper around an existing handle.
    ///
    /// The ownership of the handle is transferred to this class.
    ///
    /// - Parameter handle: The handle to wrap.
    public init(handle: WGPUQuerySet!) {
        self.handle = handle
    }

    deinit {
        wgpuQuerySetRelease(self.handle)
    }

    /// Calls the given closure with the underlying handle.
    ///
    /// The underlying handle is guaranteed not to be released before the closure returns.
    ///
    /// - Parameter body: A closure to call with the underlying handle.
    public func withUnsafeHandle<R>(_ body: (WGPUQuerySet) throws -> R) rethrows -> R {
        return try withExtendedLifetime(self) {
            return try body(self.handle)
        }
    }

    public func setLabel(_ label: String) {
        self.withUnsafeHandle { handle_self in
            label.withCString { cString_label in
            wgpuQuerySetSetLabel(
                handle_self, 
                cString_label
            )
            }
        }
    }

    public func destroy() {
        self.withUnsafeHandle { handle_self in
            wgpuQuerySetDestroy(
                handle_self
            )
        }
    }
}

public class Queue: Object {
    private let handle: WGPUQueue!

    /// Create a wrapper around an existing handle.
    ///
    /// The ownership of the handle is transferred to this class.
    ///
    /// - Parameter handle: The handle to wrap.
    public init(handle: WGPUQueue!) {
        self.handle = handle
    }

    deinit {
        wgpuQueueRelease(self.handle)
    }

    /// Calls the given closure with the underlying handle.
    ///
    /// The underlying handle is guaranteed not to be released before the closure returns.
    ///
    /// - Parameter body: A closure to call with the underlying handle.
    public func withUnsafeHandle<R>(_ body: (WGPUQueue) throws -> R) rethrows -> R {
        return try withExtendedLifetime(self) {
            return try body(self.handle)
        }
    }

    public func submit(commands: [CommandBuffer]) {
        self.withUnsafeHandle { handle_self in
            commands.withHandleBufferPointer { buffer_commands in
            wgpuQueueSubmit(
                handle_self, 
                .init(buffer_commands.count), 
                buffer_commands.baseAddress
            )
            }
        }
    }

    public func onSubmittedWorkDone(signalValue: UInt64, callback: @escaping QueueWorkDoneCallback) {
        self.withUnsafeHandle { handle_self in
            wgpuQueueOnSubmittedWorkDone(
                handle_self, 
                signalValue, 
                queueWorkDoneCallback, 
                UserData.passRetained(callback)
            )
        }
    }

    public func writeBuffer(_ buffer: Buffer, bufferOffset: UInt64, data: UnsafeRawBufferPointer) {
        self.withUnsafeHandle { handle_self in
            buffer.withUnsafeHandle { handle_buffer in
            wgpuQueueWriteBuffer(
                handle_self, 
                handle_buffer, 
                bufferOffset, 
                data.baseAddress, 
                .init(data.count)
            )
            }
        }
    }

    public func writeTexture(destination: ImageCopyTexture, data: UnsafeRawBufferPointer, dataLayout: TextureDataLayout, writeSize: Extent3d) {
        self.withUnsafeHandle { handle_self in
            destination.withCStruct { cStruct_destination in
            dataLayout.withCStruct { cStruct_dataLayout in
            writeSize.withCStruct { cStruct_writeSize in
            wgpuQueueWriteTexture(
                handle_self, 
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
    }

    public func copyTextureForBrowser(source: ImageCopyTexture, destination: ImageCopyTexture, copySize: Extent3d, options: CopyTextureForBrowserOptions) {
        self.withUnsafeHandle { handle_self in
            source.withCStruct { cStruct_source in
            destination.withCStruct { cStruct_destination in
            copySize.withCStruct { cStruct_copySize in
            options.withCStruct { cStruct_options in
            wgpuQueueCopyTextureForBrowser(
                handle_self, 
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
}

public class RenderBundle: Object {
    private let handle: WGPURenderBundle!

    /// Create a wrapper around an existing handle.
    ///
    /// The ownership of the handle is transferred to this class.
    ///
    /// - Parameter handle: The handle to wrap.
    public init(handle: WGPURenderBundle!) {
        self.handle = handle
    }

    deinit {
        wgpuRenderBundleRelease(self.handle)
    }

    /// Calls the given closure with the underlying handle.
    ///
    /// The underlying handle is guaranteed not to be released before the closure returns.
    ///
    /// - Parameter body: A closure to call with the underlying handle.
    public func withUnsafeHandle<R>(_ body: (WGPURenderBundle) throws -> R) rethrows -> R {
        return try withExtendedLifetime(self) {
            return try body(self.handle)
        }
    }
}

public class RenderBundleEncoder: Object {
    private let handle: WGPURenderBundleEncoder!

    /// Create a wrapper around an existing handle.
    ///
    /// The ownership of the handle is transferred to this class.
    ///
    /// - Parameter handle: The handle to wrap.
    public init(handle: WGPURenderBundleEncoder!) {
        self.handle = handle
    }

    deinit {
        wgpuRenderBundleEncoderRelease(self.handle)
    }

    /// Calls the given closure with the underlying handle.
    ///
    /// The underlying handle is guaranteed not to be released before the closure returns.
    ///
    /// - Parameter body: A closure to call with the underlying handle.
    public func withUnsafeHandle<R>(_ body: (WGPURenderBundleEncoder) throws -> R) rethrows -> R {
        return try withExtendedLifetime(self) {
            return try body(self.handle)
        }
    }

    public func setPipeline(_ pipeline: RenderPipeline) {
        self.withUnsafeHandle { handle_self in
            pipeline.withUnsafeHandle { handle_pipeline in
            wgpuRenderBundleEncoderSetPipeline(
                handle_self, 
                handle_pipeline
            )
            }
        }
    }

    public func setBindGroup(groupIndex: UInt32, group: BindGroup, dynamicOffsets: [UInt32] = []) {
        self.withUnsafeHandle { handle_self in
            group.withUnsafeHandle { handle_group in
            dynamicOffsets.withUnsafeBufferPointer { buffer_dynamicOffsets in
            wgpuRenderBundleEncoderSetBindGroup(
                handle_self, 
                groupIndex, 
                handle_group, 
                .init(buffer_dynamicOffsets.count), 
                buffer_dynamicOffsets.baseAddress
            )
            }
            }
        }
    }

    public func draw(vertexCount: UInt32, instanceCount: UInt32 = 1, firstVertex: UInt32 = 0, firstInstance: UInt32 = 0) {
        self.withUnsafeHandle { handle_self in
            wgpuRenderBundleEncoderDraw(
                handle_self, 
                vertexCount, 
                instanceCount, 
                firstVertex, 
                firstInstance
            )
        }
    }

    public func drawIndexed(indexCount: UInt32, instanceCount: UInt32 = 1, firstIndex: UInt32 = 0, baseVertex: Int32 = 0, firstInstance: UInt32 = 0) {
        self.withUnsafeHandle { handle_self in
            wgpuRenderBundleEncoderDrawIndexed(
                handle_self, 
                indexCount, 
                instanceCount, 
                firstIndex, 
                baseVertex, 
                firstInstance
            )
        }
    }

    public func drawIndirect(indirectBuffer: Buffer, indirectOffset: UInt64) {
        self.withUnsafeHandle { handle_self in
            indirectBuffer.withUnsafeHandle { handle_indirectBuffer in
            wgpuRenderBundleEncoderDrawIndirect(
                handle_self, 
                handle_indirectBuffer, 
                indirectOffset
            )
            }
        }
    }

    public func drawIndexedIndirect(indirectBuffer: Buffer, indirectOffset: UInt64) {
        self.withUnsafeHandle { handle_self in
            indirectBuffer.withUnsafeHandle { handle_indirectBuffer in
            wgpuRenderBundleEncoderDrawIndexedIndirect(
                handle_self, 
                handle_indirectBuffer, 
                indirectOffset
            )
            }
        }
    }

    public func insertDebugMarker(markerLabel: String) {
        self.withUnsafeHandle { handle_self in
            markerLabel.withCString { cString_markerLabel in
            wgpuRenderBundleEncoderInsertDebugMarker(
                handle_self, 
                cString_markerLabel
            )
            }
        }
    }

    public func popDebugGroup() {
        self.withUnsafeHandle { handle_self in
            wgpuRenderBundleEncoderPopDebugGroup(
                handle_self
            )
        }
    }

    public func pushDebugGroup(groupLabel: String) {
        self.withUnsafeHandle { handle_self in
            groupLabel.withCString { cString_groupLabel in
            wgpuRenderBundleEncoderPushDebugGroup(
                handle_self, 
                cString_groupLabel
            )
            }
        }
    }

    public func setVertexBuffer(slot: UInt32, buffer: Buffer, offset: UInt64 = 0, size: UInt64 = UInt64(WGPU_WHOLE_SIZE)) {
        self.withUnsafeHandle { handle_self in
            buffer.withUnsafeHandle { handle_buffer in
            wgpuRenderBundleEncoderSetVertexBuffer(
                handle_self, 
                slot, 
                handle_buffer, 
                offset, 
                size
            )
            }
        }
    }

    public func setIndexBuffer(_ buffer: Buffer, format: IndexFormat, offset: UInt64 = 0, size: UInt64 = UInt64(WGPU_WHOLE_SIZE)) {
        self.withUnsafeHandle { handle_self in
            buffer.withUnsafeHandle { handle_buffer in
            wgpuRenderBundleEncoderSetIndexBuffer(
                handle_self, 
                handle_buffer, 
                format.cValue, 
                offset, 
                size
            )
            }
        }
    }

    public func finish(descriptor: RenderBundleDescriptor? = nil) -> RenderBundle {
        self.withUnsafeHandle { handle_self in
            descriptor.withOptionalCStruct { cStruct_descriptor in
            let result = wgpuRenderBundleEncoderFinish(
                handle_self, 
                cStruct_descriptor
            )
            return .init(handle: result)
            }
        }
    }

    public func setLabel(_ label: String) {
        self.withUnsafeHandle { handle_self in
            label.withCString { cString_label in
            wgpuRenderBundleEncoderSetLabel(
                handle_self, 
                cString_label
            )
            }
        }
    }
}

public class RenderPassEncoder: Object {
    private let handle: WGPURenderPassEncoder!

    /// Create a wrapper around an existing handle.
    ///
    /// The ownership of the handle is transferred to this class.
    ///
    /// - Parameter handle: The handle to wrap.
    public init(handle: WGPURenderPassEncoder!) {
        self.handle = handle
    }

    deinit {
        wgpuRenderPassEncoderRelease(self.handle)
    }

    /// Calls the given closure with the underlying handle.
    ///
    /// The underlying handle is guaranteed not to be released before the closure returns.
    ///
    /// - Parameter body: A closure to call with the underlying handle.
    public func withUnsafeHandle<R>(_ body: (WGPURenderPassEncoder) throws -> R) rethrows -> R {
        return try withExtendedLifetime(self) {
            return try body(self.handle)
        }
    }

    public func setPipeline(_ pipeline: RenderPipeline) {
        self.withUnsafeHandle { handle_self in
            pipeline.withUnsafeHandle { handle_pipeline in
            wgpuRenderPassEncoderSetPipeline(
                handle_self, 
                handle_pipeline
            )
            }
        }
    }

    public func setBindGroup(groupIndex: UInt32, group: BindGroup, dynamicOffsets: [UInt32] = []) {
        self.withUnsafeHandle { handle_self in
            group.withUnsafeHandle { handle_group in
            dynamicOffsets.withUnsafeBufferPointer { buffer_dynamicOffsets in
            wgpuRenderPassEncoderSetBindGroup(
                handle_self, 
                groupIndex, 
                handle_group, 
                .init(buffer_dynamicOffsets.count), 
                buffer_dynamicOffsets.baseAddress
            )
            }
            }
        }
    }

    public func draw(vertexCount: UInt32, instanceCount: UInt32 = 1, firstVertex: UInt32 = 0, firstInstance: UInt32 = 0) {
        self.withUnsafeHandle { handle_self in
            wgpuRenderPassEncoderDraw(
                handle_self, 
                vertexCount, 
                instanceCount, 
                firstVertex, 
                firstInstance
            )
        }
    }

    public func drawIndexed(indexCount: UInt32, instanceCount: UInt32 = 1, firstIndex: UInt32 = 0, baseVertex: Int32 = 0, firstInstance: UInt32 = 0) {
        self.withUnsafeHandle { handle_self in
            wgpuRenderPassEncoderDrawIndexed(
                handle_self, 
                indexCount, 
                instanceCount, 
                firstIndex, 
                baseVertex, 
                firstInstance
            )
        }
    }

    public func drawIndirect(indirectBuffer: Buffer, indirectOffset: UInt64) {
        self.withUnsafeHandle { handle_self in
            indirectBuffer.withUnsafeHandle { handle_indirectBuffer in
            wgpuRenderPassEncoderDrawIndirect(
                handle_self, 
                handle_indirectBuffer, 
                indirectOffset
            )
            }
        }
    }

    public func drawIndexedIndirect(indirectBuffer: Buffer, indirectOffset: UInt64) {
        self.withUnsafeHandle { handle_self in
            indirectBuffer.withUnsafeHandle { handle_indirectBuffer in
            wgpuRenderPassEncoderDrawIndexedIndirect(
                handle_self, 
                handle_indirectBuffer, 
                indirectOffset
            )
            }
        }
    }

    public func executeBundles(bundles: [RenderBundle]) {
        self.withUnsafeHandle { handle_self in
            bundles.withHandleBufferPointer { buffer_bundles in
            wgpuRenderPassEncoderExecuteBundles(
                handle_self, 
                .init(buffer_bundles.count), 
                buffer_bundles.baseAddress
            )
            }
        }
    }

    public func insertDebugMarker(markerLabel: String) {
        self.withUnsafeHandle { handle_self in
            markerLabel.withCString { cString_markerLabel in
            wgpuRenderPassEncoderInsertDebugMarker(
                handle_self, 
                cString_markerLabel
            )
            }
        }
    }

    public func popDebugGroup() {
        self.withUnsafeHandle { handle_self in
            wgpuRenderPassEncoderPopDebugGroup(
                handle_self
            )
        }
    }

    public func pushDebugGroup(groupLabel: String) {
        self.withUnsafeHandle { handle_self in
            groupLabel.withCString { cString_groupLabel in
            wgpuRenderPassEncoderPushDebugGroup(
                handle_self, 
                cString_groupLabel
            )
            }
        }
    }

    public func setStencilReference(_ reference: UInt32) {
        self.withUnsafeHandle { handle_self in
            wgpuRenderPassEncoderSetStencilReference(
                handle_self, 
                reference
            )
        }
    }

    public func setBlendConstant(color: Color) {
        self.withUnsafeHandle { handle_self in
            color.withCStruct { cStruct_color in
            wgpuRenderPassEncoderSetBlendConstant(
                handle_self, 
                cStruct_color
            )
            }
        }
    }

    public func setViewport(x: Float, y: Float, width: Float, height: Float, minDepth: Float, maxDepth: Float) {
        self.withUnsafeHandle { handle_self in
            wgpuRenderPassEncoderSetViewport(
                handle_self, 
                x, 
                y, 
                width, 
                height, 
                minDepth, 
                maxDepth
            )
        }
    }

    public func setScissorRect(x: UInt32, y: UInt32, width: UInt32, height: UInt32) {
        self.withUnsafeHandle { handle_self in
            wgpuRenderPassEncoderSetScissorRect(
                handle_self, 
                x, 
                y, 
                width, 
                height
            )
        }
    }

    public func setVertexBuffer(slot: UInt32, buffer: Buffer, offset: UInt64 = 0, size: UInt64 = UInt64(WGPU_WHOLE_SIZE)) {
        self.withUnsafeHandle { handle_self in
            buffer.withUnsafeHandle { handle_buffer in
            wgpuRenderPassEncoderSetVertexBuffer(
                handle_self, 
                slot, 
                handle_buffer, 
                offset, 
                size
            )
            }
        }
    }

    public func setIndexBuffer(_ buffer: Buffer, format: IndexFormat, offset: UInt64 = 0, size: UInt64 = UInt64(WGPU_WHOLE_SIZE)) {
        self.withUnsafeHandle { handle_self in
            buffer.withUnsafeHandle { handle_buffer in
            wgpuRenderPassEncoderSetIndexBuffer(
                handle_self, 
                handle_buffer, 
                format.cValue, 
                offset, 
                size
            )
            }
        }
    }

    public func beginOcclusionQuery(queryIndex: UInt32) {
        self.withUnsafeHandle { handle_self in
            wgpuRenderPassEncoderBeginOcclusionQuery(
                handle_self, 
                queryIndex
            )
        }
    }

    public func endOcclusionQuery() {
        self.withUnsafeHandle { handle_self in
            wgpuRenderPassEncoderEndOcclusionQuery(
                handle_self
            )
        }
    }

    public func writeTimestamp(querySet: QuerySet, queryIndex: UInt32) {
        self.withUnsafeHandle { handle_self in
            querySet.withUnsafeHandle { handle_querySet in
            wgpuRenderPassEncoderWriteTimestamp(
                handle_self, 
                handle_querySet, 
                queryIndex
            )
            }
        }
    }

    public func endPass() {
        self.withUnsafeHandle { handle_self in
            wgpuRenderPassEncoderEndPass(
                handle_self
            )
        }
    }

    public func setLabel(_ label: String) {
        self.withUnsafeHandle { handle_self in
            label.withCString { cString_label in
            wgpuRenderPassEncoderSetLabel(
                handle_self, 
                cString_label
            )
            }
        }
    }
}

public class RenderPipeline: Object {
    private let handle: WGPURenderPipeline!

    /// Create a wrapper around an existing handle.
    ///
    /// The ownership of the handle is transferred to this class.
    ///
    /// - Parameter handle: The handle to wrap.
    public init(handle: WGPURenderPipeline!) {
        self.handle = handle
    }

    deinit {
        wgpuRenderPipelineRelease(self.handle)
    }

    /// Calls the given closure with the underlying handle.
    ///
    /// The underlying handle is guaranteed not to be released before the closure returns.
    ///
    /// - Parameter body: A closure to call with the underlying handle.
    public func withUnsafeHandle<R>(_ body: (WGPURenderPipeline) throws -> R) rethrows -> R {
        return try withExtendedLifetime(self) {
            return try body(self.handle)
        }
    }

    public func getBindGroupLayout(groupIndex: UInt32) -> BindGroupLayout {
        self.withUnsafeHandle { handle_self in
            let result = wgpuRenderPipelineGetBindGroupLayout(
                handle_self, 
                groupIndex
            )
            return .init(handle: result)
        }
    }

    public func setLabel(_ label: String) {
        self.withUnsafeHandle { handle_self in
            label.withCString { cString_label in
            wgpuRenderPipelineSetLabel(
                handle_self, 
                cString_label
            )
            }
        }
    }
}

public class Sampler: Object {
    private let handle: WGPUSampler!

    /// Create a wrapper around an existing handle.
    ///
    /// The ownership of the handle is transferred to this class.
    ///
    /// - Parameter handle: The handle to wrap.
    public init(handle: WGPUSampler!) {
        self.handle = handle
    }

    deinit {
        wgpuSamplerRelease(self.handle)
    }

    /// Calls the given closure with the underlying handle.
    ///
    /// The underlying handle is guaranteed not to be released before the closure returns.
    ///
    /// - Parameter body: A closure to call with the underlying handle.
    public func withUnsafeHandle<R>(_ body: (WGPUSampler) throws -> R) rethrows -> R {
        return try withExtendedLifetime(self) {
            return try body(self.handle)
        }
    }

    public func setLabel(_ label: String) {
        self.withUnsafeHandle { handle_self in
            label.withCString { cString_label in
            wgpuSamplerSetLabel(
                handle_self, 
                cString_label
            )
            }
        }
    }
}

public class ShaderModule: Object {
    private let handle: WGPUShaderModule!

    /// Create a wrapper around an existing handle.
    ///
    /// The ownership of the handle is transferred to this class.
    ///
    /// - Parameter handle: The handle to wrap.
    public init(handle: WGPUShaderModule!) {
        self.handle = handle
    }

    deinit {
        wgpuShaderModuleRelease(self.handle)
    }

    /// Calls the given closure with the underlying handle.
    ///
    /// The underlying handle is guaranteed not to be released before the closure returns.
    ///
    /// - Parameter body: A closure to call with the underlying handle.
    public func withUnsafeHandle<R>(_ body: (WGPUShaderModule) throws -> R) rethrows -> R {
        return try withExtendedLifetime(self) {
            return try body(self.handle)
        }
    }

    public func getCompilationInfo(callback: @escaping CompilationInfoCallback) {
        self.withUnsafeHandle { handle_self in
            wgpuShaderModuleGetCompilationInfo(
                handle_self, 
                compilationInfoCallback, 
                UserData.passRetained(callback)
            )
        }
    }

    public func setLabel(_ label: String) {
        self.withUnsafeHandle { handle_self in
            label.withCString { cString_label in
            wgpuShaderModuleSetLabel(
                handle_self, 
                cString_label
            )
            }
        }
    }
}

public class Surface: Object {
    private let handle: WGPUSurface!

    /// Create a wrapper around an existing handle.
    ///
    /// The ownership of the handle is transferred to this class.
    ///
    /// - Parameter handle: The handle to wrap.
    public init(handle: WGPUSurface!) {
        self.handle = handle
    }

    deinit {
        wgpuSurfaceRelease(self.handle)
    }

    /// Calls the given closure with the underlying handle.
    ///
    /// The underlying handle is guaranteed not to be released before the closure returns.
    ///
    /// - Parameter body: A closure to call with the underlying handle.
    public func withUnsafeHandle<R>(_ body: (WGPUSurface) throws -> R) rethrows -> R {
        return try withExtendedLifetime(self) {
            return try body(self.handle)
        }
    }
}

public class SwapChain: Object {
    private let handle: WGPUSwapChain!

    /// Create a wrapper around an existing handle.
    ///
    /// The ownership of the handle is transferred to this class.
    ///
    /// - Parameter handle: The handle to wrap.
    public init(handle: WGPUSwapChain!) {
        self.handle = handle
    }

    deinit {
        wgpuSwapChainRelease(self.handle)
    }

    /// Calls the given closure with the underlying handle.
    ///
    /// The underlying handle is guaranteed not to be released before the closure returns.
    ///
    /// - Parameter body: A closure to call with the underlying handle.
    public func withUnsafeHandle<R>(_ body: (WGPUSwapChain) throws -> R) rethrows -> R {
        return try withExtendedLifetime(self) {
            return try body(self.handle)
        }
    }

    public func configure(format: TextureFormat, allowedUsage: TextureUsage, width: UInt32, height: UInt32) {
        self.withUnsafeHandle { handle_self in
            wgpuSwapChainConfigure(
                handle_self, 
                format.cValue, 
                allowedUsage.rawValue, 
                width, 
                height
            )
        }
    }

    public var currentTextureView: TextureView {
        self.withUnsafeHandle { handle_self in
            let result = wgpuSwapChainGetCurrentTextureView(
                handle_self
            )
            return .init(handle: result)
        }
    }

    public func present() {
        self.withUnsafeHandle { handle_self in
            wgpuSwapChainPresent(
                handle_self
            )
        }
    }
}

public class Texture: Object {
    private let handle: WGPUTexture!

    /// Create a wrapper around an existing handle.
    ///
    /// The ownership of the handle is transferred to this class.
    ///
    /// - Parameter handle: The handle to wrap.
    public init(handle: WGPUTexture!) {
        self.handle = handle
    }

    deinit {
        wgpuTextureRelease(self.handle)
    }

    /// Calls the given closure with the underlying handle.
    ///
    /// The underlying handle is guaranteed not to be released before the closure returns.
    ///
    /// - Parameter body: A closure to call with the underlying handle.
    public func withUnsafeHandle<R>(_ body: (WGPUTexture) throws -> R) rethrows -> R {
        return try withExtendedLifetime(self) {
            return try body(self.handle)
        }
    }

    public func createView(descriptor: TextureViewDescriptor? = nil) -> TextureView {
        self.withUnsafeHandle { handle_self in
            descriptor.withOptionalCStruct { cStruct_descriptor in
            let result = wgpuTextureCreateView(
                handle_self, 
                cStruct_descriptor
            )
            return .init(handle: result)
            }
        }
    }

    public func setLabel(_ label: String) {
        self.withUnsafeHandle { handle_self in
            label.withCString { cString_label in
            wgpuTextureSetLabel(
                handle_self, 
                cString_label
            )
            }
        }
    }

    public func destroy() {
        self.withUnsafeHandle { handle_self in
            wgpuTextureDestroy(
                handle_self
            )
        }
    }
}

public class TextureView: Object {
    private let handle: WGPUTextureView!

    /// Create a wrapper around an existing handle.
    ///
    /// The ownership of the handle is transferred to this class.
    ///
    /// - Parameter handle: The handle to wrap.
    public init(handle: WGPUTextureView!) {
        self.handle = handle
    }

    deinit {
        wgpuTextureViewRelease(self.handle)
    }

    /// Calls the given closure with the underlying handle.
    ///
    /// The underlying handle is guaranteed not to be released before the closure returns.
    ///
    /// - Parameter body: A closure to call with the underlying handle.
    public func withUnsafeHandle<R>(_ body: (WGPUTextureView) throws -> R) rethrows -> R {
        return try withExtendedLifetime(self) {
            return try body(self.handle)
        }
    }

    public func setLabel(_ label: String) {
        self.withUnsafeHandle { handle_self in
            label.withCString { cString_label in
            wgpuTextureViewSetLabel(
                handle_self, 
                cString_label
            )
            }
        }
    }
}

