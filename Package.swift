// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "swift-webgpu",
    platforms: [.macOS("10.15")],
    products: [
        .library(
            name: "WebGPU",
            targets: ["WebGPU"]),
        .library(
            name: "DawnNative",
            targets: ["DawnNative", "WebGPU"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
        .package(url: "https://github.com/SwiftGFX/SwiftMath", from: "3.3.0") // for demos only
    ],
    targets: [
        .systemLibrary(
            name: "CWebGPU"
        ),
        .target(
            name: "WebGPU",
            dependencies: ["CWebGPU"],
            plugins: [.plugin(name: "GenerateWebGPUPlugin")]
        ),
        
        .target(
            name: "CDawnNative",
            linkerSettings: [
                .linkedLibrary("dawn_native")]
        ),
        .target(
            name: "DawnNative",
            dependencies: ["WebGPU", "CDawnNative"]
        ),
        .systemLibrary(
            name: "CDawnProc"
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
        
        .executableTarget(
            name: "DemoInfo",
            dependencies: ["DawnNative"],
            path: "Demos/DemoInfo",
            linkerSettings: [.linkedLibrary("webgpu_dawn")]
        ),
        .executableTarget(
            name: "DemoClearColor",
            dependencies: ["WindowUtils"],
            path: "Demos/DemoClearColor",
            linkerSettings: [.linkedLibrary("webgpu_dawn")]
        ),
        .executableTarget(
            name: "DemoTriangle",
            dependencies: ["WindowUtils"],
            path: "Demos/DemoTriangle",
            linkerSettings: [.linkedLibrary("webgpu_dawn")]
        ),
        .executableTarget(
            name: "DemoCube",
            dependencies: ["WindowUtils", "SwiftMath"],
            path: "Demos/DemoCube",
            linkerSettings: [.linkedLibrary("webgpu_dawn")]
        ),
        .executableTarget(
            name: "DemoBoids",
            dependencies: ["WindowUtils"],
            path: "Demos/DemoBoids",
            linkerSettings: [.linkedLibrary("webgpu_dawn")]
        )
    ],
    cxxLanguageStandard: .cxx17
)
