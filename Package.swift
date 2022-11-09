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
        .package(url: "https://github.com/SwiftGFX/SwiftMath", from: "3.3.0") // for demos only
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
        .target(
            name: "GenerateWebGPU"),
        
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
            dependencies: ["DawnNative", "WindowUtils", "SwiftMath"],
            path: "Demos/DemoCube"),
    ],
    cxxLanguageStandard: .cxx14
)
