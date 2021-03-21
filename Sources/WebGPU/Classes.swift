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

    public func mapAsync(mode: MapMode, offset: Int, size: Int, callback: WGPUBufferMapCallback, userdata: UnsafeMutableRawPointer!) {
    }

    public func getMappedRange(offset: Int, size: Int) -> UnsafeMutableRawPointer! {
    }

    public func getConstMappedRange(offset: Int, size: Int) -> UnsafeRawPointer! {
    }

    public func unmap() {
    }

    public func destroy() {
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

    public func finish(descriptor: CommandBufferDescriptor?) -> CommandBuffer {
    }

    public func beginComputePass(descriptor: ComputePassDescriptor?) -> ComputePassEncoder {
    }

    public func beginRenderPass(descriptor: RenderPassDescriptor) -> RenderPassEncoder {
    }

    public func copyBufferToBuffer(source: Buffer, sourceOffset: UInt64, destination: Buffer, destinationOffset: UInt64, size: UInt64) {
    }

    public func copyBufferToTexture(source: BufferCopyView, destination: TextureCopyView, copySize: Extent3d) {
    }

    public func copyTextureToBuffer(source: TextureCopyView, destination: BufferCopyView, copySize: Extent3d) {
    }

    public func copyTextureToTexture(source: TextureCopyView, destination: TextureCopyView, copySize: Extent3d) {
    }

    public func injectValidationError(message: String) {
    }

    public func insertDebugMarker(markerLabel: String) {
    }

    public func popDebugGroup() {
    }

    public func pushDebugGroup(groupLabel: String) {
    }

    public func resolveQuerySet(querySet: QuerySet, firstQuery: UInt32, queryCount: UInt32, destination: Buffer, destinationOffset: UInt64) {
    }

    public func writeTimestamp(querySet: QuerySet, queryIndex: UInt32) {
    }
}

public class ComputePassEncoder {
    let object: WGPUComputePassEncoder!

    init(object: WGPUComputePassEncoder!) {
        self.object = object
    }

    public func insertDebugMarker(markerLabel: String) {
    }

    public func popDebugGroup() {
    }

    public func pushDebugGroup(groupLabel: String) {
    }

    public func setPipeline(pipeline: ComputePipeline) {
    }

    public func setBindGroup(groupIndex: UInt32, group: BindGroup, dynamicOffsets: [UInt32]?) {
    }

    public func writeTimestamp(querySet: QuerySet, queryIndex: UInt32) {
    }

    public func dispatch(x: UInt32, y: UInt32, z: UInt32) {
    }

    public func dispatchIndirect(indirectBuffer: Buffer, indirectOffset: UInt64) {
    }

    public func endPass() {
    }
}

public class ComputePipeline {
    let object: WGPUComputePipeline!

    init(object: WGPUComputePipeline!) {
        self.object = object
    }

    public func getBindGroupLayout(groupIndex: UInt32) -> BindGroupLayout {
    }
}

public class Device {
    let object: WGPUDevice!

    init(object: WGPUDevice!) {
        self.object = object
    }

    public func createBindGroup(descriptor: BindGroupDescriptor) -> BindGroup {
    }

    public func createBindGroupLayout(descriptor: BindGroupLayoutDescriptor) -> BindGroupLayout {
    }

    public func createBuffer(descriptor: BufferDescriptor) -> Buffer {
    }

    public func createErrorBuffer() -> Buffer {
    }

    public func createCommandEncoder(descriptor: CommandEncoderDescriptor?) -> CommandEncoder {
    }

    public func createComputePipeline(descriptor: ComputePipelineDescriptor) -> ComputePipeline {
    }

    public func createComputePipelineAsync(descriptor: ComputePipelineDescriptor, callback: WGPUCreateComputePipelineAsyncCallback, userdata: UnsafeMutableRawPointer!) {
    }

    public func createPipelineLayout(descriptor: PipelineLayoutDescriptor) -> PipelineLayout {
    }

    public func createQuerySet(descriptor: QuerySetDescriptor) -> QuerySet {
    }

    public func createRenderPipelineAsync(descriptor: RenderPipelineDescriptor, callback: WGPUCreateRenderPipelineAsyncCallback, userdata: UnsafeMutableRawPointer!) {
    }

    public func createRenderBundleEncoder(descriptor: RenderBundleEncoderDescriptor) -> RenderBundleEncoder {
    }

    public func createRenderPipeline(descriptor: RenderPipelineDescriptor) -> RenderPipeline {
    }

    public func createSampler(descriptor: SamplerDescriptor?) -> Sampler {
    }

    public func createShaderModule(descriptor: ShaderModuleDescriptor) -> ShaderModule {
    }

    public func createSwapChain(surface: Surface?, descriptor: SwapChainDescriptor) -> SwapChain {
    }

    public func createTexture(descriptor: TextureDescriptor) -> Texture {
    }

    public func getQueue() -> Queue {
    }

    public func getDefaultQueue() -> Queue {
    }

    public func injectError(type: ErrorType, message: String) {
    }

    public func loseForTesting() {
    }

    public func tick() {
    }

    public func setUncapturedErrorCallback(callback: WGPUErrorCallback, userdata: UnsafeMutableRawPointer!) {
    }

    public func setDeviceLostCallback(callback: WGPUDeviceLostCallback, userdata: UnsafeMutableRawPointer!) {
    }

    public func pushErrorScope(filter: ErrorFilter) {
    }

    public func popErrorScope(callback: WGPUErrorCallback, userdata: UnsafeMutableRawPointer!) -> Bool {
    }
}

