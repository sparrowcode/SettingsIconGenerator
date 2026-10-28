import CoreGraphics

/* Размер иконки в стиле Apple Settings.
 Определяет pointSize для фона (app.fill / circle.fill) и пропорции внутренней иконки.
 Итоговый intrinsic size изображения определяется натуральным размером SF Symbol. */
public enum SettingsIconSize: Sendable {

    /* Стандартный размер под системные Настройки текущей платформы.
     iOS: pointSize 31 — сквиркл 28 pt, как в Settings на iOS 27.
     watchOS: pointSize 25.5 — круг 24 pt. */
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

    #if os(watchOS)
    /* На часах круг 24 pt (Ultra и обычные): circle.fill на watchOS даёт 0.94 от pointSize. */
    static let standardPoints: CGFloat = 25.5

    /* Символ в Settings на watchOS 27 — около 12.8 pt (колокольчик 12 pt в высоту) на круге 24 pt. */
    static let iconRatio: CGFloat = 0.5
    #else
    /* Замерено по скриншотам Settings: app.fill даёт фон 0.9 от pointSize. */
    static let standardPoints: CGFloat = 31

    /* Символ в Settings на iOS 27 — около 17.4 pt на сквиркле 28 pt. */
    static let iconRatio: CGFloat = 0.56
    #endif
}

/* SF Symbol для фона-сквиркла. */
let backgroundSymbolName = "app.fill"
