import CoreGraphics

/* Оформление иконки поверх формы и размера.
 Замерено по скриншотам Settings на iOS 27 и watchOS 27. На macOS и visionOS не сверялось — там иконка плоская. */
enum SettingsIconStyle {

    #if os(iOS) || os(watchOS)
    /* Верх фона светлее низа примерно на 12%: цвет делится на (1 - gradientDodge), как в режиме color dodge.
     К низу градиент сходит к исходному цвету. */
    static let gradientDodge: CGFloat = 0.107
    #else
    static let gradientDodge: CGFloat = 0
    #endif

    #if os(iOS) || os(watchOS)
    /* Цвет фона всегда берётся в светлом варианте: на часах красный 255,56,60, а не тёмный 255,66,69. */
    static let usesLightColor = true
    #else
    static let usesLightColor = false
    #endif

    #if os(iOS)
    /* В тёмной теме вся иконка вместе с символом темнее на ~8.5%: серый 142 → 129, белый символ → 233. */
    static let darkModeBrightness: CGFloat = 0.915
    #else
    static let darkModeBrightness: CGFloat = 1
    #endif
}
