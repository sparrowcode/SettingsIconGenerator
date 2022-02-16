// The MIT License (MIT)
// Copyright © 2022 Ivan Vorobei (hello@ivanvorobei.by)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#if canImport(UIKit)
import UIKit

extension UIImage {
    
    @available(iOS 13, tvOS 13, *)
    public static func generateSettingsIcon(_ systemName: String, backgroundColor: UIColor) -> UIImage? {
        let iconConfiguration = UIImage.SymbolConfiguration(pointSize: CGFloat(iconFontSize), weight: .regular)
        let iconImage = UIImage(systemName: systemName, withConfiguration: iconConfiguration)?.withTintColor(.white, renderingMode: .alwaysOriginal)
        
        let backgroundConfiguration = UIImage.SymbolConfiguration(pointSize: CGFloat(backgroundFontSize), weight: .regular)
        let backgroundImage = UIImage(systemName: backgroundSystemName, withConfiguration: backgroundConfiguration)!.withTintColor(backgroundColor, renderingMode: .alwaysOriginal)
        
        let size = backgroundImage.size
        UIGraphicsBeginImageContextWithOptions(size, false, .zero)
        
        backgroundImage.draw(in: CGRect(origin: .zero, size: size))
        
        if let iconImage = iconImage {
            let iconSize = iconImage.size
            iconImage.draw(in: CGRect(
                origin: .init(
                    x: (size.width - iconSize.width) / 2,
                    y: (size.height - iconSize.height) / 2
                ),
                size: iconSize
            ))
        }
        
        let settingsImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return settingsImage
    }
}
#endif
