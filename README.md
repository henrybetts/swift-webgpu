# swift-webgpu

Swift bindings for [WebGPU](https://gpuweb.github.io/gpuweb/); a new graphics and compute API.

Despite being designed for the web, WebGPU can also be used natively, enabling developers with a modern, cross-platform API, without some of the complexities of lower-level graphics libraries.

Efforts are being made to define a standard native version of the API via a [shared header](https://github.com/webgpu-native/webgpu-headers). Note, however, that the specification is still work-in-progress.

Currently, swift-webgpu is based on the [Dawn](https://dawn.googlesource.com/dawn/) implementation, and generated from [dawn.json](https://dawn.googlesource.com/dawn/+/refs/heads/main/dawn.json).


## Requirements

### Dawn

To use swift-webgpu, you'll first need to build Dawn. See Dawn's [documentation](https://dawn.googlesource.com/dawn/+/HEAD/docs/building.md) to get started.

swift-webgpu depends on the `libwebgpu_dawn` shared library, which can be built like so;

```sh
mkdir -p out/Release
cd out/Release
cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=1 -GNinja ../..
ninja webgpu_dawn
```


## Running the Demos

First, clone this project;

```sh
git clone https://github.com/henrybetts/swift-webgpu.git
cd swift-webgpu
```

Build the package;

```sh
DAWN_JSON=/path/to/dawn/src/dawn/dawn.json \
swift build -c release \
-Xcc -I/path/to/dawn/include \
-Xcc -I/path/to/dawn/out/Release/gen/include \
-Xlinker -L/path/to/dawn/out/Release/src/dawn/native \
-Xlinker -rpath -Xlinker /path/to/dawn/out/Release/src/dawn/native
```

Remember to replace `/path/to/dawn` with the actual path to the dawn directory. These arguments tell the compiler where to find the dawn headers, and the linker where to find the shared libraries. The `DAWN_JSON` variable defines the location of `dawn.json`, which is needed for code generation.

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
.package(url: "https://github.com/henrybetts/swift-webgpu.git", branch: "master")
```

Then add `WebGPU` as a dependency of your target, and link the `webgpu_dawn` library;

```swift
.executableTarget(
    name: "MyApp",
    dependencies: [.product(name: "WebGPU", package: "swift-webgpu")],
    linkerSettings: [.linkedLibrary("webgpu_dawn")]
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
print("Using adapter: \(adapter.properties.name)")

// create a device
let device = try await adapter.requestDevice()
```

You'll usually want to set an error handler, to log any errors produced by the device;

```swift
device.setUncapturedErrorCallback { (errorType, errorMessage) in
  print("Error (\(errorType)): \(errorMessage)")
}
```

With the device obtained, you can create most of the other types of WebGPU objects. A shader module, for example;

```swift
let shaderModule = device.createShaderModule(
  descriptor: .init(
    nextInChain: ShaderModuleWgslDescriptor(
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
