// swift-tools-version: 5.4

import PackageDescription

let package = Package(
    name: "SPSettingsIcons",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v13),
        .tvOS(.v13),
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "SPSettingsIcons",
            targets: ["SPSettingsIcons"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SPSettingsIcons"
        )
    ]
)
