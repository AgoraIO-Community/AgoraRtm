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
            name: "AgoraRtmKit-ObjC",
            targets: ["AgoraRtmKit"]
        )
    ],
    dependencies: [
//        .package(url: "https://github.com/realm/SwiftLint.git", from: .init(0, 52, 4))
    ],
    targets: [
        .target(
            name: "AgoraRtm",
            dependencies: ["AgoraRtmKit"]
//            plugins: [.plugin(name: "SwiftLintPlugin", package: "SwiftLint")]
        ),
//        .binaryTarget(name: "AgoraRtmKit-OC", path: "AgoraRtmKit.xcframework.zip"),
        .binaryTarget(
            name: "AgoraRtmKit",
            url: "https://github.com/AgoraIO-Community/AgoraRtm/releases/download/2.1.5-build.277405/AgoraRtmKit.xcframework.zip",
            checksum: "6f0bcf244982562701a291d5519f9927a7fc5909020c5df9ce4905e38641333c"
        ),
        .testTarget(
            name: "AgoraRtmTests",
            dependencies: ["AgoraRtm"]
//            plugins: [.plugin(name: "SwiftLintPlugin", package: "SwiftLint")]
        )
    ]
)
