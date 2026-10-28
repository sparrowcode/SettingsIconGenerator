# SettingsIconGenerator

Generate icons matching Apple Settings style — a colored background with a white SF Symbol. Supports iOS, macOS, watchOS and visionOS.

## Installation

In Xcode: File → Add Package Dependencies → paste URL:

```
https://github.com/sparrowcode/SettingsIconGenerator
```

## Usage

### SwiftUI

```swift
// Squircle on iOS and macOS, circle on watchOS and visionOS
SettingsIcon(systemName: "bell.fill", backgroundColor: .blue)
// Force a shape
SettingsIcon(systemName: "bell.fill", backgroundColor: .blue, shape: .circle)
```

### UIKit

```swift
let image = UIImage.generateSettingsIcon("bell.fill", backgroundColor: .systemBlue)
let circle = UIImage.generateSettingsIcon("bell.fill", backgroundColor: .systemBlue, shape: .circle)
```
