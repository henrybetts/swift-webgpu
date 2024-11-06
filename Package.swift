// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "swift-webgpu",
    platforms: [.macOS("10.15")],
    products: [
        .library(
			name: "WebGPU",
			//	webgpu needs the dawnframework as that contains webgpu headers
            targets: ["WebGPU","DawnFramework"]),
        .library(
            name: "DawnNative",
			targets: ["DawnNative","DawnFramework","WebGPU"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
        .package(url: "https://github.com/SwiftGFX/SwiftMath", from: "3.3.0") // for demos only
    ],
    targets: [
        .target(
            name: "CWebGPU",
			//,
            //pkgConfig: "webgpu"
			dependencies: ["DawnFramework"],
			//	gr: this compiles ALL the headers, including cpp ones, which seem to need to be C??
			//		this works though! just include webgpu/webgpu.h
			publicHeadersPath:"webgpu",
			cxxSettings: [
				//.headerSearchPath("./"),	//	this allows headers in same place as .cpp
				//.headerSearchPath("../DawnNative/webgpu_dawn.xcframework/macos-arm64/Headers"),
			]
        ),
        .target(
            name: "WebGPU",
            dependencies: ["DawnFramework","CWebGPU"],
            plugins: [.plugin(name: "GenerateWebGPUPlugin")]
        ),
        
        .target(
            name: "CDawnNative",
            dependencies: ["DawnFramework","CWebGPU"]
		),
        .target(
            name: "DawnNative",
            dependencies: ["DawnFramework","WebGPU", "CDawnNative"]
		),
        
        .executableTarget(
            name: "generate-webgpu",
            dependencies: [.product(name: "ArgumentParser", package: "swift-argument-parser")]
        ),
        .plugin(
            name: "GenerateWebGPUPlugin",
            capability: .buildTool(),
            dependencies: ["generate-webgpu"]
        ),
        
        .systemLibrary(
            name: "CGLFW",
            path: "Demos/CGLFW",
            pkgConfig: "glfw3",
            providers: [
                .brew(["glfw"])]
        ),
        .target(
            name: "WindowUtils",
            dependencies: ["WebGPU", "CGLFW"],
            path: "Demos/WindowUtils"
        ),
        
		.binaryTarget(
			name: "DawnFramework",
			path: "Sources/DawnNative/webgpu_dawn.xcframework"
			//url: "https://github.com/NewChromantics/PopH264/releases/download/v1.3.41/PopH264.xcframework.zip",
			//checksum: "8a378470a2ab720f2ee6ecf4e7a5e202a3674660c31e43d95d672fe76d61d68c"
		),
		
        .executableTarget(
            name: "DemoInfo",
            dependencies: ["DawnNative"],
            path: "Demos/DemoInfo"
        ),
        .executableTarget(
            name: "DemoClearColor",
            dependencies: ["WindowUtils"],
            path: "Demos/DemoClearColor"
        ),
        .executableTarget(
            name: "DemoTriangle",
            dependencies: ["WindowUtils"],
            path: "Demos/DemoTriangle"
        ),
        .executableTarget(
            name: "DemoCube",
            dependencies: ["WindowUtils", "SwiftMath"],
            path: "Demos/DemoCube"
        ),
        .executableTarget(
            name: "DemoBoids",
            dependencies: ["WindowUtils"],
            path: "Demos/DemoBoids"
        )
    ],
    cxxLanguageStandard: .cxx17
)
