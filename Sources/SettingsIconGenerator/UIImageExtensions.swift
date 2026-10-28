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

        let gradient = gradientOverlay(background, color: backgroundColor)
        let topRim = rimOverlay(background, brightness: SettingsIconStyle.rimTopBrightness, towardsTop: true)
        let bottomRim = rimOverlay(background, brightness: SettingsIconStyle.rimBottomBrightness, towardsTop: false)

        /* Фон собирается на непрозрачном слое и обрезается формой в конце, как в SwiftUI.
         Кромка в plus lighter прямо по полупрозрачным пикселям сглаженного края добавляла им серой плотности, и край темнел. */
        let backgroundLayer = UIGraphicsImageRenderer(size: background.size).image { context in
            backgroundColor.setFill()
            context.fill(CGRect(origin: .zero, size: background.size))
            gradient?.draw(at: .zero)
            topRim?.draw(at: .zero, blendMode: .plusLighter, alpha: 1)
            bottomRim?.draw(at: .zero, blendMode: .plusLighter, alpha: 1)
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

        let isDark = UITraitCollection.current.userInterfaceStyle == .dark

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

            /* Чёрный поверх нарисованного с прозрачностью (1 - darkModeBrightness) умножает цвета на darkModeBrightness. */
            if isDark && SettingsIconStyle.darkModeBrightness < 1 {
                UIColor.black.withAlphaComponent(1 - SettingsIconStyle.darkModeBrightness).setFill()
                context.fill(CGRect(origin: .zero, size: canvasSize), blendMode: .sourceAtop)
            }
        }
    }

    /* Верх фона светлее низа: тот же фон в осветлённом цвете, растворяющийся к низу. Как в SwiftUI-версии. */
    private static func gradientOverlay(_ background: UIImage, color: UIColor) -> UIImage? {
        guard SettingsIconStyle.gradientDodge > 0 else { return nil }
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        guard color.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else { return nil }

        /* Color dodge: компонента делится на (1 - gradientDodge), но не выше 1. */
        func dodge(_ component: CGFloat) -> CGFloat {
            max(component, min(component / (1 - SettingsIconStyle.gradientDodge), 1))
        }
        let lighter = UIColor(red: dodge(red), green: dodge(green), blue: dodge(blue), alpha: alpha)
        let fade = CGGradient(
            colorsSpace: nil,
            colors: [UIColor.clear.cgColor, UIColor.black.cgColor] as CFArray,
            locations: nil
        )!

        return UIGraphicsImageRenderer(size: background.size).image { context in
            background.withTintColor(lighter, renderingMode: .alwaysOriginal).draw(at: .zero)
            context.cgContext.setBlendMode(.destinationOut)
            context.cgContext.drawLinearGradient(fade, start: .zero, end: CGPoint(x: 0, y: background.size.height), options: [])
        }
    }

    /* Светлая кромка в один пиксель: фон серым цветом минус он же, сдвинутый на пиксель.
     Кладётся поверх в режиме plus lighter. Как в SwiftUI-версии. */
    private static func rimOverlay(_ background: UIImage, brightness: CGFloat, towardsTop: Bool) -> UIImage? {
        guard brightness > 0 else { return nil }
        let format = UIGraphicsImageRendererFormat.preferred()
        let pixel = 1 / format.scale
        return UIGraphicsImageRenderer(size: background.size, format: format).image { _ in
            background.withTintColor(UIColor(white: brightness, alpha: 1), renderingMode: .alwaysOriginal).draw(at: .zero)
            background.draw(at: CGPoint(x: 0, y: towardsTop ? pixel : -pixel), blendMode: .destinationOut, alpha: 1)
        }
    }
}
#endif
