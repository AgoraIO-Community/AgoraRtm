// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AgoraRtm",
    platforms: [.iOS(.v11), .macOS(.v10_15)],
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
//        .package(url: "https://github.com/realm/SwiftLint.git", from: .init(0, 52, 4))
    ],
    targets: [
        .target(
            name: "AgoraRtm",
            dependencies: ["AgoraRtmKit-OC"]
//            plugins: [.plugin(name: "SwiftLintPlugin", package: "SwiftLint")]
        ),
//        .binaryTarget(name: "AgoraRtmKit-OC", path: "AgoraRtmKit.xcframework.zip"),
        .binaryTarget(
            name: "AgoraRtmKit-OC",
            url: "https://github.com/AgoraIO-Community/AgoraRtm/releases/download/2.1.6-beta.1/AgoraRtmKit.xcframework.zip",
            checksum: "90835d11a7adda9cbb5020ee09c8ce73b0eb679729f16f392c9e4d56a3f3e0df"
        ),
        .testTarget(
            name: "AgoraRtmTests",
            dependencies: ["AgoraRtm"]
//            plugins: [.plugin(name: "SwiftLintPlugin", package: "SwiftLint")]
        )
    ]
)
