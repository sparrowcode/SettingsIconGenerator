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

    /* Тень под всей плашкой. На macOS иконка Настроек лежит на тени, на остальных платформах её нет. */
    let plateShadow: Shadow

    /* Светлая кромка по верхнему и нижнему краю плашки; nil — без кромки. */
    let rim: Rim?

    /* Рамка SwiftUI-иконки по видимой плашке, а не по pointSize фона. Тогда край плашки ложится на пиксель,
     а соседи в строке отсчитывают отступ от плашки, как в Настройках. */
    let framesPlate: Bool

    /* Glyph-поправки, которые на этой платформе отличаются от общих (SettingsIconGlyph). */
    let glyphScales: [String: CGFloat]

    init(
        shape: SettingsIconShape,
        standardPoints: CGFloat,
        glyphRatio: CGFloat,
        usesLightColor: Bool,
        shadow: Shadow,
        background: SettingsIconBackground?,
        plateShadow: Shadow = .none,
        rim: Rim? = nil,
        framesPlate: Bool = false,
        glyphScales: [String: CGFloat] = [:]
    ) {
        self.shape = shape
        self.standardPoints = standardPoints
        self.glyphRatio = glyphRatio
        self.usesLightColor = usesLightColor
        self.shadow = shadow
        self.background = background
        self.plateShadow = plateShadow
        self.rim = rim
        self.framesPlate = framesPlate
        self.glyphScales = glyphScales
    }

    /* Множитель pointSize глифа: поправка платформы, иначе общая. */
    func glyphScale(for systemName: String) -> CGFloat {
        glyphScales[systemName] ?? SettingsIconGlyph.scale(for: systemName)
    }

    struct Shadow: Equatable, Sendable {

        /* Прозрачность чёрного. */
        let opacity: CGFloat

        /* Сдвиг вниз в pt. */
        let offset: CGFloat

        /* Радиус размытия в pt, как у SwiftUI .shadow(radius:). В Core Graphics blur вдвое больше. */
        let radius: CGFloat

        static let none = Shadow(opacity: 0, offset: 0, radius: 0)
    }

    /* Кромка: белая полоска толщиной `width` pt вдоль верхнего и нижнего края формы. Её толщина сходит
     на нет к бокам сама: полоска — это форма минус та же форма, сдвинутая на `width`. */
    struct Rim: Equatable, Sendable {

        let width: CGFloat

        /* Сколько белого прибавить сверху и снизу (plusLighter, доля 255 на канал). */
        let topOpacity: CGFloat
        let bottomOpacity: CGFloat
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
