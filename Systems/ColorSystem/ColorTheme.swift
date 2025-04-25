import UIKit

enum AppTheme {
    case automatic // يتبع إعدادات الجهاز
    case light   // فرض الوضع العادي
    case dark  // فرض الوضع المظلم
    
    var userInterfaceStyle: UIUserInterfaceStyle {
        switch self {
            case .automatic:return .unspecified
                
            case .light: return .light
                
            case .dark: return .dark
        }
    }
}


enum ColorTheme {
    case light
    case dark
    
    static var current: ColorTheme {
        return UITraitCollection.current.userInterfaceStyle == .dark ? .dark: .light
    }
    
    static func setTheme(_ theme: ColorTheme) {
        guard let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else {
            return
        }
            
        windowScene.windows.forEach { window in
            window.overrideUserInterfaceStyle = theme == .dark ? .dark : .light
        }
    }
}

