import CoreGraphics

extension SettingsIconMetrics {

    /* Замеры Settings на Apple Vision Pro, visionOS 27.2.
     Скриншот симулятора visionOS отдаёт координаты Display P3 с пометкой sRGB: зелёный 52,199,89 на нём 101,197,102.
     С поправкой на это фон в Settings — тот же градиент, что на iOS, расхождение не больше 2 единиц. */
    static let visionOS = SettingsIconMetrics(
        shape: .circle,
        /* circle.fill даёт ~1.0 от pointSize: круг 32 pt. */
        standardPoints: 32,
        /* Символ около 19.2 pt на круге 32 pt. */
        glyphRatio: 0.6,
        /* Settings берёт светлые системные цвета. Цвет окна visionOS (тёмная тема) светлее: зелёный вышел бы 117,223,119 на скриншоте вместо 101,197,102. */
        usesLightColor: true,
        /* Тень под глифом не замерялась. */
        shadow: .none,
        /* Градиент iOS: палитра, формула и высоты замера. Верх светлее низа на ~10 единиц. */
        background: SettingsIconMetrics.iOS.background
    )
}
