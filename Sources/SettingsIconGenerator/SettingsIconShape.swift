/* Форма фона иконки в стиле Apple Settings.
 squircle — скруглённый квадрат (iOS), circle — круг (visionOS). */
public enum SettingsIconShape: Sendable {

    /* Скруглённый квадрат — стиль iOS Settings. */
    case squircle

    /* Круг — стиль visionOS Settings. */
    case circle

    /* SF Symbol, задающий форму фона. */
    var backgroundSymbolName: String {
        switch self {
        case .squircle: "app.fill"
        case .circle: "circle.fill"
        }
    }
}
