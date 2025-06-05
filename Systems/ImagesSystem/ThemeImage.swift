
import UIKit

/// فئة للتعامل مع الصور مع مراعاة السمة الحالية

// MARK: - Theme Image Helper

class ThemeImage {
    
    /// Returns UIImage from asset name
    static func image(named name: String) -> UIImage? {
        return UIImage(named: name)
    }
    
    /// Returns UIImage from AppImage enum
    static func image(for appImage: AppImage) -> UIImage? {
        return appImage.image
    }
    
    /// Returns tinted image from AppImage with theme color
    static func tintedImage(for appImage: AppImage, with colorSet: AppColors) -> UIImage? {
        return appImage.tintedImage(with: colorSet)
    }
    
    /// Creates system symbol image with configuration
    static func systemImage(named systemName: String, pointSize: CGFloat = 17.0) -> UIImage? {
        let config = UIImage.SymbolConfiguration(pointSize: pointSize)
        return UIImage(systemName: systemName, withConfiguration: config)
    }
    
    /// Creates system symbol image with theme tint color
    static func systemImage(named systemName: String, tintColor: AppColors, pointSize: CGFloat = 17.0) -> UIImage? {
        return UIImage.themeImage(systemName: systemName, tintColor: tintColor, pointSize: pointSize)
    }
}
