import SwiftUI
import WebGPU
import MetalKit



#if canImport(UIKit)
import UIKit
#else//macos
import AppKit
typealias UIView = NSView
typealias UIColor = NSColor
typealias UIRect = NSRect
typealias UIViewRepresentable = NSViewRepresentable
#endif


//	callback from low-level (metal)view when its time to render
protocol ContentRenderer
{
	func Render(contentRect:CGRect,layer:CAMetalLayer)
}


//	persistent interface to webgpu for use with a [WebGpu]View
public class WebGpuRenderer
{
	var webgpu : WebGPU.Instance = createInstance()
	var device : Device?
	var windowTextureFormat = TextureFormat.bgra8Unorm

	var initTask : Task<Void,any Error>!
	var error : String?
	
	init()
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
	
	
	
	func Render(metalLayer:CAMetalLayer,getCommands:(Device,CommandEncoder,TextureView)->()) throws
	{
		guard let device else
		{
			throw RuntimeError("Waiting for device")
		}
		
		let FinalChainSurface = SurfaceSourceMetalLayer(
			layer: Unmanaged.passUnretained(metalLayer).toOpaque()
		)
		
		var surfaceDesc = SurfaceDescriptor()
		surfaceDesc.nextInChain = FinalChainSurface
		let surface = webgpu.createSurface(descriptor: surfaceDesc)
		surface.configure(config: .init(device: device, format: windowTextureFormat, width: 800, height: 600))
		
		let surfaceView = try surface.getCurrentTexture().texture.createView()
		
		let encoder = device.createCommandEncoder()
		
		
		//	let caller provide render commands
		getCommands(device,encoder,surfaceView)
		
		
		let commandBuffer = encoder.finish()
		device.queue.submit(commands: [commandBuffer])
		
		surface.present()
	}
}



//	our own abstracted low level view, so we can get access to the layer
class RenderView : UIView
{
	//var wantsLayer: Bool	{	return true	}
	//	gr: don't seem to need this
	//override var wantsUpdateLayer: Bool { return true	}
	public var contentRenderer : ContentRenderer
	//var vsync : VSyncer? = nil
	
#if os(macOS)
	override var isFlipped: Bool { return true	}
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
	override func layout()
	{
		super.layout()
		OnContentsChanged()
	}
#else
	override func layoutSubviews()
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
	
	@objc func Render()
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
	typealias NSViewType = RenderView
	
	var contentRenderer : ContentRenderer
	
	var renderView : RenderView?
	
	init(contentRenderer:ContentRenderer)
	{
		self.contentRenderer = contentRenderer
		//contentLayer.contentsGravity = .resizeAspect
	}
	
	func makeUIView(context: Context) -> RenderView
	{
		let view = RenderView(contentRenderer: contentRenderer)
		return view
	}
	
	func makeNSView(context: Context) -> RenderView
	{
		let view = RenderView(contentRenderer: contentRenderer)
		return view
	}
	
	//	gr: this occurs when the RenderViewRep() is re-initialised, (from uiview redraw)
	//		but the UIView underneath has persisted
	func updateUIView(_ view: RenderView, context: Context)
	{
		view.contentRenderer = self.contentRenderer
	}
	
	func updateNSView(_ view: RenderView, context: Context)
	{
		updateUIView(view,context: context)
	}
}



