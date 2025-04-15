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

// تعريف مجموعات الألوان الأساسية
enum ColorSet: String {
    // ألوان أساسية
    case background = "Background"
    case text = "Text"
    case primary = "Primary"
    case secondary = "Secondary"
    case accent = "Accent"
    
    // ألوان إضافية - يمكن إضافة المزيد حسب الحاجة
    case success = "Success"
    case warning = "Warning"
    case error = "Error"
    case border = "Border"
    case card = "Card"
    case shadow = "Shadow"
    
    // اظافية
    case C505C69 = "#C505C69"
    
    
    // قيم الألوان المحددة لكل نوع في الوضع الفاتح
    var lightModeColor: UIColor {
        switch self {
            case .background: return UIColor(hex: "#FFFFFF") ?? .white
            case .text: return UIColor(hex: "#1A1A1A") ?? .black
            case .primary: return UIColor(hex: "#3366CC") ?? .systemBlue
            case .secondary: return UIColor(hex: "#6633CC") ?? .systemIndigo
            case .accent: return UIColor(hex: "#FF3366") ?? .systemPink
            case .success: return UIColor(hex: "#4CAF50") ?? .systemGreen
            case .warning: return UIColor(hex: "#FFC107") ?? .systemYellow
            case .error: return UIColor(hex: "#F44336") ?? .systemRed
            case .border: return UIColor(hex: "#E0E0E0") ?? .lightGray
            case .card: return UIColor(hex: "#F8F9FA") ?? .white
            case .shadow: return UIColor(hex: "#000000")?.withAlphaComponent(0.15) ?? .black.withAlphaComponent(0.15)
                
                // اظافية
            case .C505C69: return UIColor(hex: "#C505C69") ?? .systemGray2
        }
    }
    
    // قيم الألوان المحددة لكل نوع في الوضع المظلم

    var darkModeColor: UIColor {
        switch self {
            case .background: return UIColor(hex: "#121212") ?? .black
            case .text: return UIColor(hex: "#FAFAFA") ?? .white
            case .primary: return UIColor(hex: "#4488FF") ?? .systemBlue
            case .secondary: return UIColor(hex: "#8855FF") ?? .systemIndigo
            case .accent: return UIColor(hex: "#FF5588") ?? .systemPink
            case .success: return UIColor(hex: "#66BB6A") ?? .systemGreen
            case .warning: return UIColor(hex: "#FFCA28") ?? .systemYellow
            case .error: return UIColor(hex: "#EF5350") ?? .systemRed
            case .border: return UIColor(hex: "#333333") ?? .darkGray
            case .card: return UIColor(hex: "#1E1E1E") ?? .darkGray
            case .shadow: return UIColor(hex: "#000000")?.withAlphaComponent(0.3) ?? .black.withAlphaComponent(0.3)
            
                // اظافية
            case .C505C69: return UIColor(hex: "#C505C69") ?? .systemGray2
        }
    }
    

}

