# SettingsIconGenerator

Generate icons matching Apple Settings style — colored squircle with a white SF Symbol.

## Installation

In Xcode: File → Add Package Dependencies → paste URL:

```
https://github.com/sparrowcode/SettingsIconGenerator
```

## Usage

### SwiftUI

```swift
SettingsIcon(systemName: "bell.fill", backgroundColor: .blue)
```

### UIKit

```swift
let image = UIImage.generateSettingsIcon("bell.fill", backgroundColor: .systemBlue)
```
