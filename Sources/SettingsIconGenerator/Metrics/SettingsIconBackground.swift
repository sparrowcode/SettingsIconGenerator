import CoreGraphics

/* Градиент фона: верх светлее, низ — цвет фона.
 Для системных цветов верх и низ берутся из замеров (palette), для остальных считаются формулой (fallback). */
struct SettingsIconBackground: Sendable {

    /* Высоты в долях фона, на которых замерены верх и низ. За ними градиент продолжается теми же цветами. */
    let topLocation: CGFloat
    let bottomLocation: CGFloat

    /* Замеренные системные цвета. */
    let palette: [SettingsIconGradient]

    /* Как получить верх градиента для цвета без замера. */
    let fallback: Fallback

    enum Fallback: Sendable {

        /* Color dodge на `dodge`, затем белый с прозрачностью `white`. */
        case dodge(CGFloat, white: CGFloat)
    }

    /* Градиент для цвета фона в sRGB. */
    func gradient(for color: SettingsIconColor) -> SettingsIconGradient {
        if let measured = palette.first(where: { $0.source.isClose(to: color) }) {
            return measured
        }
        switch fallback {
        case let .dodge(dodge, white):
            return SettingsIconGradient(source: color, top: color.dodged(dodge, white: white), bottom: color)
        }
    }
}

/* Пара цветов градиента. source — цвет, который передал пользователь (например, systemBlue):
 по нему градиент находится в палитре. На iOS и watchOS source совпадает с низом. */
struct SettingsIconGradient: Equatable, Sendable {

    let source: SettingsIconColor
    let top: SettingsIconColor
    let bottom: SettingsIconColor

    init(source: SettingsIconColor, top: SettingsIconColor, bottom: SettingsIconColor) {
        self.source = source
        self.top = top
        self.bottom = bottom
    }

    /* Замер, где низ совпадает с исходным цветом. Компоненты 0…255. */
    init(top: (Int, Int, Int), bottom: (Int, Int, Int)) {
        let bottom = SettingsIconColor(bottom)
        self.init(source: bottom, top: SettingsIconColor(top), bottom: bottom)
    }
}

/* Цвет в sRGB, компоненты 0…1. */
struct SettingsIconColor: Equatable, Sendable {

    let red: CGFloat
    let green: CGFloat
    let blue: CGFloat

    init(red: CGFloat, green: CGFloat, blue: CGFloat) {
        self.red = red
        self.green = green
        self.blue = blue
    }

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

    func dodged(_ dodge: CGFloat, white: CGFloat) -> Self {
        func lighten(_ component: CGFloat) -> CGFloat {
            let dodged = min(component / (1 - dodge), 1)
            return dodged + white * (1 - dodged)
        }
        return Self(red: lighten(red), green: lighten(green), blue: lighten(blue))
    }
}
