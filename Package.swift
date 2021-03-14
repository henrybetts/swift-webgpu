// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-wgpu",
    products: [
        .library(
            name: "WGPU",
            targets: ["WGPU"]),
    ],
    dependencies: [
    ],
    targets: [
        .systemLibrary(
            name: "CWGPU"),
        .target(
            name: "WGPU",
            dependencies: ["CWGPU"]),
    ]
)
