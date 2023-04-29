// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DrawingNetwork",
    products: [
        .library(
            name: "DrawingNetwork",
            targets: ["DrawingNetwork"]),
    ],
    dependencies: [
        .package(name: "DrawingModel", path: "../DrawingModel")
    ],
    targets: [
        .target(
            name: "DrawingNetwork",
            dependencies: [
                "DrawingModel"
            ]),
        .testTarget(
            name: "DrawingNetworkTests",
            dependencies: ["DrawingNetwork"]),
    ]
)
