
import UIKit

// تعريف مجموعات الألوان الأساسية
enum AppColors: String, CaseIterable {
    // ألوان أساسية
    case background = "Background"
    case text = "Text"
    case primary = "Primary"
    case secondary = "Secondary"
    case accent = "Accent"
    case textSecond = "TextSecond"
    case onlyWhite = "OnlyWhite"
    case onlyBlack = "OnlyBlack"
    case placeholderColor = "PlaceholderColor"
    case ashBlue = "AshBlue"
    
    // ألوان إضافية
    case success = "Success"
    case warning = "Warning"
    case error = "Error"
    case border = "Border"
    case card = "Card"
    case shadow = "Shadow"
    
    // إضافات من النظام الحالي
    case mainBackground = "MainBackground"
    case textColor = "TextColor"
    case buttonText = "ButtonText"
    case inputBackground = "InputBackground"
    case inputText = "InputText"
    case cardBackground = "CardBackground"
    case secondBackground = "SecondBackground"
    case tabBar = "TabBar"
    case navigationBar = "NavigationBar"
    case separator = "Separator"
    case clear = "Clear"
    
    /// الحصول على لون UIColor من ملف الألوان
    var color: UIColor {
        if self == .clear {
            return UIColor.clear
        }
        
        // محاولة الحصول على اللون من ملف الألوان
        if let color = UIColor(named: self.rawValue) {
            return color
        }
        
        // لون افتراضي في حالة عدم وجود اللون
        print("⚠️ اللون \(self.rawValue) غير موجود في ملف الألوان")
        return .lightGray
    }
    
    /// الحصول على لون UIColor مع تحديد الوضع
    func color(for theme: ThemeManager.ThemeMode) -> UIColor {
        switch theme {
            case .auto:
                return color
            case .light:
                return lightModeColor
            case .dark:
                return darkModeColor
        }
    }
    
    /// الحصول على لون الوضع الفاتح مباشرة
    var lightModeColor: UIColor {
        if self == .clear {
            return .clear
        }
        
        // استخدام UITraitCollection لفرض الوضع الفاتح
        let lightTraitCollection = UITraitCollection(userInterfaceStyle: .light)
        
        if let color = UIColor(named: self.rawValue, in: nil, compatibleWith: lightTraitCollection) {
            return color
        }
        
        print("⚠️ اللون الفاتح \(self.rawValue) غير موجود في ملف الألوان")
        return .lightGray
    }
    
    /// الحصول على لون الوضع الداكن مباشرة
    var darkModeColor: UIColor {
        if self == .clear {
            return .clear
        }
        
        // استخدام UITraitCollection لفرض الوضع الداكن
        let darkTraitCollection = UITraitCollection(userInterfaceStyle: .dark)
        
        if let color = UIColor(named: self.rawValue, in: nil, compatibleWith: darkTraitCollection) {
            return color
        }
        
        print("⚠️ اللون الداكن \(self.rawValue) غير موجود في ملف الألوان")
        return .darkGray
    }
    
    /// الحصول على لون من هيكس (لإستخدامه في الاختبارات أو التنفيذ المؤقت)
    static func hex(_ hexString: String, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor.color(fromHex: hexString, alpha: alpha)
    }
}
