import CoreGraphics

/* Градиент фона: верх светлее, низ — исходный цвет.
 Для системных цветов верх и низ прописаны по замерам Settings, для остальных верх считается формулой.
 Одной формулы для всех цветов нет: у серого верх светлее на 17 единиц, у красного по зелёной компоненте на 7. */
struct SettingsIconGradient: Equatable {

    let top: Components
    let bottom: Components

    /* Компоненты sRGB 0…1. */
    struct Components: Equatable {
        let red: CGFloat
        let green: CGFloat
        let blue: CGFloat
    }

    #if os(watchOS)
    /* На часах цвета замерены на строках 3 и 43 круга высотой 48 px. */
    static let topLocation: CGFloat = 0.065
    static let bottomLocation: CGFloat = 0.9
    #else
    /* На iPhone — на строках 6 и 71 сквиркла высотой 78 px. */
    static let topLocation: CGFloat = 0.077
    static let bottomLocation: CGFloat = 0.91
    #endif

    /* Градиент для цвета или nil, если на платформе фон плоский. */
    static func make(red: CGFloat, green: CGFloat, blue: CGFloat) -> SettingsIconGradient? {
        #if os(iOS) || os(watchOS)
        let color = Components(red: red, green: green, blue: blue)
        if let measured = palette.first(where: { $0.bottom.isClose(to: color) }) {
            return measured
        }
        return SettingsIconGradient(top: color.lightened, bottom: color)
        #else
        return nil
        #endif
    }

    #if os(watchOS)
    /* Замеры Settings на Apple Watch Ultra 4, watchOS 27. */
    private static let palette: [SettingsIconGradient] = [
        .init(top: (255, 63, 66), bottom: (255, 56, 60)),   // красный
        .init(top: (249, 151, 53), bottom: (255, 141, 40)), // оранжевый: красная компонента вверху чуть ниже
        .init(top: (66, 212, 101), bottom: (52, 199, 89)),  // зелёный
        .init(top: (0, 147, 255), bottom: (0, 136, 255)),   // синий
        .init(top: (109, 96, 255), bottom: (97, 85, 245)),  // индиго
        .init(top: (255, 51, 95), bottom: (255, 45, 85))    // розовый
    ]
    #else
    /* Замеры Settings на iPhone, iOS 27.1. */
    private static let palette: [SettingsIconGradient] = [
        .init(top: (255, 63, 66), bottom: (255, 56, 60)),    // красный
        .init(top: (255, 155, 54), bottom: (255, 141, 40)),  // оранжевый
        .init(top: (66, 212, 100), bottom: (52, 199, 89)),   // зелёный
        .init(top: (0, 147, 255), bottom: (0, 136, 255)),    // синий
        .init(top: (109, 96, 255), bottom: (97, 85, 245)),   // индиго
        .init(top: (159, 159, 164), bottom: (142, 142, 147)), // серый
        .init(top: (10, 10, 10), bottom: (0, 0, 0))          // чёрный
    ]
    #endif

    /* Подъём для цветов без замера: color dodge 0.08, затем белый с прозрачностью 0.0225.
     По замеренным цветам расходится с системой не больше чем на 6 единиц. */
    static let fallbackDodge: CGFloat = 0.08
    static let fallbackWhite: CGFloat = 0.0225
}

private extension SettingsIconGradient {

    init(top: (Int, Int, Int), bottom: (Int, Int, Int)) {
        self.init(top: Components(top), bottom: Components(bottom))
    }
}

private extension SettingsIconGradient.Components {

    init(_ value: (Int, Int, Int)) {
        self.init(red: CGFloat(value.0) / 255, green: CGFloat(value.1) / 255, blue: CGFloat(value.2) / 255)
    }

    /* Системный цвет узнаётся по значению: в пределах 3 единиц на компоненту. */
    func isClose(to other: Self) -> Bool {
        let tolerance: CGFloat = 3.5 / 255
        return abs(red - other.red) < tolerance && abs(green - other.green) < tolerance && abs(blue - other.blue) < tolerance
    }

    var lightened: Self {
        func lighten(_ component: CGFloat) -> CGFloat {
            let dodged = min(component / (1 - SettingsIconGradient.fallbackDodge), 1)
            return dodged + SettingsIconGradient.fallbackWhite * (1 - dodged)
        }
        return Self(red: lighten(red), green: lighten(green), blue: lighten(blue))
    }
}