public class Fence {
    let object: WGPUFence!

    init(object: WGPUFence!) {
        self.object = object
    }

    public func getCompletedValue() -> UInt64 {
    }

    public func onCompletion(value: UInt64, callback: WGPUFenceOnCompletionCallback, userdata: UnsafeMutableRawPointer!) {
    }
}

public class Instance {
    let object: WGPUInstance!

    init(object: WGPUInstance!) {
        self.object = object
    }

    public func createSurface(descriptor: SurfaceDescriptor) -> Surface {
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
    }
}

public class Queue {
    let object: WGPUQueue!

    init(object: WGPUQueue!) {
        self.object = object
    }

    public func submit(commands: [CommandBuffer]) {
    }

    public func signal(fence: Fence, signalValue: UInt64) {
    }

    public func createFence(descriptor: FenceDescriptor?) -> Fence {
    }

    public func onSubmittedWorkDone(signalValue: UInt64, callback: WGPUQueueWorkDoneCallback, userdata: UnsafeMutableRawPointer!) {
    }

    public func writeBuffer(buffer: Buffer, bufferOffset: UInt64, data: [Void]) {
    }

    public func writeTexture(destination: TextureCopyView, data: [Void], dataLayout: TextureDataLayout, writeSize: Extent3d) {
    }

    public func copyTextureForBrowser(source: TextureCopyView, destination: TextureCopyView, copySize: Extent3d, options: CopyTextureForBrowserOptions) {
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

    public func setPipeline(pipeline: RenderPipeline) {
    }

    public func setBindGroup(groupIndex: UInt32, group: BindGroup, dynamicOffsets: [UInt32]?) {
    }

    public func draw(vertexCount: UInt32, instanceCount: UInt32, firstVertex: UInt32, firstInstance: UInt32) {
    }

    public func drawIndexed(indexCount: UInt32, instanceCount: UInt32, firstIndex: UInt32, baseVertex: Int32, firstInstance: UInt32) {
    }

    public func drawIndirect(indirectBuffer: Buffer, indirectOffset: UInt64) {
    }

    public func drawIndexedIndirect(indirectBuffer: Buffer, indirectOffset: UInt64) {
    }

    public func insertDebugMarker(markerLabel: String) {
    }

    public func popDebugGroup() {
    }

    public func pushDebugGroup(groupLabel: String) {
    }

    public func setVertexBuffer(slot: UInt32, buffer: Buffer, offset: UInt64, size: UInt64) {
    }

    public func setIndexBuffer(buffer: Buffer, format: IndexFormat, offset: UInt64, size: UInt64) {
    }

    public func setIndexBufferWithFormat(buffer: Buffer, format: IndexFormat, offset: UInt64, size: UInt64) {
    }

    public func finish(descriptor: RenderBundleDescriptor?) -> RenderBundle {
    }
}

public class RenderPassEncoder {
    let object: WGPURenderPassEncoder!

    init(object: WGPURenderPassEncoder!) {
        self.object = object
    }

    public func setPipeline(pipeline: RenderPipeline) {
    }

    public func setBindGroup(groupIndex: UInt32, group: BindGroup, dynamicOffsets: [UInt32]?) {
    }

    public func draw(vertexCount: UInt32, instanceCount: UInt32, firstVertex: UInt32, firstInstance: UInt32) {
    }

    public func drawIndexed(indexCount: UInt32, instanceCount: UInt32, firstIndex: UInt32, baseVertex: Int32, firstInstance: UInt32) {
    }

    public func drawIndirect(indirectBuffer: Buffer, indirectOffset: UInt64) {
    }

    public func drawIndexedIndirect(indirectBuffer: Buffer, indirectOffset: UInt64) {
    }

    public func executeBundles(bundles: [RenderBundle]) {
    }

    public func insertDebugMarker(markerLabel: String) {
    }

    public func popDebugGroup() {
    }

    public func pushDebugGroup(groupLabel: String) {
    }

    public func setStencilReference(reference: UInt32) {
    }

    public func setBlendColor(color: Color) {
    }

    public func setViewport(x: Float, y: Float, width: Float, height: Float, minDepth: Float, maxDepth: Float) {
    }

    public func setScissorRect(x: UInt32, y: UInt32, width: UInt32, height: UInt32) {
    }

    public func setVertexBuffer(slot: UInt32, buffer: Buffer, offset: UInt64, size: UInt64) {
    }

    public func setIndexBuffer(buffer: Buffer, format: IndexFormat, offset: UInt64, size: UInt64) {
    }

    public func setIndexBufferWithFormat(buffer: Buffer, format: IndexFormat, offset: UInt64, size: UInt64) {
    }

    public func beginOcclusionQuery(queryIndex: UInt32) {
    }

    public func endOcclusionQuery() {
    }

    public func writeTimestamp(querySet: QuerySet, queryIndex: UInt32) {
    }

    public func endPass() {
    }
}

public class RenderPipeline {
    let object: WGPURenderPipeline!

    init(object: WGPURenderPipeline!) {
        self.object = object
    }

    public func getBindGroupLayout(groupIndex: UInt32) -> BindGroupLayout {
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
    }

    public func getCurrentTextureView() -> TextureView {
    }

    public func present() {
    }
}

public class Texture {
    let object: WGPUTexture!

    init(object: WGPUTexture!) {
        self.object = object
    }

    public func createView(descriptor: TextureViewDescriptor?) -> TextureView {
    }

    public func destroy() {
    }
}

public class TextureView {
    let object: WGPUTextureView!

    init(object: WGPUTextureView!) {
        self.object = object
    }
}

