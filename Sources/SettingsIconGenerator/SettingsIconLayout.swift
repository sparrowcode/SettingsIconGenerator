import CoreGraphics

/* Всё, что нужно нарисовать одну иконку: размеры, сдвиг и тень глифа, заливка фона.
 Считается из метрик платформы и поправок глифа один раз. SwiftUI и UIKit рисуют только по layout и к метрикам не обращаются. */
struct SettingsIconLayout {

    /* pointSize фонового символа. */
    let backgroundPoints: CGFloat

    /* pointSize глифа с поправкой глифа. */
    let glyphPoints: CGFloat

    /* Сдвиг глифа вниз от центра в pt. */
    let glyphOffset: CGFloat

    let shadow: SettingsIconMetrics.Shadow

    /* Цвет фона берётся в светлом варианте, какой бы ни была тема. */
    let usesLightColor: Bool

    private let background: SettingsIconBackground?

    init(systemName: String, size: SettingsIconSize, metrics: SettingsIconMetrics = .current) {
        backgroundPoints = size.points(metrics)
        glyphPoints = backgroundPoints * metrics.glyphRatio * SettingsIconGlyph.scale(for: systemName)
        glyphOffset = glyphPoints * SettingsIconGlyph.verticalOffset(for: systemName)
        shadow = metrics.shadow
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
