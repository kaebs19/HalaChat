//
//  Extension+SceneDelegate.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 28/05/2025.
//

import UIKit

extension SceneDelegate {
    
    // تطبيق وضع العرض (داكن/فاتح) حسب تفضيل المستخدم
    func applyThemeMode() {
        // استخدام ThemeManager بدلاً من تعيين الوضع مباشرة
        ThemeManager.shared.applyCurrentTheme()
        
        // ✨ NEW: إضافة مراقب للتغييرات
        
        NotificationCenter.default.addObserver(forName: .themeChangedNotification,
                                               object: nil,
                                               queue: .main) { [weak self] notification in
            self?.handleThemeChange(notification)
        }
    }
    
    // ✨ NEW: معالج تغيير المظهر مع تأثيرات
    private func handleThemeChange(_ notification: Notification) {
        guard let window = window else { return }
        
        // تطبيق المظهر مع تأثير انتقالي
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.overrideUserInterfaceStyle = ThemeManager.shared.currentThemeMode.userInterfaceStyle
        })
        
        // إرسال إشعار إضافي للتوافق
        NotificationCenter.default.post(name: .themeChangedNotification,
                                        object: notification.object)
    }
}
