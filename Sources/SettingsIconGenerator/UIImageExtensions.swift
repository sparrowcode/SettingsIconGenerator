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
        let backgroundPointSize = size.points
        let iconPointSize = size.iconFontSize

        let backgroundConfig = UIImage.SymbolConfiguration(pointSize: backgroundPointSize, weight: .regular)
        guard let background = UIImage(systemName: shape.backgroundSymbolName, withConfiguration: backgroundConfig)?
            .withTintColor(backgroundColor, renderingMode: .alwaysOriginal) else { return nil }

        let gradient = gradientOverlay(background, color: backgroundColor)

        let iconConfig = UIImage.SymbolConfiguration(pointSize: iconPointSize, weight: .regular)
        let icon = UIImage(systemName: systemName, withConfiguration: iconConfig)?
            .withTintColor(.white, renderingMode: .alwaysOriginal)

        /* Канвас = натуральный размер фона. Квадрат по большей стороне. */
        let naturalSize = background.size
        let canvasDimension = max(naturalSize.width, naturalSize.height)
        let canvasSize = CGSize(width: canvasDimension, height: canvasDimension)
        let renderer = UIGraphicsImageRenderer(size: canvasSize)

        return renderer.image { _ in
            let backgroundOrigin = CGPoint(
                x: (canvasDimension - naturalSize.width) / 2,
                y: (canvasDimension - naturalSize.height) / 2
            )
            background.draw(at: backgroundOrigin)
            gradient?.draw(at: backgroundOrigin)

            if let icon {
                let iconSize = icon.size
                let iconOrigin = CGPoint(
                    x: (canvasDimension - iconSize.width) / 2,
                    y: (canvasDimension - iconSize.height) / 2
                )
                icon.draw(at: iconOrigin)
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
}
#endif
