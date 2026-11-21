import CoreGraphics

/* Всё, чем иконка одной платформы отличается от другой: размер, доля глифа, фон, тень.
 Значения каждой платформы лежат в своём файле (SettingsIconMetrics+iOS и т. д.) и компилируются на всех платформах,
 поэтому тесты сверяют замеры всех платформ сразу. Платформа выбирается только в `current`.
 Рисующий код (SwiftUI и UIKit) берёт числа отсюда и не содержит своих #if os. */
struct SettingsIconMetrics: Sendable {

    /* Форма фона по умолчанию, как в системных Настройках. */
    let shape: SettingsIconShape

    /* pointSize фонового символа для SettingsIconSize.standard. */
    let standardPoints: CGFloat

    /* pointSize глифа как доля pointSize фона, до поправок конкретного глифа. */
    let glyphRatio: CGFloat

    /* Брать ли цвет фона в светлом варианте при тёмной теме. В Settings фон иконки от темы не зависит. */
    let usesLightColor: Bool

    /* Тень под глифом. */
    let shadow: Shadow

    /* Градиент фона; nil — фон плоский, исходным цветом. */
    let background: SettingsIconBackground?

    struct Shadow: Equatable, Sendable {

        /* Прозрачность чёрного. */
        let opacity: CGFloat

        /* Сдвиг вниз в pt. */
        let offset: CGFloat

        /* Радиус размытия в pt, как у SwiftUI .shadow(radius:). В Core Graphics blur вдвое больше. */
        let radius: CGFloat

        static let none = Shadow(opacity: 0, offset: 0, radius: 0)
    }

    /* Метрики платформы, на которой собрана библиотека. */
    static var current: SettingsIconMetrics {
        #if os(watchOS)
        .watchOS
        #elseif os(visionOS)
        .visionOS
        #elseif os(macOS)
        .macOS
        #else
        .iOS
        #endif
    }
}
