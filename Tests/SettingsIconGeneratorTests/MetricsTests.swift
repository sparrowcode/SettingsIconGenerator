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
        guard case let .dodge(dodge, white) = background.fallback else { return XCTFail() }
        for measured in background.palette where measured.bottom != .init((0, 0, 0)) {
            let top = measured.bottom.dodged(dodge, white: white)
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
            XCTAssertTrue(palette.contains { $0.source.isClose(to: resolved) }, "\(color) → \(resolved)")
        }
    }
    #endif
}
