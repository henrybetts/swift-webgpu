# swift-webgpu

Swift bindings for [WebGPU](https://gpuweb.github.io/gpuweb/); a new graphics and compute API.

Despite being designed for the web, WebGPU can also be used natively, enabling developers with a modern, cross-platform API, without some of the complexities of lower-level graphics libraries.

Efforts are being made to define a standard native version of the API via a [shared header](https://github.com/webgpu-native/webgpu-headers). Note, however, that the specification is still work-in-progress.

Currently, swift-webgpu is based on the [Dawn](https://dawn.googlesource.com/dawn/) implementation, and generated from [dawn.json](https://dawn.googlesource.com/dawn/+/refs/heads/main/src/dawn/dawn.json).


## Requirements

### Dawn

To use swift-webgpu, you'll first need to build Dawn. Assuming you don't need to work on Dawn itself, the easiest way to build it is by following the [Quickstart with CMake guide](https://dawn.googlesource.com/dawn/+/HEAD/docs/quickstart-cmake.md).

swift-webgpu depends on the bundled `libwebgpu_dawn` library, which can be built and installed like so;

```sh
git clone https://dawn.googlesource.com/dawn
cd dawn
cmake -S . -B out/Release -DDAWN_FETCH_DEPENDENCIES=ON -DDAWN_ENABLE_INSTALL=ON -DDAWN_BUILD_SAMPLES=OFF -DCMAKE_BUILD_TYPE=Release
cmake --build out/Release
[sudo] cmake --install out/Release
```

This should install the library and headers to `/usr/local/` - this is probably the simplest way to allow Swift to find the library currently.

On macOS, you may need to correct the install name of the library, like so:

``` sh
sudo install_name_tool -id /usr/local/lib/libwebgpu_dawn.dylib /usr/local/lib/libwebgpu_dawn.dylib
```

Otherwise you will likely need to place the library next to your executable, or configure rpaths appropriately for your executable.


#### pkg-config
You may need to manually create a pkg-config file, depending on which tools you are using. For example, running `swift build` directly from the command line seems to search `/usr/local/` automatically, whereas building with Xcode does not. If you run into this issue, create a file at `/usr/local/lib/pkgconfig/webgpu.pc` with the following contents;
```
prefix=/usr/local
includedir=${prefix}/include
libdir=${prefix}/lib

Cflags: -I${includedir}
Libs: -L${libdir} -lwebgpu_dawn
```  

#### dawn.json
This file contains a description of the WebGPU native API. By default, swift-webgpu will look for it in `/usr/local/share/dawn/`, so you will need to copy it there manually;
```sh
sudo install -d /usr/local/share/dawn
sudo install src/dawn/dawn.json /usr/local/share/dawn/
```

Alternatively, you can specify a `DAWN_JSON` environment variable when building swift-webgpu.


## Running the Demos

First, clone this project;

```sh
git clone https://github.com/henrybetts/swift-webgpu.git
cd swift-webgpu
```

Build the package (assuming that Dawn is installed and Swift can find it automatically);
```sh
swift build -c release
```

Otherwise, you may need to specify the search paths manually;
```sh
DAWN_JSON=/path/to/dawn/src/dawn/dawn.json \
swift build -c release \
-Xcc -I/path/to/dawn/include \
-Xcc -I/path/to/dawn/out/Release/gen/include \
-Xlinker -L/path/to/dawn/out/Release/src/dawn/native \
-Xlinker -rpath -Xlinker /path/to/dawn/out/Release/src/dawn/native
```

Finally, run the demos;

```sh
cd .build/release
./DemoInfo
./DemoClearColor
./DemoTriangle
./DemoCube
./DemoBoids
```


## Installation

To use swift-webgpu with Swift Package Manager, add it to your `Package.swift` file's dependencies;

```swift
.package(url: "https://github.com/henrybetts/swift-webgpu.git", branch: "main")
```

Then add `WebGPU` as a dependency of your target;

```swift
.executableTarget(
    name: "MyApp",
    dependencies: [.product(name: "WebGPU", package: "swift-webgpu")],
),
```


## Basic Usage

Import the WebGPU module where needed;

```swift
import WebGPU
```

A typical application will start by creating an `Instance`, requesting an `Adapter`, and then requesting a `Device`. For example;

```swift
// create an instance
let instance = createInstance()

// find an adapter
let adapter = try await instance.requestAdapter()
print("Using adapter: \(adapter.info.device)")

// create a device
let device = try await adapter.requestDevice()
```

You'll usually want to set an error handler, to log any errors produced by the device;

```swift
let uncapturedErrorCallback: UncapturedErrorCallback = { device, errorType, errorMessage in
    print("Error (\(errorType)): \(errorMessage)")
}

let device = try await adapter.requestDevice(descriptor: .init(
    uncapturedErrorCallback: uncapturedErrorCallback
))
```

With the device obtained, you can create most of the other types of WebGPU objects. A shader module, for example;

```swift
let shaderModule = device.createShaderModule(
  descriptor: .init(
    nextInChain: ShaderSourceWgsl(
      code: """
        @vertex
        fn vertexMain() -> @builtin(position) vec4f {
          return vec4f(0, 0, 0, 1);
        }
         
        @fragment
        fn fragmentMain() -> @location(0) vec4f {
          return vec4f(1, 0, 0, 1);
        }
      """
    )
  )
)
```

Or a render pipeline;

```swift
let renderPipeline = device.createRenderPipeline(
  descriptor: .init(
    vertex: VertexState(
      module: shaderModule,
      entryPoint: "vertexMain"
    ),
    fragment: FragmentState(
      module: shaderModule,
      entryPoint: "fragmentMain",
      targets: [ColorTargetState(format: .bgra8Unorm)]
    )
  )
)
```

Most objects are created with a descriptor. In some cases, WebGPU uses a chainable struct pattern to support future extensions or platform specific features. This is indicated by the `nextInChain` property. (There is scope to improve the ergonomics of this in Swift.)

See the demos for further usage examples.
