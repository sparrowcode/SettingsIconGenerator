import CoreGraphics

extension SettingsIconMetrics {

    /* Замеры Settings на Apple Watch Ultra 4, watchOS 27. */
    static let watchOS = SettingsIconMetrics(
        shape: .circle,
        /* circle.fill даёт 0.94 от pointSize: 25.5 — круг 24 pt (Ultra и обычные). */
        standardPoints: 25.5,
        /* Символ около 12.8 pt (колокольчик 12 pt в высоту) на круге 24 pt. */
        glyphRatio: 0.5,
        /* Красный 255,56,60, а не тёмный 255,66,69. */
        usesLightColor: true,
        /* Тень почти незаметна: под символом фон темнее на ~3% и только на 1–2 px. */
        shadow: Shadow(opacity: 0.045, offset: 0.5, radius: 0.35),
        background: SettingsIconBackground(
            /* Цвета сняты на строках 3 и 43 круга высотой 48 px. */
            topLocation: 0.065,
            bottomLocation: 0.9,
            palette: [
                .init(top: (255, 63, 66), bottom: (255, 56, 60)),   // красный
                .init(top: (249, 151, 53), bottom: (255, 141, 40)), // оранжевый: красная компонента вверху чуть ниже
                .init(top: (66, 212, 101), bottom: (52, 199, 89)),  // зелёный
                .init(top: (0, 147, 255), bottom: (0, 136, 255)),   // синий
                .init(top: (109, 96, 255), bottom: (97, 85, 245)),  // индиго
                .init(top: (255, 51, 95), bottom: (255, 45, 85))    // розовый
            ],
            fallback: .init(dodge: 0.08, white: 0.0225)
        )
    )
}
