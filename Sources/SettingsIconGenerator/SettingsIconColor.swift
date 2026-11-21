import CoreGraphics

/* Цвет в sRGB, компоненты 0…1. Общий для SwiftUI и UIKit: каждый переводит в него свой цвет. */
struct SettingsIconColor: Equatable, Sendable {

    let red: CGFloat
    let green: CGFloat
    let blue: CGFloat

    init(red: CGFloat, green: CGFloat, blue: CGFloat) {
        self.red = red
        self.green = green
        self.blue = blue
    }

    /* Компоненты 0…255, как в замерах. */
    init(_ value: (Int, Int, Int)) {
        self.init(red: CGFloat(value.0) / 255, green: CGFloat(value.1) / 255, blue: CGFloat(value.2) / 255)
    }

    /* Компоненты цвета в sRGB; nil, если цвет не переводится. */
    init?(_ color: CGColor) {
        guard let sRGB = CGColorSpace(name: CGColorSpace.sRGB),
              let components = color.converted(to: sRGB, intent: .defaultIntent, options: nil)?.components,
              components.count >= 3 else { return nil }
        self.init(red: components[0], green: components[1], blue: components[2])
    }

    /* Системный цвет узнаётся по значению: в пределах 3 единиц на компоненту. */
    func isClose(to other: Self) -> Bool {
        let tolerance: CGFloat = 3.5 / 255
        return abs(red - other.red) < tolerance && abs(green - other.green) < tolerance && abs(blue - other.blue) < tolerance
    }
}
