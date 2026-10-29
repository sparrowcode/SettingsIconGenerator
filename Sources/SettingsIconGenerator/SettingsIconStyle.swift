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

    #if os(watchOS)
    /* На часах по верхнему краю круга светлая кромка в пиксель: красный 255,63,66 → 255,75,78, снизу слабее.
     Цвет прибавляется в режиме plus lighter. На iPhone кромки нет: в тёмной теме крайний пиксель темнее, а не светлее. */
    static let rimTopBrightness: CGFloat = 0.12
    static let rimBottomBrightness: CGFloat = 0.1
    #else
    static let rimTopBrightness: CGFloat = 0
    static let rimBottomBrightness: CGFloat = 0
    #endif

    #if os(iOS) || os(watchOS)
    /* Под символом мягкая тень: снизу затемняет фон на ~5% и тянется ~1.5 pt, по бокам слабее, сверху почти нет. */
    static let symbolShadowOpacity: CGFloat = 0.09
    static let symbolShadowOffset: CGFloat = 0.8
    static let symbolShadowRadius: CGFloat = 0.75
    #else
    static let symbolShadowOpacity: CGFloat = 0
    static let symbolShadowOffset: CGFloat = 0
    static let symbolShadowRadius: CGFloat = 0
    #endif
}
