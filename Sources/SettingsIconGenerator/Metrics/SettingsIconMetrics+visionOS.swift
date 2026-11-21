import CoreGraphics

extension SettingsIconMetrics {

    /* Settings на visionOS 27. Пока сверены только размеры, фон плоский. */
    static let visionOS = SettingsIconMetrics(
        shape: .circle,
        /* circle.fill даёт ~1.0 от pointSize: круг 32 pt. */
        standardPoints: 32,
        /* Символ около 19.2 pt на круге 32 pt. */
        glyphRatio: 0.6,
        usesLightColor: false,
        shadow: .none,
        background: nil
    )
}
