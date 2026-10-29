#if canImport(UIKit) && !os(watchOS)
import UIKit

extension UIImage {

    /* Генерирует иконку в стиле Apple Settings: цветной фон (squircle или circle) с белым SF Symbol по центру.
     Рендерит фон в натуральном размере SF Symbol — без масштабирования, без канвас-ограничений.
     Корректный layout в UIListContentConfiguration обеспечивается через reservedLayoutSize и maximumSize
     на стороне потребителя, а не через размер изображения. */
    public static func generateSettingsIcon(
        _ systemName: String,
        backgroundColor: UIColor,
        shape: SettingsIconShape = .platformDefault,
        size: SettingsIconSize = .standard
    ) -> UIImage? {
        let backgroundColor = SettingsIconStyle.usesLightColor
            ? backgroundColor.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
            : backgroundColor
        let backgroundPointSize = size.points
        let iconPointSize = size.iconFontSize

        let backgroundConfig = UIImage.SymbolConfiguration(pointSize: backgroundPointSize, weight: .regular)
        guard let background = UIImage(systemName: shape.backgroundSymbolName, withConfiguration: backgroundConfig)?
            .withTintColor(backgroundColor, renderingMode: .alwaysOriginal) else { return nil }

        let gradient = gradientFill(size: background.size, color: backgroundColor)

        /* Фон собирается на непрозрачном слое и обрезается формой в конце, как в SwiftUI:
         градиент прямо по сглаженному краю символа давал тёмную кайму. */
        let backgroundLayer = UIGraphicsImageRenderer(size: background.size).image { context in
            backgroundColor.setFill()
            context.fill(CGRect(origin: .zero, size: background.size))
            gradient?.draw(at: .zero)
            background.draw(at: .zero, blendMode: .destinationIn, alpha: 1)
        }

        let iconConfig = UIImage.SymbolConfiguration(pointSize: iconPointSize, weight: .regular)
        let icon = UIImage(systemName: systemName, withConfiguration: iconConfig)?
            .withTintColor(.white, renderingMode: .alwaysOriginal)

        /* Канвас = натуральный размер фона. Квадрат по большей стороне. */
        let naturalSize = background.size
        let canvasDimension = max(naturalSize.width, naturalSize.height)
        let canvasSize = CGSize(width: canvasDimension, height: canvasDimension)
        let renderer = UIGraphicsImageRenderer(size: canvasSize)

        return renderer.image { context in
            let backgroundOrigin = CGPoint(
                x: (canvasDimension - naturalSize.width) / 2,
                y: (canvasDimension - naturalSize.height) / 2
            )
            backgroundLayer.draw(at: backgroundOrigin)

            if let icon {
                let iconSize = icon.size
                let iconOrigin = CGPoint(
                    x: (canvasDimension - iconSize.width) / 2,
                    y: (canvasDimension - iconSize.height) / 2
                )
                context.cgContext.setShadow(
                    offset: CGSize(width: 0, height: SettingsIconStyle.symbolShadowOffset),
                    blur: SettingsIconStyle.symbolShadowRadius * 2,
                    color: UIColor.black.withAlphaComponent(SettingsIconStyle.symbolShadowOpacity).cgColor
                )
                icon.draw(at: iconOrigin)
            }
        }
    }

    /* Верх фона светлее низа: цвета градиента стоят на тех же высотах, где замерены, за ними продолжаются. Как в SwiftUI-версии. */
    private static func gradientFill(size: CGSize, color: UIColor) -> UIImage? {
        guard let sRGB = CGColorSpace(name: CGColorSpace.sRGB),
              let converted = color.cgColor.converted(to: sRGB, intent: .defaultIntent, options: nil),
              let components = converted.components, components.count >= 3,
              let gradient = SettingsIconGradient.make(red: components[0], green: components[1], blue: components[2])
        else { return nil }

        func cgColor(_ value: SettingsIconGradient.Components) -> CGColor {
            CGColor(colorSpace: sRGB, components: [value.red, value.green, value.blue, converted.alpha])!
        }
        guard let fill = CGGradient(
            colorsSpace: sRGB,
            colors: [cgColor(gradient.top), cgColor(gradient.bottom)] as CFArray,
            locations: [SettingsIconGradient.topLocation, SettingsIconGradient.bottomLocation]
        ) else { return nil }

        return UIGraphicsImageRenderer(size: size).image { context in
            context.cgContext.drawLinearGradient(
                fill,
                start: .zero,
                end: CGPoint(x: 0, y: size.height),
                options: [.drawsBeforeStartLocation, .drawsAfterEndLocation]
            )
        }
    }
}
#endif
