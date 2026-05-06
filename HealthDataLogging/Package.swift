// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "HealthDataLogging",
    platforms: [
        .iOS(.v26),
        .watchOS(.v26)
    ],
    products: [
        .library(
            name: "HealthDataLogging",
            targets: ["HealthDataLogging"]
        ),
    ],
    dependencies: [
        .package(path: "../SpiritLevelShared")
    ],
    targets: [
        .target(
            name: "HealthDataLogging",
            dependencies: [
                .product(name: "SpiritLevelShared", package: "SpiritLevelShared")
            ],
            swiftSettings: [
                .swiftLanguageMode(.v6)
            ]
        ),
        .testTarget(
            name: "HealthDataLoggingTests",
            dependencies: [
                "HealthDataLogging",
                .product(name: "SpiritLevelSharedTesting", package: "SpiritLevelShared")
            ],
            path: "Tests",
            swiftSettings: [
                .swiftLanguageMode(.v6)
            ]
        ),
    ]
)
