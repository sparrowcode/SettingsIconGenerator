# SPSettingsIcons

Generate settings icons by Apple's SF Symbols.

<p float="left">
    <img src="https://cdn.ivanvorobei.by/github/sppermissions/permissions/notifications.png" width="38">
    <img src="https://cdn.ivanvorobei.by/github/sppermissions/permissions/location.png" width="38">
    <img src="https://cdn.ivanvorobei.by/github/sppermissions/permissions/microphone.png" width="38">
    <img src="https://cdn.ivanvorobei.by/github/sppermissions/permissions/motion.png" width="38">
    <img src="https://cdn.ivanvorobei.by/github/sppermissions/permissions/music.png" width="38">
    <img src="https://cdn.ivanvorobei.by/github/sppermissions/permissions/speech.png" width="38">
    <img src="https://cdn.ivanvorobei.by/github/sppermissions/permissions/bluetooth.png" width="38">
    <img src="https://cdn.ivanvorobei.by/github/sppermissions/permissions/tracking.png" width="38">
    <img src="https://cdn.ivanvorobei.by/github/sppermissions/permissions/faceid.png" width="38">
</p>

For safe using SFSymbols see [SPSafeSymbols](https://github.com/sparrowcode/SPSafeSymbols) library.

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

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. It’s integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies.

Once you have your Swift package set up, adding as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/sparrowcode/SPSettingsIcons", .upToNextMajor(from: "1.0.0"))
]
```

### CocoaPods:

[CocoaPods](https://cocoapods.org) is a dependency manager. For usage and installation instructions, visit their website. To integrate using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'SPSettingsIcons'
```

### Manually

If you prefer not to use any of dependency managers, you can integrate manually. Put `Sources/SPSettingsIcons` folder in your Xcode project. Make sure to enable `Copy items if needed` and `Create groups`.

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

### AppKit

```swift

```
