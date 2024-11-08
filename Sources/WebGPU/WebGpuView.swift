import SwiftUI
import MetalKit

//	macos -> ios aliases to make things a little cleaner to write
#if canImport(UIKit)
import UIKit
#else//macos
import AppKit
public typealias UIView = NSView
public typealias UIColor = NSColor
public typealias UIRect = NSRect
public typealias UIViewRepresentable = NSViewRepresentable
#endif


struct RenderError: LocalizedError
{
	let description: String
	
	init(_ description: String) {
		self.description = description
	}
	
	var errorDescription: String? {
		description
	}
}



//	callback from low-level (metal)view when its time to render
public protocol ContentRenderer
{
	func Render(contentRect:CGRect,layer:CAMetalLayer)
}


//	persistent interface to webgpu for use with a [WebGpu]View
public class WebGpuRenderer
{
	var webgpu : WebGPU.Instance = createInstance()
	public var device : Device?
	var windowTextureFormat = TextureFormat.bgra8Unorm

	var initTask : Task<Void,any Error>!
	var error : String?
	
	public init()
	{
		//super.init()
		
		initTask = Task
		{
			try await Init()
		}
	}
	
	func OnError(_ error:String)
	{
		print("CameraPreviewManager error; \(error)")
		self.error = error
	}
	
	func OnDeviceUncapturedError(errorType:ErrorType,errorMessage:String)
	{
		OnError("\(errorType)/\(errorMessage)")
	}
	
	func Init() async throws
	{
		let adapter = try await webgpu.requestAdapter()
		print("Using adapter: \(adapter.info.device)")
		
		self.device = try await adapter.requestDevice()
		device!.setUncapturedErrorCallback(OnDeviceUncapturedError)
	}
	
	
	public func Render(metalLayer:CAMetalLayer,getCommands:(Device,CommandEncoder,Texture)throws->()) throws
	{
		guard let device else
		{
			throw RenderError("Waiting for device")
		}
		
		let FinalChainSurface = SurfaceSourceMetalLayer(
			layer: Unmanaged.passUnretained(metalLayer).toOpaque()
		)
		
		var surfaceDesc = SurfaceDescriptor()
		surfaceDesc.nextInChain = FinalChainSurface
		let surface = webgpu.createSurface(descriptor: surfaceDesc)
		surface.configure(config: .init(device: device, format: windowTextureFormat, width: 800, height: 600))
		
		let surfaceTexture = try surface.getCurrentTexture().texture
		let surfaceView = surfaceTexture.createView()
		
		let encoder = device.createCommandEncoder()
		
		
		//	let caller provide render commands
		try getCommands(device,encoder,surfaceTexture)
		
		
		let commandBuffer = encoder.finish()
		device.queue.submit(commands: [commandBuffer])
		
		surface.present()
	}
}



//	our own abstracted low level view, so we can get access to the layer
public class RenderView : UIView
{
	//var wantsLayer: Bool	{	return true	}
	//	gr: don't seem to need this
	//override var wantsUpdateLayer: Bool { return true	}
	var contentRenderer : ContentRenderer
	
	//	todo: reinstate vsync auto-renderer from https://github.com/NewChromantics/PopLottie.SwiftPackage
	//var vsync : VSyncer? = nil
	
#if os(macOS)
	public override var isFlipped: Bool { return true	}
#endif
	
	required init?(coder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
	
	//	on macos this is CALayer? on ios, it's just CALayer. So this little wrapper makes them the same
	var viewLayer : CALayer?
	{
		return self.layer
	}
	
	var metalLayer : CAMetalLayer
	{
		return (self.viewLayer as! CAMetalLayer?)!
	}
	
	
	init(contentRenderer:ContentRenderer)
	{
		self.contentRenderer = contentRenderer
		
		super.init(frame: .zero)
		// Make this a layer-hosting view. First set the layer, then set wantsLayer to true.
		
#if os(macOS)
		wantsLayer = true
		//self.needsLayout = true
#endif
		self.layer = CAMetalLayer()
		//viewLayer!.addSublayer(metalLayer)
		
		//vsync = VSyncer(Callback: Render)
	}
	
	
#if os(macOS)
	public override func layout()
	{
		super.layout()
		OnContentsChanged()
	}
#else
	public override func layoutSubviews()
	{
		super.layoutSubviews()
		OnContentsChanged()
	}
#endif
	
	func OnContentsChanged()
	{
		let contentRect = self.bounds
		
		//	render
		contentRenderer.Render(contentRect: contentRect, layer:metalLayer)
	}
	
	//	gr: why did I need @objc...
	@objc public func Render()
	{
		//self.layer?.setNeedsDisplay()
		OnContentsChanged()
	}
	
}

/*
	Actual View for swiftui
*/
public struct WebGpuView : UIViewRepresentable
{
	typealias UIViewType = RenderView
	public typealias NSViewType = RenderView
	
	var contentRenderer : ContentRenderer
	
	var renderView : RenderView?
	
	public init(contentRenderer:ContentRenderer)
	{
		self.contentRenderer = contentRenderer
		//contentLayer.contentsGravity = .resizeAspect
	}
	
	public func makeUIView(context: Context) -> RenderView
	{
		let view = RenderView(contentRenderer: contentRenderer)
		return view
	}
	
	public func makeNSView(context: Context) -> RenderView
	{
		let view = RenderView(contentRenderer: contentRenderer)
		return view
	}
	
	//	gr: this occurs when the RenderViewRep() is re-initialised, (from uiview redraw)
	//		but the UIView underneath has persisted
	public func updateUIView(_ view: RenderView, context: Context)
	{
		view.contentRenderer = self.contentRenderer
	}
	
	public func updateNSView(_ view: RenderView, context: Context)
	{
		updateUIView(view,context: context)
	}
}



