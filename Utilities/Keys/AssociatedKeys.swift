import UIKit
import ObjectiveC

// MARK: - ✅ AssociatedKeys محدث وشامل

/// مفاتيح للخصائص المرتبطة - يدعم النظامين القديم والجديد
struct AssociatedKeys {
    
    // MARK: - 🔄 Legacy String Keys (للتوافق مع الكود الموجود)
    static var themeObserver = "themeObserver"
    static var backgroundThemeObserver = "backgroundThemeObserver"
    static var textColorThemeObserver = "textColorThemeObserver"
    static var placeholderThemeObserver = "placeholderThemeObserver"
    static var borderThemeObserver = "borderThemeObserver"
    static var shadowThemeObserver = "shadowThemeObserver"
    static var tintColorThemeObserver = "tintColorThemeObserver"
    static var originalPlaceholder = "originalPlaceholder"
    static var placeholderColor = "placeholderColor"
    static var buttonThemeObserver = "buttonThemeObserver"
    static var buttonBackgroundThemeObserver = "buttonBackgroundThemeObserver"
    
    // MARK: - 🆕 InstantTheme System Keys
    static var themeObserverKey = "InstantTheme_ObserverKey"
    static var isThemeSetupKey = "InstantTheme_SetupKey"
    static var transitionStyleKey = "InstantTheme_TransitionKey"
    
    // MARK: - ✅ New UInt8 Keys (للنظام الجديد المحسن)
    
    // Core Theme System
    static var instantThemeEnabled: UInt8 = 10
    static var themeTransitionStyle: UInt8 = 11
    static var viewThemeObserver: UInt8 = 12
    
    // Gradient System (تم نقلها من UIView+Extensions)
    // static var gradientParameters: UInt8 = 20  // ❌ موجودة في UIView+Extensions
    static var gradientLayer: UInt8 = 21
    
    // Container System (تم نقلها من UIView+Extensions)
    // static var containerParameters: UInt8 = 30  // ❌ موجودة في UIView+Extensions
    static var containerColorSet: UInt8 = 31
    
    // Label Parameters
    static var labelColorParameters: UInt8 = 40
    static var labelTextColorSet: UInt8 = 41
    static var labelBackgroundColorSet: UInt8 = 42
    
    // Button Parameters
    static var buttonColorParameters: UInt8 = 50
    static var buttonTitleColorSet: UInt8 = 51
    static var buttonBackgroundColorSet: UInt8 = 52
    static var buttonBorderColorSet: UInt8 = 53
    static var buttonShadowColorSet: UInt8 = 54
    
    // TextField Parameters
    static var textFieldColorParameters: UInt8 = 60
    static var textFieldTextColorSet: UInt8 = 61
    static var textFieldBackgroundColorSet: UInt8 = 62
    static var textFieldPlaceholderColorSet: UInt8 = 63
    static var textFieldBorderColorSet: UInt8 = 64
    
    // ImageView Parameters
    static var imageViewColorParameters: UInt8 = 70
    static var imageViewTintColorSet: UInt8 = 71
    static var imageViewBackgroundColorSet: UInt8 = 72
    
    // TableView/CollectionView Parameters
    static var tableViewColorParameters: UInt8 = 80
    static var tableViewBackgroundColorSet: UInt8 = 81
    static var tableViewSeparatorColorSet: UInt8 = 82
    static var collectionViewColorParameters: UInt8 = 83
    static var collectionViewBackgroundColorSet: UInt8 = 84
    
    // View Specific Parameters
    static var viewBackgroundColorSet: UInt8 = 90
    static var viewBorderColorSet: UInt8 = 91
    static var viewShadowColorSet: UInt8 = 92
    static var viewTintColorSet: UInt8 = 93
    
    // Animation Parameters
    static var animationParameters: UInt8 = 100
    static var transitionParameters: UInt8 = 101
    
    // Custom Component Parameters
    static var customColorParameters: UInt8 = 110
    static var customThemeParameters: UInt8 = 111
}

// MARK: - ✅ Enhanced NSObject Extensions

/// امتداد محسن لكائنات النظام يوفر طرق لتخزين واسترجاع خصائص مخصصة
extension NSObject {
    
    // MARK: - Legacy UUID System (للتوافق مع الكود الموجود)
    
