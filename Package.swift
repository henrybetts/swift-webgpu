// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "swift-webgpu",
    platforms: [.macOS("10.11")],
    products: [
        .library(
            name: "WebGPU",
            targets: ["WebGPU"]),
        .library(
            name: "DawnNative",
            targets: ["DawnNative", "WebGPU"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SwiftGL/Math.git", .branch("master")) // for demos only
    ],
    targets: [
        .systemLibrary(
            name: "CWebGPU"),
        .target(
            name: "WebGPU",
            dependencies: ["CWebGPU"]),
        
        .systemLibrary(
            name: "CDawnProc"),
        .target(
            name: "CDawnNative",
            linkerSettings: [
                .linkedLibrary("dawn_native")]),
        .target(
            name: "DawnNative",
            dependencies: ["WebGPU", "CDawnProc", "CDawnNative"]),
        
        .systemLibrary(
            name: "CGLFW",
            path: "Demos/CGLFW",
            pkgConfig: "glfw3",
            providers: [
                .brew(["glfw"])]),
        .target(
            name: "WindowUtils",
            dependencies: ["WebGPU", "CGLFW"],
            path: "Demos/WindowUtils"),
        .target(
            name: "DemoInfo",
            dependencies: ["DawnNative"],
            path: "Demos/DemoInfo"),
        .target(
            name: "DemoClearColor",
            dependencies: ["DawnNative", "WindowUtils"],
            path: "Demos/DemoClearColor"),
        .target(
            name: "DemoTriangle",
            dependencies: ["DawnNative", "WindowUtils"],
            path: "Demos/DemoTriangle"),
        .target(
            name: "DemoCube",
            dependencies: ["DawnNative", "WindowUtils", "SGLMath"],
            path: "Demos/DemoCube"),
    ],
    cxxLanguageStandard: .cxx11
)
