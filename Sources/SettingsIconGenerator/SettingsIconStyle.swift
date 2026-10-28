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
}
