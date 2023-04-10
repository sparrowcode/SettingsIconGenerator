// swift-tools-version: 5.4

import PackageDescription

let package = Package(
    name: "SettingsIconGenerator",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v13),
        .tvOS(.v13),
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "SettingsIconGenerator",
            targets: ["SettingsIconGenerator"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SettingsIconGenerator"
        )
    ]
)
