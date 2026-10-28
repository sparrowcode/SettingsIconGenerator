/* Форма фона иконки в стиле Apple Settings.
 squircle — скруглённый квадрат (iOS), circle — круг (visionOS). */
public enum SettingsIconShape: Sendable {

    /* Скруглённый квадрат — стиль iOS Settings. */
    case squircle

    /* Круг — стиль visionOS Settings. */
    case circle

    /* Форма по умолчанию — как в системных Настройках платформы: круг на watchOS и visionOS. */
    @usableFromInline
    static var platformDefault: SettingsIconShape {
        #if os(watchOS) || os(visionOS)
        .circle
        #else
        .squircle
        #endif
    }

    /* SF Symbol, задающий форму фона. */
    var backgroundSymbolName: String {
        switch self {
        case .squircle: "app.fill"
        case .circle: "circle.fill"
        }
    }
}
