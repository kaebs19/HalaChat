import UIKit

class ThemeManager {
    
    static let shared = ThemeManager()
    
    /// إشعار عند تغيير الثيم
    static let themeChangedNotification = Notification.Name.themeChangedNotification
    
    // MARK: - ✅ ThemeMode enum
    enum ThemeMode: Int, CaseIterable {
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
        
        var appTheme: AppTheme {
            switch self {
            case .auto: return .automatic
            case .light: return .light
            case .dark: return .dark
            }
        }
        
        static func from(_ appTheme: AppTheme) -> ThemeMode {
            switch appTheme {
            case .automatic: return .auto
            case .light: return .light
            case .dark: return .dark
            }
        }
        
        var displayName: String {
            return appTheme.displayName
        }
        
        var icon: UIImage? {
            switch self {
            case .auto: return UIImage(systemName: "circle.lefthalf.filled")
            case .light: return UIImage(systemName: "sun.max")
            case .dark: return UIImage(systemName: "moon")
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
    
    // MARK: - ✅ Current Theme Properties
    var currentThemeMode: ThemeMode {
        get {
            let storedValue = UserDefaults.standard.integer(forKey: "app_theme_mode")
            return ThemeMode(rawValue: storedValue) ?? .auto
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "app_theme_mode")
            applyThemeToApplication()
            notifyObservers()
            NotificationCenter.default.post(name: ThemeManager.themeChangedNotification, object: newValue)
        }
    }
    
    var currentTheme: ThemeMode {
        return currentThemeMode
    }
    
    var currentAppTheme: AppTheme {
        return currentThemeMode.appTheme
    }
    
    var isLightModeActive: Bool {
        return !isDarkModeActive
    }
    
    /// هل الوضع الداكن نشط حاليًا؟
    var isDarkModeActive: Bool {
        if currentThemeMode == .auto {
            return UITraitCollection.current.userInterfaceStyle == .dark
        }
        return currentThemeMode == .dark
    }
    
    // MARK: - ✅ Theme Application Methods
    
    /// تطبيق وضع الثيم على التطبيق
    func applyThemeToApplication() {
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.windows.forEach { window in
                    window.overrideUserInterfaceStyle = self.currentThemeMode.userInterfaceStyle
                }
            }
            
            // تحديث ColorTheme للتوافق
            self.updateColorTheme()
            
            NotificationCenter.default.post(name: .themeChangedNotification, object: self.currentThemeMode)
        }
    }
    
    // تحديث ColorTheme
    private func updateColorTheme() {
        let colorTheme: ColorTheme = isDarkModeActive ? .dark : .light
        // يمكن إضافة المزيد من الإجراءات هنا حسب الحاجة
    }
    
    /// تطبيق الثيم الحالي (للاستدعاء عند بدء التطبيق)
    func applyCurrentTheme() {
        applyThemeToApplication()
    }
    
    // MARK: - ✅ Theme Setting Methods
    
    /// تعيين المظهر باستخدام ThemeMode
    func setTheme(_ theme: ThemeMode) {
        currentThemeMode = theme
    }
    
    /// تعيين المظهر باستخدام AppTheme
    func setTheme(_ theme: AppTheme) {
        currentThemeMode = ThemeMode.from(theme)
    }
    
    /// تعيين المظهر باستخدام ColorTheme
    func setTheme(_ theme: ColorTheme) {
        switch theme {
        case .light: currentThemeMode = .light
        case .dark: currentThemeMode = .dark
        }
    }
    
    /// تعيين المظهر باستخدام Int
    func setTheme(_ rawValue: Int) {
        if let theme = ThemeMode(rawValue: rawValue) {
            currentThemeMode = theme
        }
    }
    
    // MARK: - ✅ System Event Handling
    
    /// استدعاء عند تغيير وضع الواجهة
    @objc private func userInterfaceStyleDidChange() {
        if currentThemeMode == .auto {
            notifyObservers()
            NotificationCenter.default.post(name: ThemeManager.themeChangedNotification, object: currentThemeMode)
        }
    }
    
    // MARK: - ✅ Color Management (مُصحح)
    
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
    
    /// ألوان مخصصة
    func customColor(light: UIColor, dark: UIColor) -> UIColor {
        return UIColor { traitCollection in
            switch self.currentThemeMode {
            case .auto:
                return traitCollection.userInterfaceStyle == .dark ? dark : light
            case .light:
                return light
            case .dark:
                return dark
            }
        }
    }
    
    // MARK: - ✅ Observer Management
    
    /// التسجيل كمراقب للتغييرات في السمة
    @discardableResult
    func addThemeObserver(observer: @escaping () -> Void) -> UUID {
        let id = UUID()
        themeObservers[id] = observer
        return id
    }
    
    /// إلغاء تسجيل مراقب
    func removeThemeObserver(id: UUID) {
        themeObservers.removeValue(forKey: id)
    }
    
    /// إشعار جميع المراقبين بتغيير السمة
    private func notifyObservers() {
        DispatchQueue.main.async {
            for observer in self.themeObservers.values {
                observer()
            }
        }
    }
    
    // MARK: - ✅ Utility Methods
    
    /// تبديل بين الوضع الفاتح والداكن
    func toggleThemeMode() {
        currentThemeMode = isDarkModeActive ? .light : .dark
    }
    
    /// دورة عبر جميع الأوضاع
    func cycleThemeMode() {
        let allModes = ThemeMode.allCases
        if let currentIndex = allModes.firstIndex(of: currentThemeMode) {
            let nextIndex = (currentIndex + 1) % allModes.count
            currentThemeMode = allModes[nextIndex]
        }
    }
    
    /// إعادة تعيين للوضع الافتراضي
    func resetToDefault() {
        currentThemeMode = .auto
    }
    
    /// معلومات المظهر
    var themeInfo: [String: Any] {
        return [
            "mode": currentThemeMode.rawValue,
            "modeName": currentThemeMode.displayName,
            "isDark": isDarkModeActive,
            "isLight": isLightModeActive,
            "isAuto": currentThemeMode == .auto
        ]
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        themeObservers.removeAll()
    }
    
    
}


