// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Connect4Model",
    platforms: [.macOS(.v13), .iOS(.v16)],
    products: [
        .library(
            name: "Connect4Model",
            targets: ["Connect4Model"]),
    ],
    targets: [
        .target(
            name: "Connect4Model",
            dependencies: []),
        .testTarget(
            name: "Connect4ModelTests",
            dependencies: ["Connect4Model"]),
    ]
)
