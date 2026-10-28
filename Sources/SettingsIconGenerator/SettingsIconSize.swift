import CoreGraphics

/* Размер иконки в стиле Apple Settings.
 Определяет pointSize для фона (app.fill / circle.fill) и пропорции внутренней иконки.
 Итоговый intrinsic size изображения определяется натуральным размером SF Symbol. */
public enum SettingsIconSize: Sendable {

    /* Стандартный размер под системные Настройки текущей платформы.
     iOS: pointSize 31 — сквиркл 28 pt, как в Settings на iOS 27. */
    case standard

    /* Произвольный pointSize для фона. Иконка — iconRatio от этого значения. */
    case custom(CGFloat)

    /* pointSize для фонового SF Symbol. */
    public var points: CGFloat {
        switch self {
        case .standard: Self.standardPoints
        case .custom(let value): value
        }
    }

    /* pointSize для SF Symbol иконки. */
    public var iconFontSize: CGFloat {
        points * Self.iconRatio
    }

    /* Замерено по скриншотам Settings: app.fill даёт фон 0.9 от pointSize. */
    static let standardPoints: CGFloat = 31

    /* Символ в Settings на iOS 27 — около 17.4 pt на сквиркле 28 pt. */
    static let iconRatio: CGFloat = 0.56
}

/* SF Symbol для фона-сквиркла. */
let backgroundSymbolName = "app.fill"
