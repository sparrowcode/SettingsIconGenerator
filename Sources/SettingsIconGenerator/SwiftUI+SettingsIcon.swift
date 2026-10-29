import SwiftUI

/* Иконка в стиле Apple Settings для SwiftUI.
 Цветной фон (squircle или circle) с белым SF Symbol по центру. */
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
        /* Фон рисуется шрифтом с pointSize = size.points, как в UIKit-генераторе.
         resizable() растягивал бы форму на весь фрейм — фон выходил на ~10% крупнее, чем в UIKit. */
        let background = Image(systemName: shape.backgroundSymbolName)
            .font(.system(size: size.points))
            .imageScale(.medium)
        ZStack {
            /* Цвет с градиентом заливает весь фрейм, форму задаёт маска из символа фона:
             градиент прямо по символу давал тёмную кайму на сглаженном верхнем крае. */
            Rectangle()
                .fill(backgroundFill)
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
    }

    /* Градиент из замеров или формулы, как в UIKit-версии. Где градиента нет — плоский цвет. */
    private var backgroundFill: AnyShapeStyle {
        guard let gradient else { return AnyShapeStyle(backgroundColor) }
        func color(_ value: SettingsIconGradient.Components) -> Color {
            Color(.sRGB, red: value.red, green: value.green, blue: value.blue)
        }
        return AnyShapeStyle(LinearGradient(
            stops: [
                .init(color: color(gradient.top), location: SettingsIconGradient.topLocation),
                .init(color: color(gradient.bottom), location: SettingsIconGradient.bottomLocation)
            ],
            startPoint: .top,
            endPoint: .bottom
        ))
    }

    private var gradient: SettingsIconGradient? {
        #if os(iOS) || os(watchOS)
        var environment = environment
        if SettingsIconStyle.usesLightColor {
            environment.colorScheme = .light
        }
        let resolved: CGColor
        if #available(iOS 17, watchOS 10, *) {
            resolved = backgroundColor.resolve(in: environment).cgColor
        } else {
            #if os(iOS)
            let style: UIUserInterfaceStyle = environment.colorScheme == .dark ? .dark : .light
            resolved = UIColor(backgroundColor).resolvedColor(with: UITraitCollection(userInterfaceStyle: style)).cgColor
            #else
            return nil
            #endif
        }
        guard let sRGB = CGColorSpace(name: CGColorSpace.sRGB),
              let components = resolved.converted(to: sRGB, intent: .defaultIntent, options: nil)?.components,
              components.count >= 3 else { return nil }
        return SettingsIconGradient.make(red: components[0], green: components[1], blue: components[2])
        #else
        return nil
        #endif
    }
}
