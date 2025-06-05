//
//  AppNavigationManager.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 15/04/2025.
//

import UIKit
import MOLH

// MARK: - مدير التنقل بين واجهات التطبيق
// مسؤول عن التعامل مع منطق الانتقال بين الواجهات وتحديد الواجهة المناسبة عند بدء التطبيق

class AppNavigationManager {
    
    static let shared = AppNavigationManager()
    private init() {}
    
    // MARK: - Window Access
    private var window: UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .first { $0.activationState == .foregroundActive }
                .flatMap { $0 as? UIWindowScene }?.windows
                .first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
    
    // MARK: - Core Navigation
    func determineInitialViewController() -> UIViewController {
        if !UserDefault.shared.isOnboarding {
            return createOnboardingViewController()
        } else if !UserDefault.shared.isLoggedIn {
            return createWelcomeViewController()
        } else {
            return createMainAppController()
        }
    }
    
    func setRootViewController(_ viewController: UIViewController, animated: Bool = true) {
        guard let window = self.window else { return }
        
        if animated {
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                window.rootViewController = viewController
            }, completion: nil)
        } else {
            window.rootViewController = viewController
        }
    }
    
    // MARK: - View Controller Creation
    private func createOnboardingViewController() -> UIViewController {
        let storyboard = UIStoryboard(name: Storyboards.Onboarding.rawValue, bundle: nil)
        let onboardingVC = storyboard.instantiateViewController(withIdentifier: Identifiers.OnboardingVC.rawValue)
        return UINavigationController(rootViewController: onboardingVC)
    }
    
    private func createWelcomeViewController() -> UIViewController {
        let storyboard = UIStoryboard(name: Storyboards.Welcome.rawValue, bundle: nil)
        let welcomeVC = storyboard.instantiateViewController(withIdentifier: Identifiers.WelcomeVC.rawValue)
        return UINavigationController(rootViewController: welcomeVC)
    }
    
    func createMainAppController() -> UIViewController {
        let storyboard = UIStoryboard(name: Storyboards.Main.rawValue, bundle: nil)
        let mainAppVC = storyboard.instantiateViewController(withIdentifier: Identifiers.HomeVC.rawValue)
        return UINavigationController(rootViewController: mainAppVC)
    }
    
    // MARK: - Navigation Actions
    func moveFromOnboardingToWelcome() {
        UserDefault.shared.isOnboarding = true
        let welcomeVC = createWelcomeViewController()
        setRootViewController(welcomeVC)
    }
    
    func moveFromWelcomeToMainApp() {
        UserDefault.shared.isLoggedIn = true
        let mainAppVC = createMainAppController()
        setRootViewController(mainAppVC)
    }
    
    func logout() {
        UserDefault.shared.isLoggedIn = false
        let loginVC = createWelcomeViewController()
        setRootViewController(loginVC)
    }
}


extension AppNavigationManager {
    
    /// إعادة تشغيل التطبيق بطريقة أكثر فعالية
    func forceRestartApp() {
        guard let window = self.window else { return }
        
        // حفظ جميع البيانات المعلقة
        UserDefaults.standard.synchronize()
        
        // إنشاء واجهة جديدة تماماً
        let newWindow = UIWindow(frame: window.frame)
        newWindow.windowScene = window.windowScene
        
        // تطبيق اللغة والسمة
        let savedLanguage = LanguageManager.shared.currentLanguage
        MOLH.setLanguageTo(savedLanguage.code)
        ThemeManager.shared.applyCurrentTheme()
        
        // تحديد الواجهة الجديدة
        let initialViewController = self.determineInitialViewController()
        newWindow.rootViewController = initialViewController
        
        // استبدال النافذة القديمة
        newWindow.makeKeyAndVisible()
        
        // إزالة النافذة القديمة بعد تأخير
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            window.isHidden = true
        }
    }
    
    
    
}


extension AppNavigationManager {
    
    /// إعادة تشغيل بسيط وآمن
    func simpleRestart() {
        guard let window = self.window else { return }
        
        // تطبيق اللغة
        let savedLanguage = LanguageManager.shared.currentLanguage
        MOLH.setLanguageTo(savedLanguage.code)
        
        // تطبيق السمة
        ThemeManager.shared.applyCurrentTheme()
        
        // إنشاء الواجهة الجديدة
        let initialViewController = self.determineInitialViewController()
        
        // تطبيق الانتقال
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
            window.rootViewController = initialViewController
        }, completion: nil)
    }
}