    /// تخزين مراقب سمة مع الكائن (النظام القديم)
    func setThemeObserver(id: UUID, forKey key: UnsafeRawPointer) {
        objc_setAssociatedObject(
            self,
            key,
            id,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
    }
    
    /// استرجاع معرف مراقب السمة من الكائن (النظام القديم)
    func getThemeObserver(forKey key: UnsafeRawPointer) -> UUID? {
        return objc_getAssociatedObject(self, key) as? UUID
    }
    
    /// إزالة مراقب السمة من الكائن وإلغاء التسجيل من مدير السمات (النظام القديم)
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
    
    // MARK: - ✅ New Enhanced System (للنظام الجديد)
    
    /// تعيين قيمة مرتبطة بالعنصر (النظام الجديد)
    func setAssociatedValue<T>(_ value: T?, forKey key: inout UInt8) {
        objc_setAssociatedObject(self, &key, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    /// الحصول على قيمة مرتبطة بالعنصر (النظام الجديد)
    func getAssociatedValue<T>(forKey key: inout UInt8, as type: T.Type) -> T? {
        return objc_getAssociatedObject(self, &key) as? T
    }
    
    /// إزالة قيمة مرتبطة بالعنصر (النظام الجديد)
    func removeAssociatedValue(forKey key: inout UInt8) {
        objc_setAssociatedObject(self, &key, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    // MARK: - ✅ String Key Support (للمفاتيح النصية)
    
    /// تعيين قيمة باستخدام مفتاح نصي
    func setAssociatedValue<T>(_ value: T?, forStringKey key: String) {
        objc_setAssociatedObject(self, key, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    /// الحصول على قيمة باستخدام مفتاح نصي
    func getAssociatedValue<T>(forStringKey key: String, as type: T.Type) -> T? {
        return objc_getAssociatedObject(self, key) as? T
    }
    
    /// إزالة قيمة باستخدام مفتاح نصي
    func removeAssociatedValue(forStringKey key: String) {
        objc_setAssociatedObject(self, key, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    // MARK: - ✅ Migration Helpers (مساعدات الانتقال)
    
    /// إزالة جميع مراقبي السمة القديمة
    func removeAllLegacyThemeObservers() {
        // إزالة المراقبين القديمة بالمفاتيح النصية
        removeAssociatedValue(forStringKey: AssociatedKeys.themeObserver)
        removeAssociatedValue(forStringKey: AssociatedKeys.backgroundThemeObserver)
        removeAssociatedValue(forStringKey: AssociatedKeys.textColorThemeObserver)
        removeAssociatedValue(forStringKey: AssociatedKeys.placeholderThemeObserver)
        removeAssociatedValue(forStringKey: AssociatedKeys.borderThemeObserver)
        removeAssociatedValue(forStringKey: AssociatedKeys.shadowThemeObserver)
        removeAssociatedValue(forStringKey: AssociatedKeys.tintColorThemeObserver)
        removeAssociatedValue(forStringKey: AssociatedKeys.buttonThemeObserver)
        removeAssociatedValue(forStringKey: AssociatedKeys.buttonBackgroundThemeObserver)
    }
    
    /// تنظيف شامل لجميع البيانات المرتبطة
    func cleanupAllAssociatedData() {
        removeAllLegacyThemeObservers()
        
        // تنظيف البيانات الجديدة
        removeAssociatedValue(forKey: &AssociatedKeys.labelColorParameters)
        removeAssociatedValue(forKey: &AssociatedKeys.buttonColorParameters)
        // removeAssociatedValue(forKey: &AssociatedKeys.gradientParameters)      // موجودة في UIView+Extensions
        // removeAssociatedValue(forKey: &AssociatedKeys.containerParameters)     // موجودة في UIView+Extensions
    }
    
    // MARK: - ✅ InstantTheme Integration
    
    /// تحقق من تفعيل النظام الجديد
    var isInstantThemeEnabled: Bool {
        get {
            return getAssociatedValue(forKey: &AssociatedKeys.instantThemeEnabled, as: Bool.self) ?? false
        }
        set {
            setAssociatedValue(newValue, forKey: &AssociatedKeys.instantThemeEnabled)
        }
    }
    
    /// نوع التأثير الانتقالي
    var themeTransitionStyle: InstantThemeTransition? {
        get {
            return getAssociatedValue(forKey: &AssociatedKeys.themeTransitionStyle, as: InstantThemeTransition.self)
        }
        set {
            setAssociatedValue(newValue, forKey: &AssociatedKeys.themeTransitionStyle)
        }
    }
}

// MARK: - ✅ Convenience Extensions for Common Use Cases

extension NSObject {
    
    /// تخزين معاملات الألوان العامة
    func saveColorParameters<T>(_ parameters: T, forKey key: inout UInt8) {
        setAssociatedValue(parameters, forKey: &key)
    }
    
    /// استرجاع معاملات الألوان العامة
    func getColorParameters<T>(forKey key: inout UInt8, as type: T.Type) -> T? {
        return getAssociatedValue(forKey: &key, as: type)
    }
    
    /// إزالة معاملات الألوان
    func removeColorParameters(forKey key: inout UInt8) {
        removeAssociatedValue(forKey: &key)
    }
}

// MARK: - ✅ Debug and Monitoring Extensions

extension NSObject {
    
    /// طباعة جميع البيانات المرتبطة لأغراض التصحيح
    func debugAssociatedData() {
        print("=== Associated Data for \(String(describing: type(of: self))) ===")
        
        // فحص النظام الجديد
        print("InstantTheme Enabled: \(isInstantThemeEnabled)")
        print("Transition Style: \(themeTransitionStyle?.rawValue ?? "none")")
        
        // فحص المعاملات المحفوظة
        if getAssociatedValue(forKey: &AssociatedKeys.labelColorParameters, as: Any.self) != nil {
            print("Label Color Parameters: Found")
        }
        
        if getAssociatedValue(forKey: &AssociatedKeys.buttonColorParameters, as: Any.self) != nil {
            print("Button Color Parameters: Found")
        }
        
        // ملاحظة: gradientParameters و containerParameters موجودة في UIView+Extensions
        print("Note: Gradient and Container parameters are managed in UIView+Extensions")
        
        print("=== End Associated Data ===")
    }
}

// MARK: - ✅ Type Definitions (إذا لم تكن موجودة)

/// أنواع التأثيرات الانتقالية للسمة
enum InstantThemeTransition: String, CaseIterable {
    case none = "none"
    case fade = "fade"
    case slide = "slide"
    case crossDissolve = "crossDissolve"
    case snapshot = "snapshot"
    case custom = "custom"
}
