import CGLFW
import WebGPU

#if os(macOS)
    import AppKit
#endif

public func withGLFW<R>(_ body: () throws -> R) rethrows -> R {
    glfwInit()
    defer { glfwTerminate() }
    return try body()
}

public class Window {
    let handle: OpaquePointer!
    
    public init(width: Int, height: Int, title: String) {
        glfwWindowHint(GLFW_CLIENT_API, GLFW_NO_API)
        handle = glfwCreateWindow(Int32(width), Int32(height), title, nil, nil)
    }
    
    deinit {
        glfwDestroyWindow(handle)
    }
    
    public var surfaceDescriptor: SurfaceDescriptor {
        var surfaceDescriptor = SurfaceDescriptor()
        
        #if os(macOS)
            let nsWindow = glfwGetCocoaWindow(handle) as! NSWindow
            let view = nsWindow.contentView!
        
            if view.layer == nil {
                view.wantsLayer = true
                view.layer = CAMetalLayer()
            }
                
            surfaceDescriptor.nextInChain = SurfaceDescriptorFromMetalLayer(
                layer: Unmanaged.passUnretained(view.layer!).toOpaque()
            )
        #elseif os(Linux)
            surfaceDescriptor.nextInChain = SurfaceDescriptorFromXlib(
                    display: UnsafeMutableRawPointer(glfwGetX11Display()),
                    window: UInt32(glfwGetX11Window(handle)))
        #endif
        
        return surfaceDescriptor
    }
    
    public var preferredTextureFormat: TextureFormat {
        return .bgra8Unorm
    }
    
    public var shouldClose: Bool {
        return glfwWindowShouldClose(handle) == GLFW_TRUE
    }
}

public func pollEvents() {
    glfwPollEvents()
}

