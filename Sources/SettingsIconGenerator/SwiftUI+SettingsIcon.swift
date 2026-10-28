import SwiftUI

/* Иконка в стиле Apple Settings для SwiftUI.
 Цветной фон (squircle или circle) с белым SF Symbol по центру. */
public struct SettingsIcon: View {

    let systemName: String
    let backgroundColor: Color
    let shape: SettingsIconShape
    let size: SettingsIconSize

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
            background
                .foregroundStyle(backgroundColor)
                .overlay {
                    /* Color dodge с серым осветляет цвет пропорционально. К низу гаснет прозрачностью:
                     переход от серого к чёрному SwiftUI интерполирует нелинейно, и осветление сходило на нет уже к середине. */
                    background
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color(white: SettingsIconStyle.gradientDodge), Color(white: SettingsIconStyle.gradientDodge).opacity(0)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .blendMode(.colorDodge)
                }
                .compositingGroup()
            /* Label в List ставит иконке imageScale(.large) — символ вырастает ~на четверть.
             Фиксируем .medium, чтобы размер задавал только iconFontSize. */
            Image(systemName: systemName)
                .font(.system(size: size.iconFontSize))
                .imageScale(.medium)
                .foregroundStyle(.white)
        }
        .frame(width: size.points, height: size.points)
    }
}
