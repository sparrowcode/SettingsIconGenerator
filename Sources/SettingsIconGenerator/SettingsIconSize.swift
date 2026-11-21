import CoreGraphics

/* Размер иконки в стиле Apple Settings.
 Определяет pointSize для фона (app.fill / circle.fill) и пропорции глифа.
 Итоговый intrinsic size изображения определяется натуральным размером SF Symbol. */
public enum SettingsIconSize: Sendable {

    /* Стандартный размер под системные Настройки текущей платформы, замеры в SettingsIconMetrics.
     iOS: сквиркл 28 pt. watchOS: круг 24 pt. visionOS: круг 32 pt. */
    case standard

    /* Произвольный pointSize для фона. Глиф — доля от этого значения. */
    case custom(CGFloat)

    /* pointSize для фонового SF Symbol. */
    public var points: CGFloat {
        points(.current)
    }

    /* pointSize для SF Symbol глифа, без поправки конкретного глифа. */
    public var iconFontSize: CGFloat {
        points * SettingsIconMetrics.current.glyphRatio
    }

    func points(_ metrics: SettingsIconMetrics) -> CGFloat {
        switch self {
        case .standard: metrics.standardPoints
        case .custom(let value): value
        }
    }
}
