# SettingsIconGenerator

Generate icons matching Apple Settings style — colored squircle with a white SF Symbol.

## Installation

In Xcode: File → Add Package Dependencies → paste the URL:

```
https://github.com/sparrowcode/SettingsIconGenerator
```

## Usage

### SwiftUI

```swift
SettingsIcon(systemName: "bell.fill", backgroundColor: .blue)
```

Custom size:

```swift
SettingsIcon(systemName: "bell.fill", backgroundColor: .blue, size: .custom(48))
```

### UIKit

```swift
let image = UIImage.generateSettingsIcon("bell.fill", backgroundColor: .systemBlue)
```

With custom size:

```swift
let image = UIImage.generateSettingsIcon("bell.fill", backgroundColor: .systemBlue, size: .custom(48))
```
