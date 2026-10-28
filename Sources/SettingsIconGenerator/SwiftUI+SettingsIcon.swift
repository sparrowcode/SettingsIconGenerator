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
        shape: SettingsIconShape = .squircle,
        size: SettingsIconSize = .standard
    ) {
        self.systemName = systemName
        self.backgroundColor = backgroundColor
        self.shape = shape
        self.size = size
    }

    public var body: some View {
        ZStack {
            Image(systemName: shape.backgroundSymbolName)
                .resizable()
                .scaledToFit()
                .foregroundStyle(backgroundColor)
                .frame(width: size.points, height: size.points)
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
