#if canImport(UIKit) && !os(watchOS)
import UIKit

extension UIImage {

    /* Генерирует иконку в стиле Apple Settings: цветной фон (squircle или circle) с белым SF Symbol по центру.
     Рендерит фон в натуральном размере SF Symbol — без масштабирования, без канвас-ограничений.
     Корректный layout в UIListContentConfiguration обеспечивается через reservedLayoutSize и maximumSize
     на стороне потребителя, а не через размер изображения. Числа берутся из SettingsIconLayout, как в SwiftUI. */
    public static func generateSettingsIcon(
        _ systemName: String,
        backgroundColor: UIColor,
        shape: SettingsIconShape = .platformDefault,
        size: SettingsIconSize = .standard
    ) -> UIImage? {
        let metrics = SettingsIconMetrics.current
        let layout = SettingsIconLayout(systemName: systemName, size: size, metrics: metrics)
        let backgroundColor = metrics.usesLightColor
            ? backgroundColor.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
            : backgroundColor

        let backgroundConfig = UIImage.SymbolConfiguration(pointSize: layout.backgroundPoints, weight: .regular)
        guard let background = UIImage(systemName: shape.backgroundSymbolName, withConfiguration: backgroundConfig)?
            .withTintColor(backgroundColor, renderingMode: .alwaysOriginal) else { return nil }

        let gradient = metrics.background.flatMap { gradientFill(size: background.size, color: backgroundColor, background: $0) }

        /* Фон собирается на непрозрачном слое и обрезается формой в конце, как в SwiftUI:
         градиент прямо по сглаженному краю символа давал тёмную кайму. */
        let backgroundLayer = UIGraphicsImageRenderer(size: background.size).image { context in
            backgroundColor.setFill()
            context.fill(CGRect(origin: .zero, size: background.size))
            gradient?.draw(at: .zero)
            background.draw(at: .zero, blendMode: .destinationIn, alpha: 1)
        }

        let iconConfig = UIImage.SymbolConfiguration(pointSize: layout.glyphPoints, weight: .regular)
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
                    y: (canvasDimension - iconSize.height) / 2 + layout.glyphOffset
                )
                context.cgContext.setShadow(
                    offset: CGSize(width: 0, height: layout.shadow.offset),
                    blur: layout.shadow.radius * 2,
                    color: UIColor.black.withAlphaComponent(layout.shadow.opacity).cgColor
                )
                icon.draw(at: iconOrigin)
            }
        }
    }

    /* Верх фона светлее низа: цвета градиента стоят на тех же высотах, где замерены, за ними продолжаются. Как в SwiftUI-версии. */
    private static func gradientFill(size: CGSize, color: UIColor, background: SettingsIconBackground) -> UIImage? {
        guard let sRGB = CGColorSpace(name: CGColorSpace.sRGB),
              let components = SettingsIconColor(color.cgColor) else { return nil }
        let gradient = background.gradient(for: components)
        let alpha = color.cgColor.alpha

        func cgColor(_ value: SettingsIconColor) -> CGColor {
            CGColor(colorSpace: sRGB, components: [value.red, value.green, value.blue, alpha])!
        }
        guard let fill = CGGradient(
            colorsSpace: sRGB,
            colors: [cgColor(gradient.top), cgColor(gradient.bottom)] as CFArray,
            locations: [background.topLocation, background.bottomLocation]
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
