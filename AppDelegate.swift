//
//  AppDelegate.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 08/04/2025.
//

import UIKit
import IQKeyboardManagerSwift
@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        IQKeyboardManager.shared.isEnabled = true  
        IQKeyboardManager.shared.enableAutoToolbar = true  // لإظهار الشريط أعلى الكيبورد
        IQKeyboardManager.shared.resignOnTouchOutside = true  // لإغلاق الكيبورد عند الضغط بالخارج

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    
    // تكوين مظهر التطبيق العام
    func configureAppearance() {
        // تطبيق الوضع الداكن أو الفاتح حسب تفضيل المستخدم
        applyThemeMode()
        
        // تخصيص مظهر شريط التنقل
        let navigationBarAppearance  = UINavigationBar.appearance()
        navigationBarAppearance.tintColor = .systemBlue
        navigationBarAppearance.barTintColor = .white
        
        // تخصيص مظهر العنوان في شريط التنقل
        navigationBarAppearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .medium)
        ]
    }
    
    // تطبيق وضع العرض (داكن/فاتح) بناءً على تفضيل المستخدم
   private func  applyThemeMode() {
       if #available(iOS 13.0, *) {

           let isDarkMode = UserDefault.shared.isThemeDarkLightMode

           UIApplication.shared.windows.forEach { window in

               window.overrideUserInterfaceStyle = isDarkMode ? .dark : .light

           }

       }

    }

}

