import CoreGraphics
import XCTest
#if os(iOS)
import UIKit
#endif
@testable import SettingsIconGenerator

/* Фиксируют замеры платформ: любое изменение числа должно быть осознанным и сверенным с Настройками. */
final class MetricsTests: XCTestCase {

    func testIOS() {
        let metrics = SettingsIconMetrics.iOS
        XCTAssertEqual(metrics.shape, .squircle)
        XCTAssertEqual(metrics.standardPoints, 31)
        XCTAssertEqual(metrics.glyphRatio, 0.56)
        XCTAssertTrue(metrics.usesLightColor)
        XCTAssertEqual(metrics.shadow, .init(opacity: 0.09, offset: 0.8, radius: 0.75))
        let background = try! XCTUnwrap(metrics.background)
        XCTAssertEqual(background.topLocation, 0.077)
        XCTAssertEqual(background.bottomLocation, 0.91)
        XCTAssertEqual(background.palette.count, 7)
        XCTAssertEqual(background.gradient(for: .init((0, 136, 255))), .init(top: (0, 147, 255), bottom: (0, 136, 255)))
        XCTAssertEqual(background.gradient(for: .init((142, 142, 147))), .init(top: (159, 159, 164), bottom: (142, 142, 147)))
    }

    func testWatchOS() {
        let metrics = SettingsIconMetrics.watchOS
        XCTAssertEqual(metrics.shape, .circle)
        XCTAssertEqual(metrics.standardPoints, 25.5)
        XCTAssertEqual(metrics.glyphRatio, 0.5)
        XCTAssertTrue(metrics.usesLightColor)
        XCTAssertEqual(metrics.shadow, .init(opacity: 0.045, offset: 0.5, radius: 0.35))
        let background = try! XCTUnwrap(metrics.background)
        XCTAssertEqual(background.topLocation, 0.065)
        XCTAssertEqual(background.bottomLocation, 0.9)
        XCTAssertEqual(background.palette.count, 6)
        XCTAssertEqual(background.gradient(for: .init((255, 141, 40))), .init(top: (249, 151, 53), bottom: (255, 141, 40)))
    }

    func testMacOSFollowsIOSSizesWithFlatBackground() {
        let metrics = SettingsIconMetrics.macOS
        XCTAssertEqual(metrics.shape, .squircle)
        XCTAssertEqual(metrics.standardPoints, SettingsIconMetrics.iOS.standardPoints)
        XCTAssertEqual(metrics.glyphRatio, SettingsIconMetrics.iOS.glyphRatio)
        XCTAssertNil(metrics.background)
        XCTAssertEqual(metrics.shadow, .none)
    }

    /* Цвет в пределах 3 единиц от системного берёт замер, дальше — формулу. */
    func testPaletteTolerance() {
        let background = SettingsIconMetrics.iOS.background!
        XCTAssertEqual(background.gradient(for: .init((3, 133, 252))).top, .init((0, 147, 255)))
        let custom = SettingsIconColor((4, 136, 255))
        XCTAssertEqual(background.gradient(for: custom).bottom, custom)
        XCTAssertNotEqual(background.gradient(for: custom).top, .init((0, 147, 255)))
    }

    /* Формула для цветов без замера: по замеренным цветам iOS не дальше 6 единиц от системы. */
    func testFallbackCloseToMeasuredIOS() {
        let background = SettingsIconMetrics.iOS.background!
        XCTAssertEqual(background.fallback, .init(dodge: 0.08, white: 0.0225))
        for measured in background.palette where measured.bottom != .init((0, 0, 0)) {
            let top = background.fallback.apply(to: measured.bottom)
            for (formula, system) in [(top.red, measured.top.red), (top.green, measured.top.green), (top.blue, measured.top.blue)] {
                XCTAssertLessThanOrEqual(abs(formula - system) * 255, 6.5, "\(measured)")
            }
        }
    }

