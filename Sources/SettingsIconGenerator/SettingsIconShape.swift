import CoreGraphics

/* Форма фона иконки в стиле Apple Settings.
 squircle — скруглённый квадрат (iOS), circle — круг (watchOS, visionOS). */
public enum SettingsIconShape: Sendable {

    /* Скруглённый квадрат — стиль iOS Settings. */
    case squircle

    /* Круг — стиль watchOS и visionOS Settings. */
    case circle

    /* Форма по умолчанию — как в системных Настройках платформы. */
    @usableFromInline
    static var platformDefault: SettingsIconShape {
        SettingsIconMetrics.current.shape
    }

    /* Доля pointSize, которую занимает видимая форма символа фона: app.fill — 0.9, circle.fill — весь pointSize. */
    var plateRatio: CGFloat {
        switch self {
        case .squircle: 0.9
        case .circle: 1
        }
    }

    /* SF Symbol, задающий форму фона. */
    var backgroundSymbolName: String {
        switch self {
        case .squircle: "app.fill"
        case .circle: "circle.fill"
        }
    }
}
