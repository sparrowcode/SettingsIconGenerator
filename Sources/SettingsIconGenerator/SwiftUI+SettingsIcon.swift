import SwiftUI

/* Иконка в стиле Apple Settings для SwiftUI.
 Цветной фон (squircle или circle) с белым SF Symbol по центру. Числа берутся из SettingsIconLayout. */
public struct SettingsIcon: View {

    let systemName: String
    let backgroundColor: Color
    let shape: SettingsIconShape
    let size: SettingsIconSize

    @Environment(\.self) private var environment
    @Environment(\.colorScheme) private var colorScheme

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
        let layout = SettingsIconLayout(systemName: systemName, size: size, shape: shape)
        /* Фон рисуется шрифтом с pointSize фона, как в UIKit-генераторе.
         resizable() растягивал бы форму на весь фрейм — фон выходил на ~10% крупнее, чем в UIKit. */
        let background = Image(systemName: shape.backgroundSymbolName)
            .font(.system(size: layout.backgroundPoints))
            .imageScale(.medium)
        ZStack {
            /* Цвет с градиентом заливает весь фрейм, форму задаёт маска из символа фона:
             градиент прямо по символу давал тёмную кайму на сглаженном верхнем крае. */
            Rectangle()
                .fill(backgroundFill(layout))
                .environment(\.colorScheme, layout.usesLightColor ? .light : colorScheme)
                .mask { background }
                .shadow(color: .black.opacity(layout.plateShadow.opacity), radius: layout.plateShadow.radius, y: layout.plateShadow.offset)
            if let rim = layout.rim {
                /* Кромка сверху: форма минус та же форма, сдвинутая вниз на толщину кромки. Снизу — наоборот. */
                rimBand(background, width: rim.width, opacity: rim.topOpacity)
                rimBand(background, width: -rim.width, opacity: rim.bottomOpacity)
            }
            /* Label в List ставит иконке imageScale(.large) — символ вырастает ~на четверть.
             Фиксируем .medium, чтобы размер задавал только layout. */
            Image(systemName: systemName)
                .font(.system(size: layout.glyphPoints))
                .imageScale(.medium)
                .foregroundStyle(.white)
                .offset(y: layout.glyphOffset)
                .shadow(color: .black.opacity(layout.shadow.opacity), radius: layout.shadow.radius, y: layout.shadow.offset)
        }
        .frame(width: layout.frameSide, height: layout.frameSide)
    }

    /* Белая полоска вдоль края формы: `width` > 0 — верхний край, < 0 — нижний. */
    private func rimBand(_ shape: some View, width: CGFloat, opacity: CGFloat) -> some View {
        Rectangle()
            .fill(.white.opacity(opacity))
            .mask {
                shape
                    .overlay { shape.offset(y: width).blendMode(.destinationOut) }
                    .compositingGroup()
            }
            .blendMode(.plusLighter)
    }

    /* Градиент из layout; где его нет — плоский цвет. */
    private func backgroundFill(_ layout: SettingsIconLayout) -> AnyShapeStyle {
        guard layout.hasGradient,
              let resolved = resolvedColor(light: layout.usesLightColor),
              let fill = layout.fill(for: resolved) else { return AnyShapeStyle(backgroundColor) }
        func color(_ value: SettingsIconColor) -> Color {
            Color(.sRGB, red: value.red, green: value.green, blue: value.blue)
        }
        return AnyShapeStyle(LinearGradient(
            stops: [
                .init(color: color(fill.top), location: fill.topLocation),
                .init(color: color(fill.bottom), location: fill.bottomLocation)
            ],
            startPoint: .top,
            endPoint: .bottom
        ))
    }

    /* Цвет фона в текущем окружении, при usesLightColor — в светлой теме. */
    private func resolvedColor(light: Bool) -> SettingsIconColor? {
        var environment = environment
        if light {
            environment.colorScheme = .light
        }
        if #available(iOS 17, macOS 14, watchOS 10, visionOS 1, *) {
            return SettingsIconColor(backgroundColor.resolve(in: environment).cgColor)
        }
        /* До iOS 17 Color.resolve нет: цвет разрешается через UIKit. Ветка про API, не про метрики платформы. */
        #if canImport(UIKit) && !os(watchOS)
        let style: UIUserInterfaceStyle = environment.colorScheme == .dark ? .dark : .light
        return SettingsIconColor(UIColor(backgroundColor).resolvedColor(with: UITraitCollection(userInterfaceStyle: style)).cgColor)
        #else
        return nil
        #endif
    }
}
