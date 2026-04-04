// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "SettingsIconGenerator",
    platforms: [
        .iOS(.v15),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "SettingsIconGenerator",
            targets: ["SettingsIconGenerator"]
        )
    ],
    targets: [
        .target(
            name: "SettingsIconGenerator"
        )
    ]
)
