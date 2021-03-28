// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "swift-webgpu",
    products: [
        .library(
            name: "WebGPU",
            targets: ["WebGPU"]),
        .executable(
            name: "DemoInfo",
            targets: ["DemoInfo"]),
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
        .target(
            name: "DemoInfo",
            dependencies: ["WebGPU"],
            path: "Demos/DemoInfo"),
    ],
    cxxLanguageStandard: .cxx11
)
