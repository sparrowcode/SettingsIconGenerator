import CoreGraphics

/* Поправка размера символа по его имени, поверх общего iconRatio.
 Apple подгоняет размер под каждый глиф, а общий коэффициент даёт среднее совпадение:
 широкие символы упираются в края фона, отдельные выходят мельче системных. */
enum SettingsIconSymbolScale {

    static func scale(for systemName: String) -> CGFloat {
        corrections[systemName] ?? 1
    }

    /* Сдвиг символа по вертикали в долях его pointSize, минус — вверх.
     Символ ставится по центру рамки, а у глифов с весом внизу (треугольник) центр тяжести ниже центра рамки:
     в круге и сквиркле они выглядят опущенными. */
    static func verticalOffset(for systemName: String) -> CGFloat {
        verticalOffsets[systemName] ?? 0
    }

    private static let verticalOffsets: [String: CGFloat] = [
        /* Центр тяжести треугольника на трети высоты от основания. С подъёмом на 0.1 он встаёт в центр фона. */
        "exclamationmark.triangle.fill": -0.1
    ]

    private static let corrections: [String: CGFloat] = [
        /* Без поправки 98% ширины сквиркла: волны касаются краёв. С 0.85 — около 83%. */
        "iphone.radiowaves.left.and.right": 0.85,
        /* В Settings на iOS 27 шестерёнка 21.3 pt, без поправки 19 pt. */
        "gear": 1.12,
        /* Без поправки около 82% ширины сквиркла, крупнее соседних глифов. С 0.78 — около 64%. */
        "eye.slash.fill": 0.78,
        /* Без поправки 74% высоты сквиркла, выше любого глифа в Settings на iOS 27 (до 69%). С 0.9 — около 67%. */
        "key.fill": 0.9,
        /* В Settings на iOS 27 клавиатура 69 × 43% сквиркла, без поправки 76 × 48%. */
        "keyboard.fill": 0.9,
        /* Без поправки конверт около 75% ширины круга, шире соседних глифов. С 0.82 — около 62%. */
        "envelope.fill": 0.82
    ]
}
