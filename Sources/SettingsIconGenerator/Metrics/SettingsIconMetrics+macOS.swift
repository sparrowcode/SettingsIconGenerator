import CoreGraphics

extension SettingsIconMetrics {

    /* Системные Настройки macOS не сверялись: размеры как на iOS, фон плоский, без тени. */
    static let macOS = SettingsIconMetrics(
        shape: .squircle,
        standardPoints: SettingsIconMetrics.iOS.standardPoints,
        glyphRatio: SettingsIconMetrics.iOS.glyphRatio,
        usesLightColor: false,
        shadow: .none,
        background: nil
    )
}
