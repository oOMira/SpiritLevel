// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "SpiritLevelShared",
    platforms: [
        .iOS(.v26),
        .watchOS(.v26)
    ],
    products: [
        .library(
            name: "SpiritLevelShared",
            targets: ["SpiritLevelShared"]
        ),
        .library(
            name: "SpiritLevelSharedTesting",
            targets: ["SpiritLevelSharedTesting"]
        ),
    ],
    targets: [
        .target(
            name: "SpiritLevelShared",
            path: "Sources",
            swiftSettings: [
                .swiftLanguageMode(.v6)
            ]
        ),
        .target(
            name: "SpiritLevelSharedTesting",
            path: "SpiritLevelSharedTesting",
            swiftSettings: [
                .swiftLanguageMode(.v6)
            ]
        ),
        .testTarget(
            name: "SpiritLevelSharedTests",
            dependencies: ["SpiritLevelShared"],
            swiftSettings: [
                .swiftLanguageMode(.v6)
            ]
        ),
    ]
)
