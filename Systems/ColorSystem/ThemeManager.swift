import UIKit

import UIKit

/// مدير السمات المركزي
class ThemeManager {
    
    static let shared = ThemeManager()
    
    // إعدادات المستخدم للوصول إلى التفضيلات المحفوظة
    private let userDefaults = UserDefault.shared
    
    // المراقبون للتغييرات في السمة - قاموس لتخزين الدوال التي ستنفذ عند تغيير السمة
    private var themeObservers = [UUID: () -> Void]()
    
    private init() {
        // تطبيق السمة المحفوظة عند التشغيل
        applyCurrentTheme()
        
        // مراقبة تغيرات سمة النظام
        setupSystemThemeObserver()
    }
    
    /// إعداد مراقبة للتغييرات في سمة النظام
    private func setupSystemThemeObserver() {
        // يتم استدعاء هذه الدالة عندما يعود التطبيق إلى الواجهة بعد أن كان في الخلفية
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(userInterfaceStyleChanged),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
        
        // دعم تغييرات السمة أثناء تشغيل التطبيق (iOS 13+)
        if #available(iOS 13.0, *) {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(userInterfaceStyleChanged),
                name: UIScene.didActivateNotification,
                object: nil
            )
        }
    }
    
    // الوضع الحالي (مظلم أو فاتح) بناءً على إعدادات السمة
    var isDarkMode: Bool {
        switch currentTheme {
            case .automatic: return UITraitCollection.current.userInterfaceStyle == .dark
            case .light: return false
            case .dark: return true
        }
    }
    
    // السمة الحالية المحددة من قبل المستخدم
    var currentTheme: AppTheme {
        // إذا كان المستخدم قد حدد السمة المظلمة، نعيد .dark
        if userDefaults.isThemeDarkLightMode {
            return .dark
        } else {
            // إذا كان المستخدم قد حدد السمة الفاتحة أو تلقائي، نستخدم automatic
            return .automatic
        }
    }
    
    // تعيين السمة الحالية
    func setTheme(_ theme: AppTheme) {
        switch theme {
            case .dark:
                userDefaults.isThemeDarkLightMode = true
            case .automatic, .light:
                userDefaults.isThemeDarkLightMode = false
        }
        applyCurrentTheme()
    }
    
    // تطبيق السمة على التطبيق

    func applyCurrentTheme() {
        DispatchQueue.main.async {
            // طريقة 1: استخدام connected scenes
            if #available(iOS 13.0, *) {
                UIApplication.shared.connectedScenes
                    .filter { $0 is UIWindowScene }
                    .forEach { scene in
                        (scene as? UIWindowScene)?.windows.forEach { window in
                            window.overrideUserInterfaceStyle = self.currentTheme.userInterfaceStyle
                        }
                    }
            } else {
                // طريقة 2: للدعم القديم، استخدم windows من UIApplication
                UIApplication.shared.windows.forEach { window in
                    window.overrideUserInterfaceStyle = self.currentTheme.userInterfaceStyle
                }
            }
            
            // إشعار المراقبين بالتغيير
            self.notifyObservers()
        }
    }
    
    
    func toggleDarkMode() {
        let newTheme: AppTheme = isDarkMode ? .light : .dark
        setTheme(newTheme)
    }

    
    // التسجيل كمراقب للتغييرات في السمة
    @discardableResult
    func addThemeObserver(observer: @escaping () -> Void) -> UUID {
        let id = UUID()
        themeObservers[id] = observer
        return id
    }

    // إلغاء تسجيل مراقب
    func removeThemeObserver(id: UUID) {
        // تصحيح: إزالة المراقب من القاموس بدلاً من استدعاء جميع المراقبين
        themeObservers.removeValue(forKey: id)
    }
    
    // إشعار جميع المراقبين بتغيير السمة
    private func notifyObservers() {
        // استدعاء جميع دوال المراقبة المسجلة
        for observer in themeObservers.values {
            observer()
        }
    }
    
    // معالج تغيير سمة النظام
    @objc private func userInterfaceStyleChanged(_ notification: Notification? = nil) {
        if case .automatic = currentTheme {
            notifyObservers()
        }
    }
    
    // الحصول على اللون المناسب للوضع الحالي
    func color(_ colorSet: ColorSet) -> UIColor {
        isDarkMode ? colorSet.darkModeColor : colorSet.lightModeColor
    }
    
    // الحصول على اللون بشكل صريح لوضع معين
    func color(_ colorSet: ColorSet, for theme: AppTheme) -> UIColor {
        switch theme {
            case .dark: return colorSet.darkModeColor
            case .light: return colorSet.lightModeColor
            case .automatic: return isDarkMode ? colorSet.darkModeColor : colorSet.lightModeColor
        }
    }
    
    // تطبيق سمة على عنصر عرض
    func applyTheme(to view: UIView) {
        view.backgroundColor = color(.background)
        
        // تطبيق الألوان على العناصر الفرعية حسب نوعها
        for subview in view.subviews {
            if let label = subview as? UILabel {
                label.textColor = color(.text)
            } else if let button = subview as? UIButton {
                button.setTitleColor(color(.primary), for: .normal)
            } else if let textField = subview as? UITextField {
                textField.textColor = color(.text)
                textField.backgroundColor = color(.card)
            } else if let textView = subview as? UITextView {
                textView.textColor = color(.text)
                textView.backgroundColor = color(.card)
            }
            
            // تكرار للعناصر الفرعية
            applyTheme(to: subview)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
