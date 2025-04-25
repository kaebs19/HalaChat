import UIKit

/// فئة مدير الخطوط

class FontManager {
    
    static let shared = FontManager()
    
    private init() {}
    
    /// دالة الحصول على الخط المطلوب

    func font(family: Fonts , style: FontStyle , size: Sizes) -> UIFont {
        
        let fontName = "\(family.name)-\(style.rawValue)"
        
        // في حالة وُجد الخط المطلوب يتم استخدامه، وإلا يتم استخدام الخط الافتراضي
        
        if let font = UIFont(name: fontName, size: size.rawValue) {
            return font
        } else {
            print("⚠️ الخط \(fontName) غير متوفر! تم استخدام الخط الافتراضي بدلاً عنه.")
            return UIFont.systemFont(ofSize: size.rawValue, weight: style.uiFontWeight)
        }
    }
    
    // التحقق من توفر جميع الخطوط المسجلة
    func printAvailableFonts() {
        print("--- الخطوط المتوفرة في النظام ---")
        for family in UIFont.familyNames.sorted() {
            print("عائلة الخط: \(family)")
            for name in UIFont.fontNames(forFamilyName: family) {
                print("   - \(name)")
            }
        }
    }

    // التحقق من حالة خط معين
    func checkFontAvailability(family: Fonts , style: FontStyle) -> Bool {
        let fontName = "\(family.name) - \(style.rawValue)"
        return UIFont(name: fontName, size: Sizes.size_10.rawValue) != nil
    }
    
    //دالة لاختيار عائلة الخط حسب اللغة
    func fontForCurrentLanguage(style: FontStyle, size: Sizes) -> UIFont {
        let currentLanguage = Locale.current.languageCode ?? "en"
        let family: Fonts
        
        switch currentLanguage {
        case "ar":
            family = .cairo // أو arbFONTS_Hacen مثلاً
        default:
            family = .poppins
        }
        
        return font(family: family, style: style, size: size)
    }

}
