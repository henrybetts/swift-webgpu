// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-webgpu",
    products: [
        .library(
            name: "WebGPU",
            targets: ["WebGPU"]),
    ],
    dependencies: [
    ],
    targets: [
        .systemLibrary(
            name: "CWebGPU"),
        .target(
            name: "WebGPU",
            dependencies: ["CWebGPU"]),
    ]
)
