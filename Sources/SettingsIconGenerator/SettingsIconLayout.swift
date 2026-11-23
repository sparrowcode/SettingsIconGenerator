import CoreGraphics

/* Всё, что нужно нарисовать одну иконку: размеры, сдвиг и тень глифа, заливка фона.
 Считается из метрик платформы и поправок глифа один раз. SwiftUI и UIKit рисуют только по layout и к метрикам не обращаются. */
struct SettingsIconLayout {

    /* pointSize фонового символа. */
    let backgroundPoints: CGFloat

    /* Сторона рамки SwiftUI-иконки: pointSize фона или, где метрики просят, видимая плашка. */
    let frameSide: CGFloat

    /* pointSize глифа с поправкой глифа. */
    let glyphPoints: CGFloat

    /* Сдвиг глифа вниз от центра в pt. */
    let glyphOffset: CGFloat

    let shadow: SettingsIconMetrics.Shadow

    /* Тень под плашкой и кромка, см. SettingsIconMetrics. */
    let plateShadow: SettingsIconMetrics.Shadow
    let rim: SettingsIconMetrics.Rim?

    /* Цвет фона берётся в светлом варианте, какой бы ни была тема. */
    let usesLightColor: Bool

    private let background: SettingsIconBackground?

    init(systemName: String, size: SettingsIconSize, shape: SettingsIconShape = .platformDefault, metrics: SettingsIconMetrics = .current) {
        backgroundPoints = size.points(metrics)
        frameSide = metrics.framesPlate ? backgroundPoints * shape.plateRatio : backgroundPoints
        glyphPoints = backgroundPoints * metrics.glyphRatio * metrics.glyphScale(for: systemName)
        glyphOffset = glyphPoints * SettingsIconGlyph.verticalOffset(for: systemName)
        shadow = metrics.shadow
        /* Тень плашки и кромка замерены на стандартном размере и растут вместе с иконкой: у карточек 26 pt кромка ярче
         (+35 против +26), тень шире. */
        let scale = backgroundPoints / metrics.standardPoints
        plateShadow = SettingsIconMetrics.Shadow(
            opacity: metrics.plateShadow.opacity,
            offset: metrics.plateShadow.offset * scale,
            radius: metrics.plateShadow.radius * scale
        )
        rim = metrics.rim.map { .init(width: $0.width, topOpacity: $0.topOpacity * scale, bottomOpacity: $0.bottomOpacity * scale) }
        usesLightColor = metrics.usesLightColor
        background = metrics.background
    }

    /* Есть ли на платформе градиент. Нет — фон плоский, цвет можно не разрешать. */
    var hasGradient: Bool {
        background != nil
    }

    /* Линейный градиент сверху вниз для цвета фона; nil — фон плоский. */
    func fill(for color: SettingsIconColor) -> Fill? {
        guard let background else { return nil }
        let gradient = background.gradient(for: color)
        return Fill(
            top: gradient.top,
            bottom: gradient.bottom,
            topLocation: background.topLocation,
            bottomLocation: background.bottomLocation
        )
    }

    struct Fill: Equatable {
        let top: SettingsIconColor
        let bottom: SettingsIconColor
        let topLocation: CGFloat
        let bottomLocation: CGFloat
    }
}
