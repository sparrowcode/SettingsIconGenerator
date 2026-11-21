import CoreGraphics

/* Градиент фона платформы: верх светлее, низ — цвет фона.
 Для системных цветов верх и низ берутся из замеров (palette), для остальных верх считается формулой (fallback). */
struct SettingsIconBackground: Sendable {

    /* Высоты в долях фона, на которых замерены верх и низ. За ними градиент продолжается теми же цветами. */
    let topLocation: CGFloat
    let bottomLocation: CGFloat

    /* Замеренные системные цвета; цвет узнаётся по низу. */
    let palette: [SettingsIconGradient]

    /* Верх градиента для цвета без замера. */
    let fallback: Lightening

    /* Color dodge на `dodge`, затем белый с прозрачностью `white`. */
    struct Lightening: Equatable, Sendable {

        let dodge: CGFloat
        let white: CGFloat

        func apply(to color: SettingsIconColor) -> SettingsIconColor {
            func lighten(_ component: CGFloat) -> CGFloat {
                let dodged = min(component / (1 - dodge), 1)
                return dodged + white * (1 - dodged)
            }
            return SettingsIconColor(red: lighten(color.red), green: lighten(color.green), blue: lighten(color.blue))
        }
    }

    /* Градиент для цвета фона. */
    func gradient(for color: SettingsIconColor) -> SettingsIconGradient {
        palette.first { $0.bottom.isClose(to: color) }
            ?? SettingsIconGradient(top: fallback.apply(to: color), bottom: color)
    }
}

/* Пара цветов градиента: низ — цвет фона, верх светлее. */
struct SettingsIconGradient: Equatable, Sendable {

    let top: SettingsIconColor
    let bottom: SettingsIconColor

    init(top: SettingsIconColor, bottom: SettingsIconColor) {
        self.top = top
        self.bottom = bottom
    }

    /* Замер, компоненты 0…255. */
    init(top: (Int, Int, Int), bottom: (Int, Int, Int)) {
        self.init(top: SettingsIconColor(top), bottom: SettingsIconColor(bottom))
    }
}
