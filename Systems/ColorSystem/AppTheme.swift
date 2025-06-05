import UIKit


enum AppTheme: Int, CaseIterable {
    case automatic = 0 // يتبع إعدادات الجهاز
    case light = 1   // فرض الوضع العادي
    case dark = 2  // فرض الوضع المظلم
    
    var userInterfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .automatic: return .unspecified
        case .light: return .light
        case .dark: return .dark
        }
    }
    
    var displayName: String {
        switch self {
        case .automatic:
            return isEnglish() ? "Automatic" : "تلقائي"
        case .light:
            return isEnglish() ? "Light" : "فاتح"
        case .dark:
            return isEnglish() ? "Dark" : "مظلم"
        }
    }
    
    /// تحويل إلى ThemeMode
    var themeMode: ThemeManager.ThemeMode {
        switch self {
        case .automatic: return .auto
        case .light: return .light
        case .dark: return .dark
        }
    }
}

// MARK: - ✅ ColorTheme (مُصحح)
enum ColorTheme {
    case light
    case dark
    
    static var current: ColorTheme {
        return UITraitCollection.current.userInterfaceStyle == .dark ? .dark : .light
    }
    
    /// تحويل إلى ThemeMode
    var themeMode: ThemeManager.ThemeMode {
        switch self {
        case .light: return .light
        case .dark: return .dark
        }
    }
    
    /// تحديث setTheme للعمل مع ThemeManager
    static func setTheme(_ theme: ColorTheme) {
        ThemeManager.shared.setTheme(theme)
    }
    
    /// إنشاء من ThemeMode
    static func from(_ themeMode: ThemeManager.ThemeMode) -> ColorTheme? {
        switch themeMode {
        case .light: return .light
        case .dark: return .dark
        case .auto: return nil // الوضع التلقائي لا يطابق ColorTheme
        }
    }
}

