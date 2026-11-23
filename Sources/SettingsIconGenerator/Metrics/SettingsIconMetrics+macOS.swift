import CoreGraphics

extension SettingsIconMetrics {

    /* Замеры System Settings на Mac Studio, macOS 27.2.1, 2026-11: сайдбар, строки форм, карточки разделов.
     Эталон и иконки пакета сняты одним путём — окном с того же экрана, поэтому цветовой профиль дисплея не влияет на сравнение. */
    static let macOS = SettingsIconMetrics(
        shape: .squircle,
        /* Сквиркл 20 pt в строках и сайдбаре: app.fill даёт 0.9 от pointSize. Ровно 20 pt — край плашки на пикселе. */
        standardPoints: 20 / 0.9,
        /* Глифы на Mac крупнее iOS: wifi 26 × 19 px, молния 16 × 26, круглые символы 26 px на плашке 40 px. */
        glyphRatio: 0.58,
        /* Settings берёт светлый системный цвет. */
        usesLightColor: true,
        /* Под глифом та же тень, что на iOS: синий 248 → 240 сразу под символом. */
        shadow: SettingsIconMetrics.iOS.shadow,
        /* Градиент iOS. Иконки Apple на Mac между собой расходятся на 3–4 единицы (синий Spotlight 0,147 → 0,136, синий «Универсального доступа» 0,144 → 0,132), палитра iOS внутри этого разброса. */
        background: SettingsIconMetrics.iOS.background,
        /* Под плашкой тень: на фоне строки 247 сбоку 212, сверху 228, снизу 213 → 229 → 238. */
        plateShadow: Shadow(opacity: 0.35, offset: 0.5, radius: 1),
        /* Кромка по верхнему краю светлее фона на ~26 единиц, по нижнему на ~16, толщина в пиксель на Retina. */
        rim: Rim(width: 0.5, topOpacity: 0.1, bottomOpacity: 0.063),
        /* Рамка 20 pt по плашке: строка Настроек отсчитывает 10 pt до текста от плашки. */
        framesPlate: true,
        /* Шестерёнка «Основных» 28 px на 40 — без iOS-поправки 1.12. */
        glyphScales: ["gear": 1]
    )
}
