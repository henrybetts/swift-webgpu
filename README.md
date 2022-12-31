# swift-webgpu

Swift bindings for [WebGPU](https://gpuweb.github.io/gpuweb/); a new graphics and compute API.

Despite being designed for the web, WebGPU can also be used natively, enabling developers with a modern, cross-platform API, without some of the complexities of lower-level graphics libraries.

Efforts are being made to define a standard native version of the API via a [shared header](https://github.com/webgpu-native/webgpu-headers). Note, however, that the specification is still work-in-progress.

Currently, swift-webgpu is based on the [Dawn](https://dawn.googlesource.com/dawn/) implementation, and generated from [dawn.json](https://dawn.googlesource.com/dawn/+/refs/heads/main/dawn.json).


## Requirements

### Dawn

To use swift-webgpu, you'll first need to build Dawn. See Dawn's [documentation](https://dawn.googlesource.com/dawn/+/HEAD/docs/building.md) to get started.

swift-webgpu depends on the `libwebgpu_dawn` and `libdawn_native` shared libraries, which can be built like so;

```sh
mkdir -p out/Release
cd out/Release
cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=1 ../..
make # -j N for N-way parallel build
```


## Running the Demos

First, clone this project;

```sh
git clone https://github.com/henrybetts/swift-webgpu.git
cd swift-webgpu
```

Build the package;

```sh
DAWN_JSON=/path/to/dawn/dawn.json \
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
    dependencies: ["WebGPU"],
    linkerSettings: [.linkedLibrary("webgpu_dawn")]
),
```


## Basic Usage

Import the WebGPU module where needed;

```swift
import WebGPU
```

A typical application will start by creating an `Instance`, requesting an `Adapter`, and then requesting a `Device`. However, some of the specification is not yet implemented in Dawn, particularly regarding these initialization steps. Therefore, the `DawnNative` module exists for the time being, providing an entry point to the rest of the WebGPU API. For example;

```swift
import DawnNative

// create an instance
let instance = DawnNative.Instance()

// find an adapter
instance.discoverDefaultAdapters()
guard let adapter = instance.adapters.first else {
    fatalError("No adapters found")
}
print("Using adapter: \(adapter.properties.name)")

// create a WebGPU.Device
guard let device = adapter.createDevice() else {
    fatalError("Failed to create device")
}
```

See the demos for further usage examples.
