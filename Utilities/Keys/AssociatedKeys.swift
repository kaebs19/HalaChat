import UIKit
import ObjectiveC

/// مفاتيح للخصائص المرتبطة
struct AssociatedKeys {
    static var themeObserver = "themeObserver"
    static var backgroundThemeObserver = "backgroundThemeObserver"
    static var textColorThemeObserver = "textColorThemeObserver"
    static var placeholderThemeObserver = "placeholderThemeObserver"
    static var borderThemeObserver = "borderThemeObserver"
    static var shadowThemeObserver = "shadowThemeObserver"
    static var tintColorThemeObserver = "tintColorThemeObserver"
    static var originalPlaceholder = "originalPlaceholder"
    static var placeholderColor = "placeholderColor"
}

/// امتداد لكائنات النظام يوفر طرق لتخزين واسترجاع خصائص مخصصة
extension NSObject {
    
    /// تخزين مراقب سمة مع الكائن
    func setThemeObserver(id: UUID, forKey key: UnsafeRawPointer) {
        objc_setAssociatedObject(
            self,
            key,
            id,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
    }
    
    /// استرجاع معرف مراقب السمة من الكائن
    func getThemeObserver(forKey key: UnsafeRawPointer) -> UUID? {
        return objc_getAssociatedObject(self, key) as? UUID
    }
    
    /// إزالة مراقب السمة من الكائن وإلغاء التسجيل من مدير السمات
    func removeThemeObserver(forKey key: UnsafeRawPointer) {
        if let observerId = getThemeObserver(forKey: key) {
            ThemeManager.shared.removeThemeObserver(id: observerId)
            
            objc_setAssociatedObject(
                self,
                key,
                nil,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
}

