
import UIKit

/// فئة للتعامل مع الصور مع مراعاة السمة الحالية
class ThemeImage {
    
    static func image( name imageName: String ) -> UIImage? {
        return UIImage(named: imageName)
    }
    
    static func image(for appImage: AppImage) -> UIImage? {
        return appImage.image
    }
    
    static func tintedImage(for appImage: AppImage, with colorSet: AppColors) -> UIImage? {
        return appImage.tintedImage(with: colorSet)
    }
    
}

