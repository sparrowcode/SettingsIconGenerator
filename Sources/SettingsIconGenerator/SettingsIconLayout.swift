import CoreGraphics

/* Всё, что нужно нарисовать одну иконку: размеры, сдвиг и тень глифа, градиент фона.
 Считается здесь один раз, SwiftUI и UIKit только рисуют по этим числам. */
struct SettingsIconLayout {

    /* pointSize фонового символа. */
    let backgroundPoints: CGFloat

    /* pointSize глифа с поправкой глифа. */
    let glyphPoints: CGFloat

    /* Сдвиг глифа вниз от центра в pt. */
    let glyphOffset: CGFloat

    let shadow: SettingsIconMetrics.Shadow

    init(systemName: String, size: SettingsIconSize, metrics: SettingsIconMetrics = .current) {
        backgroundPoints = size.points(metrics)
        glyphPoints = backgroundPoints * metrics.glyphRatio * SettingsIconGlyph.scale(for: systemName)
        glyphOffset = glyphPoints * SettingsIconGlyph.verticalOffset(for: systemName)
        shadow = metrics.shadow
    }
}
