
//
//  AppDelegate+ThemeConfiguration.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 08/04/2025.
//  Global Theme System Configuration
//

import UIKit

//
//  AppDelegate+ThemeConfiguration.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 08/04/2025.
//  Global Theme System Configuration
//

import UIKit

extension AppDelegate {
    /// إعداد النظام العالمي للسمة
    func configureGlobalThemeSystem() {
        // تفعيل النظام العالمي للسمة الفوري
        UIViewController.enableGlobalInstantThemeSystem()
        
        // تطبيق السمة الحالية
        ThemeManager.shared.applyCurrentTheme()
        
        // إعداد مراقب عالمي للتغييرات
        setupGlobalThemeObserver()
        
        // تكوين UIAppearance proxies
        configureAppearanceProxies()
    }
    
    private func setupGlobalThemeObserver() {
        // مراقبة عالمية للتغييرات في السمة
        NotificationCenter.default.addObserver(
            forName: ThemeManager.themeChangedNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            self?.handleGlobalThemeChange(notification)
        }
    }
    
    private func handleGlobalThemeChange(_ notification: Notification) {
        // يمكن إضافة أي إجراءات عالمية عند تغيير السمة
        print("🎨 تم تغيير السمة عالمياً")
        
        // تحديث Status Bar للنوافذ الجذرية
        updateStatusBarForAllWindows()
    }
    
    private func updateStatusBarForAllWindows() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.forEach { window in
                window.rootViewController?.setNeedsStatusBarAppearanceUpdate()
            }
        }
    }
    
    private func configureAppearanceProxies() {
        // إعداد UIAppearance proxies للعناصر العامة
        
        // Navigation Bar
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.isTranslucent = false
        
        // Tab Bar
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.isTranslucent = false
        
        // Search Bar
        let searchBarAppearance = UISearchBar.appearance()
        searchBarAppearance.searchBarStyle = .minimal
        
        // Table View
        let tableViewAppearance = UITableView.appearance()
        tableViewAppearance.separatorStyle = .singleLine
        
        // Refresh Control
        let refreshControlAppearance = UIRefreshControl.appearance()
        refreshControlAppearance.tintColor = ThemeManager.shared.color(.primary)
    }
}
