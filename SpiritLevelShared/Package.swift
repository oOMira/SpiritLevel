// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "SpiritLevelShared",
    platforms: [
        .iOS(.v17),
        .watchOS(.v10)
    ],
    products: [
        .library(
            name: "SpiritLevelShared",
            targets: ["SpiritLevelShared"]
        ),
    ],
    targets: [
        .target(
            name: "SpiritLevelShared",
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
