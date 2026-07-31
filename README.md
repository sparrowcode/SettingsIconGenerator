# SettingsIconGenerator

Generate icons matching Apple Settings style — a colored background with a white SF Symbol. Pick a squircle (iOS) or circle (visionOS) shape.

## Installation

In Xcode: File → Add Package Dependencies → paste URL:

```
https://github.com/sparrowcode/SettingsIconGenerator
```

## Usage

### SwiftUI

```swift
SettingsIcon(systemName: "bell.fill", backgroundColor: .blue)
SettingsIcon(systemName: "bell.fill", backgroundColor: .blue, shape: .circle)
```

### UIKit

```swift
let image = UIImage.generateSettingsIcon("bell.fill", backgroundColor: .systemBlue)
let circle = UIImage.generateSettingsIcon("bell.fill", backgroundColor: .systemBlue, shape: .circle)
```
