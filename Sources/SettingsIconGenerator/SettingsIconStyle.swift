import CoreGraphics

/* Оформление иконки поверх формы и размера.
 Замерено по скриншотам Settings на iOS 27 и watchOS 27. На macOS и visionOS не сверялось — там иконка плоская. */
enum SettingsIconStyle {

    #if os(iOS) || os(watchOS)
    /* Цвет фона всегда берётся в светлом варианте: на часах красный 255,56,60, а не тёмный 255,66,69. */
    static let usesLightColor = true
    #else
    static let usesLightColor = false
    #endif

    #if os(iOS)
    /* Под символом мягкая тень: снизу затемняет фон на ~6% и тянется ~2 pt, по бокам слабее, сверху нет. */
    static let symbolShadowOpacity: CGFloat = 0.09
    static let symbolShadowOffset: CGFloat = 0.8
    static let symbolShadowRadius: CGFloat = 0.75
    #elseif os(watchOS)
    /* На часах тень почти незаметна: под символом фон темнее на ~3% и только на 1–2 px. */
    static let symbolShadowOpacity: CGFloat = 0.045
    static let symbolShadowOffset: CGFloat = 0.5
    static let symbolShadowRadius: CGFloat = 0.35
    #else
    static let symbolShadowOpacity: CGFloat = 0
    static let symbolShadowOffset: CGFloat = 0
    static let symbolShadowRadius: CGFloat = 0
    #endif
}
