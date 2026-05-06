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
            swiftSettings: [
                .swiftLanguageMode(.v6)
            ]
        ),
        .target(
            name: "SpiritLevelSharedTesting",
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
