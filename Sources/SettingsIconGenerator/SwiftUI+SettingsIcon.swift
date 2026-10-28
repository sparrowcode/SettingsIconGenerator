import SwiftUI

/* Иконка в стиле Apple Settings для SwiftUI.
 Цветной фон (squircle или circle) с белым SF Symbol по центру. */
public struct SettingsIcon: View {

    let systemName: String
    let backgroundColor: Color
    let shape: SettingsIconShape
    let size: SettingsIconSize

    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.displayScale) private var displayScale

    public init(
        systemName: String,
        backgroundColor: Color,
        shape: SettingsIconShape = .platformDefault,
        size: SettingsIconSize = .standard
    ) {
        self.systemName = systemName
        self.backgroundColor = backgroundColor
        self.shape = shape
        self.size = size
    }

    public var body: some View {
        /* Фон рисуется шрифтом с pointSize = size.points, как в UIKit-генераторе.
         resizable() растягивал бы форму на весь фрейм — фон выходил на ~10% крупнее, чем в UIKit. */
        let background = Image(systemName: shape.backgroundSymbolName)
            .font(.system(size: size.points))
            .imageScale(.medium)
        ZStack {
            /* Цвет с градиентом заливает весь фрейм, форму задаёт маска из символа фона.
             Color dodge прямо по символу давал тёмную кайму на сглаженном верхнем крае. */
            Rectangle()
                .fill(backgroundColor)
                .overlay {
                    /* Color dodge с серым осветляет цвет пропорционально. К низу гаснет прозрачностью:
                     переход от серого к чёрному SwiftUI интерполирует нелинейно, и осветление сходило на нет уже к середине. */
                    LinearGradient(
                        colors: [Color(white: SettingsIconStyle.gradientDodge), Color(white: SettingsIconStyle.gradientDodge).opacity(0)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .blendMode(.colorDodge)
                }
                .overlay { rim(of: background, offset: 1 / displayScale, brightness: SettingsIconStyle.rimTopBrightness) }
                .overlay { rim(of: background, offset: -1 / displayScale, brightness: SettingsIconStyle.rimBottomBrightness) }
                .compositingGroup()
                .environment(\.colorScheme, SettingsIconStyle.usesLightColor ? .light : colorScheme)
                .mask { background }
            /* Label в List ставит иконке imageScale(.large) — символ вырастает ~на четверть.
             Фиксируем .medium, чтобы размер задавал только iconFontSize. */
            Image(systemName: systemName)
                .font(.system(size: size.iconFontSize))
                .imageScale(.medium)
                .foregroundStyle(.white)
                .shadow(
                    color: .black.opacity(SettingsIconStyle.symbolShadowOpacity),
                    radius: SettingsIconStyle.symbolShadowRadius,
                    y: SettingsIconStyle.symbolShadowOffset
                )
        }
        .frame(width: size.points, height: size.points)
        .colorMultiply(Color(white: colorScheme == .dark ? SettingsIconStyle.darkModeBrightness : 1))
    }

    /* Светлая кромка: фон минус он же, сдвинутый на offset. Положительный сдвиг оставляет полосу сверху, отрицательный — снизу.
     Сдвиг — один пиксель экрана: дробный SwiftUI округляет к сетке, и на часах верхняя полоса пропадала. */
    private func rim(of background: some View, offset: CGFloat, brightness: CGFloat) -> some View {
        Rectangle()
            .fill(Color(white: brightness))
            .mask {
                background
                    .overlay { background.offset(y: offset).blendMode(.destinationOut) }
                    .compositingGroup()
            }
            .blendMode(.plusLighter)
    }
}
