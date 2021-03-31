// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "swift-webgpu",
    platforms: [.macOS("10.11")],
    products: [
        .library(
            name: "WebGPU",
            targets: ["WebGPU"]),
        .executable(
            name: "DemoInfo",
            targets: ["DemoInfo"]),
        .executable(
            name: "DemoClearColor",
            targets: ["DemoClearColor"]),
    ],
    dependencies: [
    ],
    targets: [
        .systemLibrary(
            name: "CWebGPU"),
        .systemLibrary(
            name: "CDawnProc"),
        .target(
            name: "CDawnNative",
            linkerSettings: [
                .linkedLibrary("dawn_native")]),
        .target(
            name: "WebGPU",
            dependencies: ["CWebGPU", "CDawnProc", "CDawnNative"]),
        
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
            dependencies: ["WebGPU"],
            path: "Demos/DemoInfo"),
        .target(
            name: "DemoClearColor",
            dependencies: ["WebGPU", "WindowUtils"],
            path: "Demos/DemoClearColor"),
        .target(
            name: "DemoTriangle",
            dependencies: ["WebGPU", "WindowUtils"],
            path: "Demos/DemoTriangle"),
    ],
    cxxLanguageStandard: .cxx11
)
