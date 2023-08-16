// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AgoraRtm",
    products: [
        .library(
            name: "AgoraRtmKit-Swift",
            targets: ["AgoraRtm"]),
        .library(
            name: "AgoraRtmKit-OC",
            targets: ["AgoraRtmKit-OC"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/realm/SwiftLint.git", from: .init(0, 52, 4))
    ],
    targets: [
        .target(
            name: "AgoraRtm",
            dependencies: ["AgoraRtmKit-OC"],
            plugins: [.plugin(name: "SwiftLintPlugin", package: "SwiftLint")]
        ),
        .binaryTarget(
            name: "AgoraRtmKit-OC",
            url: "https://github.com/AgoraIO/AgoraRtm_iOS/releases/download/2.1.4-nightly.23.08.10/AgoraRtmKit.xcframework.zip",
            checksum: "5b227fba49bf7e8f5183f222d5ac5b15851c44576f4dfed1074d6b54c9bf83c4"
        ),
        .testTarget(
            name: "AgoraRtmTests",
            dependencies: ["AgoraRtm"]
        )
    ]
)
