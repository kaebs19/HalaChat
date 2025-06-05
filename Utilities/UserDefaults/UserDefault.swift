import UIKit

class UserDefault: NSObject {
    
    static let shared = UserDefault()
    private override init() {}
    
    let defaults = UserDefaults.standard
    
    // MARK: - Keys (مُصحح)
    private enum Keys {
        static let isLoggedIn = "isLoggedIn"
        static let inOnboarding = "inOnboarding"
        static let isFullVersionPurchased = "isFullVersionPurchased"
        static let removeAdsPurchased = "removeAdsPurchased"
        static let isThemeDarkLightMode = "isThemeDarkLightMode"
        static let isLanguageEnglish = "isLanguageEnglish"
        static let selectedLanguage = "selected_app_language"
        static let appThemeMode = "app_theme_mode"
        
    }
    
    // MARK: - Properties (مُحسن مع synchronize)
    var isLoggedIn: Bool {
        get { defaults.bool(forKey: Keys.isLoggedIn) }
        set {
            defaults.set(newValue, forKey: Keys.isLoggedIn)
            defaults.synchronize()
        }
    }
    
    var isOnboarding: Bool {
        get { defaults.bool(forKey: Keys.inOnboarding) }
        set {
            defaults.set(newValue, forKey: Keys.inOnboarding)
            defaults.synchronize()
        }
    }
    
    var isFullVersionPurchased: Bool {
        get { defaults.bool(forKey: Keys.isFullVersionPurchased) }
        set {
            defaults.set(newValue, forKey: Keys.isFullVersionPurchased)
            defaults.synchronize()
        }
    }
    
    var isRemoveAdsPurchased: Bool {
        get { defaults.bool(forKey: Keys.removeAdsPurchased) }
        set {
            defaults.set(newValue, forKey: Keys.removeAdsPurchased)
            defaults.synchronize()
        }
    }
    
    var isThemeDarkLightMode: Bool {
        get { defaults.bool(forKey: Keys.isThemeDarkLightMode) }
        set {
            defaults.set(newValue, forKey: Keys.isThemeDarkLightMode)
            defaults.synchronize()
        }
    }
    
    var isLanguageEnglish: Bool {
        get { defaults.bool(forKey: Keys.isLanguageEnglish) }
        set {
            defaults.set(newValue, forKey: Keys.isLanguageEnglish)
            defaults.synchronize()
        }
    }
    
    // MARK: - Enhanced Language Support
    var selectedLanguageCode: String {
        get { defaults.string(forKey: Keys.selectedLanguage) ?? "ar" }
        set {
            defaults.set(newValue, forKey: Keys.selectedLanguage)
            isLanguageEnglish = (newValue == "en")
            defaults.synchronize()
        }
    }
    
    var selectedLanguage: Language {
        get {
            let code = selectedLanguageCode
            return Language.all.first { $0.code == code } ?? Language.arabic
        }
        set {
            selectedLanguageCode = newValue.code
        }
    }
    
    // MARK: - Theme Support
    var themeModeRawValue: Int {
        get { defaults.integer(forKey: Keys.appThemeMode) }
        set {
            defaults.set(newValue, forKey: Keys.appThemeMode)
            if let themeMode = ThemeManager.ThemeMode(rawValue: newValue) {
                isThemeDarkLightMode = themeMode == .dark
            }
            defaults.synchronize()
        }
    }
    
    // MARK: - Generic Methods
    func setValue<T>(_ value: T, forKey key: String) {
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }
    
    func getValue<T>(forKey key: String, defaultValue: T) -> T {
        return defaults.object(forKey: key) as? T ?? defaultValue
    }
    
    // MARK: - Reset Methods
    func resetAllSettings() {
        guard let domain = Bundle.main.bundleIdentifier else { return }
        defaults.removePersistentDomain(forName: domain)
        defaults.synchronize()
    }
    
    func resetLanguageSettings() {
        defaults.removeObject(forKey: Keys.selectedLanguage)
        defaults.removeObject(forKey: Keys.isLanguageEnglish)
        defaults.synchronize()
    }
    
    /// حفظ آمن للإعدادات
    func saveAllSettings() {
        UserDefaults.standard.synchronize()
    }
    /// استعادة الإعدادات الافتراضية
    func resetToDefaults() {
        isOnboarding = false
        isLoggedIn = false
        isLanguageEnglish = false
        saveAllSettings()
    }
    
    /// طباعة حالة الإعدادات للتشخيص
    func printCurrentState() {
        print("=== UserDefault State ===")
        print("isOnboarding: \(isOnboarding)")
        print("isLoggedIn: \(isLoggedIn)")
        print("isLanguageEnglish: \(isLanguageEnglish)")
        print("========================")
    }
    
    
    // MARK: - Store Data Method (مُحسن)
    func storeData(key: String, value: Any) -> Any {
        switch key {
        case Keys.isLoggedIn:
            return isLoggedIn
        case Keys.inOnboarding:
            return isOnboarding
        case Keys.isFullVersionPurchased:
            return isFullVersionPurchased
        case Keys.removeAdsPurchased:
            return isRemoveAdsPurchased
        case Keys.isThemeDarkLightMode:
            return isThemeDarkLightMode
        case Keys.isLanguageEnglish:
            return isLanguageEnglish
        default:
            return value
        }
    }
}
