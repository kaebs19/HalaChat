import UIKit

class ThemeManager {
    
    static let shared = ThemeManager()
    
    /// إشعار عند تغيير الثيم
    static let themeChangedNotification = Notification.Name.themeChangedNotification
    
    enum ThemeMode: Int {
        case auto = 0 // تلقائي (يتبع إعدادات الجهاز)
        case light = 1 // فاتح
        case dark = 2 // داكن
        
        var userInterfaceStyle: UIUserInterfaceStyle {
            switch self {
                case .auto:
                    return .unspecified
                case .light:
                    return .light
                case .dark:
                    return .dark
            }
        }
    }
    
    private var themeObservers = [UUID: () -> Void]()
    
    private init() {
        // تسجيل لمراقبة تغييرات وضع الجهاز عند العودة للتطبيق
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(userInterfaceStyleDidChange),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
        
    }

    // الوضع الحالي للثيم
    var currentThemeMode: ThemeMode {
        get {
            let storedValue = UserDefaults.standard.integer(forKey: "app_theme_mode")
            return ThemeMode(rawValue: storedValue) ?? .auto
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "app_theme_mode")
            applyThemeToApplication()
            NotificationCenter.default.post(name: ThemeManager.themeChangedNotification, object: nil)
        }
    }
    
    /// هل الوضع الداكن نشط حاليًا؟
    var isDarkModeActive: Bool {
        if currentThemeMode == .auto {
            return UITraitCollection.current.userInterfaceStyle == .dark
        }
        return currentThemeMode == .dark
    }
    
    /// تطبيق وضع الثيم على التطبيق
    func applyThemeToApplication() {
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.windows.forEach { window in
                    window.overrideUserInterfaceStyle = self.currentThemeMode.userInterfaceStyle
                }
            }
            
            NotificationCenter.default.post(name: .themeChangedNotification, object: nil)
        }
    }
    
    /// تطبيق الثيم الحالي (للاستدعاء عند بدء التطبيق)
    func applyCurrentTheme() {
        applyThemeToApplication()
    }

    
    /// استدعاء عند تغيير وضع الواجهة
    @objc private func userInterfaceStyleDidChange() {
        
        if currentThemeMode == .auto {
            notifyObservers()
            NotificationCenter.default.post(name: ThemeManager.themeChangedNotification, object: nil)
        }
    }
    
    /// الحصول على اللون المناسب للوضع الحالي
    func color(_ colorSet: AppColors) -> UIColor {
        switch currentThemeMode {
            case .auto:
                return colorSet.color
            case .light:
                return colorSet.lightModeColor
            case .dark:
                return colorSet.darkModeColor
        }
    }
    
    // التسجيل كمراقب للتغييرات في السمة
    @discardableResult
    func addThemeObserver(observer: @escaping () ->Void) -> UUID {
        let id = UUID()
        themeObservers[id] = observer
        return id
    }
    
    // إلغاء تسجيل مراقب
    func removeThemeObserver(id: UUID) {
        themeObservers.removeValue(forKey: id)
    }
    
    // إشعار جميع المراقبين بتغيير السمة
    private func notifyObservers() {
        DispatchQueue.main.async {
            for observer in self.themeObservers.values {
                observer()
            }
        }
    }
    
    // تبديل بين الوضع الفاتح والداكن
    func toggleThemeMode() {
        currentThemeMode = isDarkModeActive ? .light : .dark
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


extension SceneDelegate {
    
    // تطبيق وضع العرض (داكن/فاتح) حسب تفضيل المستخدم
    func applyThemeMode() {
        // استخدام ThemeManager بدلاً من تعيين الوضع مباشرة
        ThemeManager.shared.applyCurrentTheme()
    }
}
