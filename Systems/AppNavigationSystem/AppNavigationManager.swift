//
//  AppNavigationManager.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 15/04/2025.
//

import UIKit

// MARK: - مدير التنقل بين واجهات التطبيق
// مسؤول عن التعامل مع منطق الانتقال بين الواجهات وتحديد الواجهة المناسبة عند بدء التطبيق

class AppNavigationManager {
    
    // نمط للوصول الموحد للكائن
    static let shared = AppNavigationManager()
    
    // مُنشئ خاص لمنع إنشاء نسخ متعددة
    private init() {}
    
    
    // MARK: - خصائص مساعدة
    
    private var appWindow: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    // الحصول على أول مشهد
    private var firstScene: UIWindowScene? {
        return UIApplication.shared.connectedScenes.first as? UIWindowScene
    }
    
    // الحصول على أول نافذة من المشهد
    private var sceneWindow: UIWindow? {
        guard let windowScene = firstScene else { return nil }
        return windowScene.windows.first
    }
    
    // الحصول على نافذة التطبيق الحالية (بطريقة متوافقة مع iOS 13+)
    private var window: UIWindow? {
        if #available(iOS 13.0, *) {
            return sceneWindow
        } else {
            return appWindow
        }
    }
    
    // MARK: - وظائف التحقق والتنقل
    /// تحديد الواجهة الأولية بناءً على حالة المستخدم
    /// - Returns: وحدة تحكم العرض الجذر المناسبة
    func determineInitialViewController() -> UIViewController {
        
        // إذا لم يشاهد المستخدم واجهة التعريف (Onboarding) من قبل
        if !UserDefault.shared.isOnboarding {
            return createOnboardingViewController()
            
        } else if !UserDefault.shared.isLoggedIn {
            
            // إذا لم يسجل المستخدم الدخول بعد
            return createWelcomeViewController()
            
        } else {
            // المستخدم مسجل دخوله بالفعل، انتقل إلى الواجهة الرئيسية
            return createMainAppController()
        }
    }
    
    /// تعيين جذر التطبيق إلى وحدة تحكم معينة
    /// - Parameter viewController: وحدة التحكم المراد جعلها الجذر
    func setRootViewController(_ viewController: UIViewController, animated: Bool = true) {
        
        guard let window = self.window else {
            print("خطأ: لا يمكن الوصول إلى نافذة التطبيق")
            return
        }
        
        if animated {
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                window.rootViewController = viewController
            } , completion: nil)
        } else {
            window.rootViewController = viewController
        }
    }
    
    /// تطبيق الواجهة المناسبة بناءً على حالة المستخدم الحالية
    func applyAppropriateInterface(animated: Bool = true) {
        let initialViewController = determineInitialViewController()
        setRootViewController(initialViewController, animated: animated)
    }
    
    // MARK: - إنشاء وحدات تحكم مختلفة
    /// إنشاء وحدة تحكم واجهة التعريف (Onboarding)
    /// - Returns: وحدة تحكم واجهة التعريف
    private func createOnboardingViewController() -> UIViewController {
        let storyboard = UIStoryboard(name: Storyboards.Onboarding.rawValue, bundle: nil)
        let onboardingVC = storyboard.instantiateViewController(withIdentifier: Identifiers.OnboardingVC.rawValue)
        return UINavigationController(rootViewController: onboardingVC)
    }
    
    /// إنشاء وحدة تحكم تسجيل الدخول
    /// - Returns: وحدة تحكم تسجيل الدخول
    private func createWelcomeViewController() -> UIViewController {
        let storyboard = UIStoryboard(name: Storyboards.Welcome.rawValue, bundle: nil)
        let welcomeVC = storyboard.instantiateViewController(withIdentifier: Identifiers.WelcomeVC.rawValue)
        return UINavigationController(rootViewController: welcomeVC)
    }
    
    /// إنشاء وحدة تحكم التطبيق الرئيسية
    /// - Returns: وحدة تحكم التطبيق الرئيسية
    func createMainAppController() -> UIViewController {
        let storyboard = UIStoryboard(name: Storyboards.Main.rawValue, bundle: nil)
        let mainAppVC = storyboard.instantiateViewController(withIdentifier: Identifiers.HomeVC.rawValue)
        return UINavigationController(rootViewController: mainAppVC)
    }
    
    
    /// MARK: - وظائف انتقال محددة
    func moveFromOnboardingToWelcome() {
        // تحديث UserDefaults ليعرف أن المستخدم قد شاهد Onboarding
        UserDefault.shared.isOnboarding = true
        // إنشاء وحدة تحكم Welcome
        let welcomeVC = createWelcomeViewController()
        // تعيين وحدة التحكم كجذر
        setRootViewController(welcomeVC)
    }
    
    /// الانتقال من تسجيل الدخول إلى التطبيق الرئيسي بعد تسجيل دخول ناجح
    func moveFromWelcomeToMainApp() {
        UserDefault.shared.isLoggedIn = true
        let mainAppVC = createMainAppController()
        setRootViewController(mainAppVC)
    }
    
    /// تسجيل الخروج من التطبيق
    func logout() {
        UserDefault.shared.isLoggedIn = false
        let loginVC = createWelcomeViewController()
        setRootViewController(loginVC)
    }
} 
