// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AgoraRtm",
    products: [
        .library(
            name: "AgoraRtm",
            targets: ["AgoraRtm"]),
    ],
    dependencies: [
        .package(url: "https://github.com/AgoraIO/AgoraRTM_iOS.git", branch: "test-2.x")
    ],
    targets: [
        .target(
            name: "AgoraRtm",
            dependencies: [
                .product(name: "AgoraRtmKit", package: "AgoraRTM_iOS")
            ]
        ),
        .testTarget(
            name: "AgoraRtmTests",
            dependencies: ["AgoraRtm"]),
    ]
)
