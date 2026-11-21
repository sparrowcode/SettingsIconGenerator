#if !os(macOS)
import ImageIO
import SwiftUI
import UniformTypeIdentifiers
import XCTest
@testable import SettingsIconGenerator

/* Выгрузка листов с иконками для сравнения «до/после» по пикселям.
 Запускается только с переменной SNAPSHOT_DIR (в xcodebuild — TEST_RUNNER_SNAPSHOT_DIR), иначе пропускается. */
final class SnapshotExport: XCTestCase {

    static let glyphs = [
        "bell.fill", "gear", "exclamationmark.triangle.fill", "envelope.fill", "key.fill",
        "keyboard.fill", "eye.slash.fill", "iphone.radiowaves.left.and.right", "lock.fill"
    ]

    /* SwiftUI-цвета: на iOS Color.red и UIColor.systemRed — один и тот же цвет. */
    static let colors: [(String, Color)] = [
        ("red", .red), ("orange", .orange), ("yellow", .yellow), ("green", .green),
        ("teal", .teal), ("blue", .blue), ("indigo", .indigo), ("purple", .purple),
        ("pink", .pink), ("gray", .gray), ("black", .black),
        ("custom", Color(.sRGB, red: 0.2, green: 0.5, blue: 0.4))
    ]

    static let sizes: [(String, SettingsIconSize)] = [("standard", .standard), ("custom26", .custom(26))]
    static let shapes: [(String, SettingsIconShape)] = [("squircle", .squircle), ("circle", .circle)]

    private func directory() throws -> URL {
        guard let path = ProcessInfo.processInfo.environment["SNAPSHOT_DIR"] else {
            throw XCTSkip("SNAPSHOT_DIR не задан")
        }
        let url = URL(fileURLWithPath: path)
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        return url
    }

    @MainActor
    func testExportSwiftUI() throws {
        guard #available(iOS 16, watchOS 9, *) else { throw XCTSkip("ImageRenderer с iOS 16") }
        let directory = try directory()
        for (shapeName, shape) in Self.shapes {
            for (sizeName, size) in Self.sizes {
                for scheme in [ColorScheme.light, .dark] {
                    let view = VStack(spacing: 4) {
                        ForEach(Self.colors.indices, id: \.self) { row in
                            HStack(spacing: 4) {
                                ForEach(Self.glyphs, id: \.self) { glyph in
                                    SettingsIcon(systemName: glyph, backgroundColor: Color(Self.colors[row].1), shape: shape, size: size)
                                }
                            }
                        }
                    }
                    .padding(4)
                    .environment(\.colorScheme, scheme)
                    let renderer = ImageRenderer(content: view)
                    renderer.scale = 3
                    let name = "swiftui-\(shapeName)-\(sizeName)-\(scheme == .dark ? "dark" : "light").png"
                    try writePNG(renderer.cgImage!, to: directory.appendingPathComponent(name))
                }
            }
        }
    }


    private func writePNG(_ image: CGImage, to url: URL) throws {
        let destination = CGImageDestinationCreateWithURL(url as CFURL, UTType.png.identifier as CFString, 1, nil)!
        CGImageDestinationAddImage(destination, image, nil)
        XCTAssertTrue(CGImageDestinationFinalize(destination))
    }

    #if canImport(UIKit) && !os(watchOS)
    func testExportUIKit() throws {
        let directory = try directory()
        for (shapeName, shape) in Self.shapes {
            for (sizeName, size) in Self.sizes {
                for style in [UIUserInterfaceStyle.light, .dark] {
                    let traits = UITraitCollection(userInterfaceStyle: style)
                    var images: [[UIImage]] = []
                    traits.performAsCurrent {
                        images = Self.colors.map { _, color in
                            let color = UIColor(color)
                            return Self.glyphs.map { UIImage.generateSettingsIcon($0, backgroundColor: color, shape: shape, size: size) ?? UIImage() }
                        }
                    }
                    let name = "uikit-\(shapeName)-\(sizeName)-\(style == .dark ? "dark" : "light").png"
                    try sheet(images).pngData()!.write(to: directory.appendingPathComponent(name))
                }
            }
        }
    }

    private func sheet(_ rows: [[UIImage]]) -> UIImage {
        let cell = rows.flatMap { $0 }.map { max($0.size.width, $0.size.height) }.max() ?? 0
        let spacing: CGFloat = 4
        let columns = rows.map(\.count).max() ?? 0
        let size = CGSize(
            width: CGFloat(columns) * (cell + spacing) + spacing,
            height: CGFloat(rows.count) * (cell + spacing) + spacing
        )
        let format = UIGraphicsImageRendererFormat()
        format.scale = 3
        return UIGraphicsImageRenderer(size: size, format: format).image { _ in
            for (y, row) in rows.enumerated() {
                for (x, image) in row.enumerated() {
                    image.draw(at: CGPoint(x: spacing + CGFloat(x) * (cell + spacing), y: spacing + CGFloat(y) * (cell + spacing)))
                }
            }
        }
    }
    #endif
}
#endif