    func testLayoutAppliesGlyphCorrections() {
        let iOS = SettingsIconMetrics.iOS
        let gear = SettingsIconLayout(systemName: "gear", size: .standard, metrics: iOS)
        XCTAssertEqual(gear.backgroundPoints, 31)
        XCTAssertEqual(gear.glyphPoints, 31 * 0.56 * 1.12, accuracy: 0.0001)
        XCTAssertEqual(gear.glyphOffset, 0)

        let triangle = SettingsIconLayout(systemName: "exclamationmark.triangle.fill", size: .custom(26), metrics: .watchOS)
        XCTAssertEqual(triangle.backgroundPoints, 26)
        XCTAssertEqual(triangle.glyphPoints, 13, accuracy: 0.0001)
        XCTAssertEqual(triangle.glyphOffset, -1.3, accuracy: 0.0001)
        XCTAssertEqual(triangle.shadow, SettingsIconMetrics.watchOS.shadow)
    }

    #if os(iOS)
    /* Системные цвета текущей iOS попадают в замеренную палитру — иначе их градиент считается формулой. */
    func testSystemColorsMatchIOSPalette() {
        let light = UITraitCollection(userInterfaceStyle: .light)
        let palette = SettingsIconMetrics.iOS.background!.palette
        for color in [UIColor.systemRed, .systemOrange, .systemGreen, .systemBlue, .systemIndigo, .systemGray, .black] {
            let resolved = SettingsIconColor(color.resolvedColor(with: light).cgColor)!
            XCTAssertTrue(palette.contains { $0.bottom.isClose(to: resolved) }, "\(color) → \(resolved)")
        }
    }
    #endif
}

/* Сверка visionOS со скриншотом Settings на visionOS 27.2 (координаты Display P3): не дальше 2 единиц на компоненту. */
final class VisionMetricsTests: XCTestCase {

    func testVisionOSMatchesSettings() {
        let metrics = SettingsIconMetrics.visionOS
        XCTAssertEqual(metrics.shape, .circle)
        XCTAssertEqual(metrics.standardPoints, 32)
        XCTAssertEqual(metrics.glyphRatio, 0.6)
        XCTAssertTrue(metrics.usesLightColor)
        let background = try! XCTUnwrap(metrics.background)
        let measured: [((Int, Int, Int), top: (Int, Int, Int), bottom: (Int, Int, Int))] = [
            ((52, 199, 89), (112, 210, 114), (101, 197, 102)),   // зелёный, «Люди»
            ((0, 136, 255), (64, 144, 247), (59, 134, 247)),     // синий, «Универсальный доступ»
            ((97, 85, 245), (107, 97, 246), (95, 85, 237)),      // индиго, «Окружения»
            ((142, 142, 147), (159, 159, 164), (144, 144, 149))  // серый, «Шрифты»
        ]
        for (source, top, bottom) in measured {
            let gradient = background.gradient(for: .init(source))
            assertClose(displayP3(gradient.top), .init(top), "\(source) top")
            assertClose(displayP3(gradient.bottom), .init(bottom), "\(source) bottom")
        }
    }

    private func displayP3(_ color: SettingsIconColor) -> SettingsIconColor {
        let sRGB = CGColorSpace(name: CGColorSpace.sRGB)!
        let converted = CGColor(colorSpace: sRGB, components: [color.red, color.green, color.blue, 1])!
            .converted(to: CGColorSpace(name: CGColorSpace.displayP3)!, intent: .defaultIntent, options: nil)!
        return SettingsIconColor(red: converted.components![0], green: converted.components![1], blue: converted.components![2])
    }

    private func assertClose(_ a: SettingsIconColor, _ b: SettingsIconColor, _ message: String) {
        for (x, y) in [(a.red, b.red), (a.green, b.green), (a.blue, b.blue)] {
            XCTAssertLessThanOrEqual(abs(x - y) * 255, 2.5, message)
        }
    }
}
