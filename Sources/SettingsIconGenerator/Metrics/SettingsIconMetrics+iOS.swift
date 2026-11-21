import CoreGraphics

extension SettingsIconMetrics {

    /* Замеры Settings на iPhone, iOS 27.1. */
    static let iOS = SettingsIconMetrics(
        shape: .squircle,
        /* app.fill даёт фон 0.9 от pointSize: 31 — сквиркл 28 pt, как в Settings. */
        standardPoints: 31,
        /* Символ в Settings около 17.4 pt на сквиркле 28 pt. */
        glyphRatio: 0.56,
        usesLightColor: true,
        /* Снизу затемняет фон на ~6% и тянется ~2 pt, по бокам слабее, сверху нет. */
        shadow: Shadow(opacity: 0.09, offset: 0.8, radius: 0.75),
        background: SettingsIconBackground(
            /* Цвета сняты на строках 6 и 71 сквиркла высотой 78 px. */
            topLocation: 0.077,
            bottomLocation: 0.91,
            palette: [
                .init(top: (255, 63, 66), bottom: (255, 56, 60)),    // красный
                .init(top: (255, 155, 54), bottom: (255, 141, 40)),  // оранжевый
                .init(top: (66, 212, 100), bottom: (52, 199, 89)),   // зелёный
                .init(top: (0, 147, 255), bottom: (0, 136, 255)),    // синий
                .init(top: (109, 96, 255), bottom: (97, 85, 245)),   // индиго
                .init(top: (159, 159, 164), bottom: (142, 142, 147)), // серый
                .init(top: (10, 10, 10), bottom: (0, 0, 0))          // чёрный
            ],
            /* Одной формулы для всех цветов нет: у серого верх светлее на 17 единиц, у красного по зелёной компоненте на 7.
             Эта по замеренным цветам расходится с системой не больше чем на 6 единиц. */
            fallback: .dodge(0.08, white: 0.0225)
        )
    )
}
