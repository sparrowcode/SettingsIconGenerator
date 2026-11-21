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

    /* SF Symbol, задающий форму фона. */
    var backgroundSymbolName: String {
        switch self {
        case .squircle: "app.fill"
        case .circle: "circle.fill"
        }
    }
}
