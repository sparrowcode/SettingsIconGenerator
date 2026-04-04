import CoreGraphics

/* Размер иконки в стиле Apple Settings.
 Определяет pointSize для фона (app.fill) и пропорции внутренней иконки.
 Итоговый intrinsic size изображения определяется натуральным размером SF Symbol. */
public enum SettingsIconSize: Sendable {

    /* Стандартный размер в стиле iOS Settings.
     pointSize 32 для app.fill, 16 для иконки — оригинальные пропорции Apple Settings. */
    case standard

    /* Произвольный pointSize для фона. Иконка = 50% от этого значения. */
    case custom(CGFloat)

    /* pointSize для фонового SF Symbol (app.fill). */
    public var points: CGFloat {
        switch self {
        case .standard: 32
        case .custom(let value): value
        }
    }

    /* pointSize для SF Symbol иконки — 50% от фона (ratio 1:2). */
    public var iconFontSize: CGFloat {
        points * 0.5
    }
}

/* SF Symbol для фона-сквиркла. */
let backgroundSymbolName = "app.fill"
