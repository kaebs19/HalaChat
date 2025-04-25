//
//  SceneDelegate.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 08/04/2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // إنشاء نافذة جديدة مرتبطة بمشهد النافذة
        window = UIWindow(windowScene: windowScene)
        
        // تطبيق السمة قبل تعيين الواجهة الرئيسية
        ThemeManager.shared.applyCurrentTheme()
        
        // تعيين الواجهة المناسبة كواجهة جذر للتطبيق باستخدام مدير التنقل
        let initialViewController = AppNavigationManager.shared.determineInitialViewController()
        window?.rootViewController = initialViewController
        
        // جعل النافذة مرئية وجعلها النافذة الرئيسية
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        
        // يتم استدعاء هذا عندما يصبح المشهد نشطًا
        ThemeManager.shared.applyCurrentTheme()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    

    // تطبيق وضع العرض (داكن/فاتح) حسب تفضيل المستخدم


}

