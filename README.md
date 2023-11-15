# SettingsIconGenerator

Generate settings icons by Apple's SF Symbols.

<p float="left">
    <img src="https://cdn.ivanvorobei.io/github/sppermissions/permissions/notifications.png" width="38">
    <img src="https://cdn.ivanvorobei.io/github/sppermissions/permissions/location.png" width="38">
    <img src="https://cdn.ivanvorobei.io/github/sppermissions/permissions/microphone.png" width="38">
    <img src="https://cdn.ivanvorobei.io/github/sppermissions/permissions/motion.png" width="38">
    <img src="https://cdn.ivanvorobei.io/github/sppermissions/permissions/music.png" width="38">
    <img src="https://cdn.ivanvorobei.io/github/sppermissions/permissions/speech.png" width="38">
    <img src="https://cdn.ivanvorobei.io/github/sppermissions/permissions/bluetooth.png" width="38">
    <img src="https://cdn.ivanvorobei.io/github/sppermissions/permissions/tracking.png" width="38">
    <img src="https://cdn.ivanvorobei.io/github/sppermissions/permissions/faceid.png" width="38">
</p>

### Community

<p float="left">
    <a href="https://twitter.com/sparrowcode_en">
        <img src="https://cdn.sparrowcode.io/github%2Fbadges%2Ftwitter.png?version=4" height="52">
    </a>
    <a href="https://t.me/sparrowcode_en">
        <img src="https://cdn.sparrowcode.io/github/badges/telegram.png?version=1" height="52">
    </a>
    <a href="https://mastodon.social/@sparrowcode_en">
        <img src="https://cdn.sparrowcode.io/github/badges/mastodon.png?version=2" height="52">
    </a>
    <a href="#apps-using">
        <img src="https://cdn.sparrowcode.io/github/badges/download-on-the-appstore.png?version=4" height="52">
    </a>
</p>

## Navigate

- [Installation](#installation)
    - [Swift Package Manager](#swift-package-manager)
    - [CocoaPods](#cocoapods)
    - [Manually](#manually)
- [Usage](#usage)
    - [UIKit](#uikit)
    - [SwiftUI](#swiftui)
    - [AppKit](#appkit)

## Installation

Ready for use on iOS 13+.

### Swift Package Manager

In Xcode go to Project -> Your Project Name -> `Package Dependencies` -> Tap *Plus*. Insert url:

```
https://github.com/sparrowcode/SettingsIconGenerator
```

or adding it to the `dependencies` of your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/sparrowcode/SettingsIconGenerator", .upToNextMajor(from: "1.0.0"))
]
```
### CocoaPods:

This is an outdated way of doing things. I advise you to use [SPM](#swift-package-manager). However, I will continue to support Cocoapods for some time.

<details><summary>Cocoapods Instalation</summary>

[CocoaPods](https://cocoapods.org) is a dependency manager. For usage and installation instructions, visit their website. To integrate using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'SettingsIconGenerator'
```
</details>

### Manually

If you prefer not to use any of dependency managers, you can integrate manually. Put `Sources/SettingsIconGenerator` folder in your Xcode project. Make sure to enable `Copy items if needed` and `Create groups`.

## Usage

### UIKit

```swift
let image = UIImage.generateSettingsIcon("bell.fill", backgroundColor: .systemBlue)
```

### SwiftUI

```swift
SettingsIcon("bell.fill", backgroundColor: .systemBlue)
```

or if need generate image:

```swift
Image.generateSettingsIcon("bell.fill", backgroundColor: .systemBlue)
```

## Apps Using

<p float="left">
    <a href="https://apps.apple.com/app/id1624477055"><img src="https://cdn.sparrowcode.io/github/apps-using/id1624477055.png?v=2" height="65"></a>
    <a href="https://apps.apple.com/app/id1625641322"><img src="https://cdn.sparrowcode.io/github/apps-using/id1625641322.png?v=2" height="65"></a>
    <a href="https://apps.apple.com/app/id875280793"><img src="https://cdn.sparrowcode.io/github/apps-using/id875280793.png?v=2" height="65"></a>
    <a href="https://apps.apple.com/app/id743843090"><img src="https://cdn.sparrowcode.io/github/apps-using/id743843090.png?v=2" height="65"></a>
    <a href="https://apps.apple.com/app/id537070378"><img src="https://cdn.sparrowcode.io/github/apps-using/id537070378.png?v=2" height="65"></a>
    <a href="https://apps.apple.com/app/id1570676244"><img src="https://cdn.sparrowcode.io/github/apps-using/id1570676244.png?v=2" height="65"></a>
    <a href="https://apps.apple.com/app/id1617055933"><img src="https://cdn.sparrowcode.io/github/apps-using/id1617055933.png?v=2" height="65"></a>
    <a href="https://apps.apple.com/app/id6451087813"><img src="https://cdn.sparrowcode.io/github/apps-using/id6451087813.png?v=1" height="65"></a>
</p>

If you use a `SettingsIconGenerator`, add your application via Pull Request.
