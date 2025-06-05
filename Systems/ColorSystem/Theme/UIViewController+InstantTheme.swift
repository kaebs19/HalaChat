//
//  UIViewController+InstantTheme.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 01/06/2025.
//

import UIKit
import ObjectiveC

// MARK: - TransitionStyle Definition
enum TransitionStyle {
    /// للشاشات المعقدة (TabBar, TableView, CollectionView)
    case snapshot
    
    /// للشاشات العادية
    case crossDissolve
    
    // للشاشات البسيطة
    case instant
}

// MARK: - UIViewController InstantTheme Extension
extension UIViewController: InstantThemeUpdatable {
    
    // MARK: - Associated Objects
    private var themeObserverId: UUID? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.themeObserverKey) as? UUID
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.themeObserverKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var isThemeSetup: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.isThemeSetupKey) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.isThemeSetupKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var transitionStyle: TransitionStyle {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.transitionStyleKey) as? TransitionStyle ?? .crossDissolve
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.transitionStyleKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // MARK: - Public Methods
    
    /// تفعيل نظام السمة الفوري للـ ViewController
    func enableInstantTheme(transitionStyle: TransitionStyle = .crossDissolve) {
        guard !isThemeSetup else { return }
        
        self.transitionStyle = transitionStyle
        setupThemeObserver()
        applyInstantThemeUpdate()
        isThemeSetup = true
    }
    
    /// إيقاف نظام السمة الفوري
    func disableInstantTheme() {
        removeThemeObserver()
        isThemeSetup = false
    }
    
    // MARK: - InstantThemeUpdatable Protocol Implementation
    
    @objc open func applyInstantThemeUpdate() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // تحديث الألوان الأساسية
            self.updateViewControllerTheme()
            
            // تحديث الـ Views الفرعية
            self.updateSubviewsTheme()
            
            // تحديث Navigation Bar
            self.updateNavigationBarTheme()
            
            // تحديث Tab Bar
            self.updateTabBarTheme()
            
            // تحديث Status Bar
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    @objc open func handleThemeTransition() {
        switch transitionStyle {
        case .snapshot:
            performSnapshotTransition()
        case .crossDissolve:
            performCrossDissolveTransition()
        case .instant:
            applyInstantThemeUpdate()
        }
    }
    
    @objc open func showThemeChangeNotification() {
        // يمكن تخصيص هذه الطريقة لإظهار إشعار تغيير السمة
        let isDark = ThemeManager.shared.isDarkModeActive
        let message = isDark ?
            (isEnglish() ? "Dark Mode Activated" : "تم تفعيل الوضع المظلم") :
            (isEnglish() ? "Light Mode Activated" : "تم تفعيل الوضع الفاتح")
        
        showBriefMessage(message)
    }
    
    // MARK: - Private Theme Observer Methods
    
    private func setupThemeObserver() {
        removeThemeObserver() // إزالة المراقب السابق إن وجد
        
        themeObserverId = ThemeManager.shared.addThemeObserver { [weak self] in
            self?.handleThemeChange()
        }
    }
    
    private func removeThemeObserver() {
        if let observerId = themeObserverId {
            ThemeManager.shared.removeThemeObserver(id: observerId)
            themeObserverId = nil
        }
    }
    
    private func handleThemeChange() {
        handleThemeTransition()
        showThemeChangeNotification()
    }
    
    // MARK: - Theme Update Methods
    
    private func updateViewControllerTheme() {
        // تحديث خلفية الـ ViewController
        view.backgroundColor = ThemeManager.shared.color(.background)
        
        // تحديث overrideUserInterfaceStyle
        overrideUserInterfaceStyle = ThemeManager.shared.currentThemeMode.userInterfaceStyle
    }
    
    private func updateSubviewsTheme() {
        view.subviews.forEach { subview in
            updateViewTheme(subview)
        }
    }
    
    private func updateViewTheme(_ view: UIView) {
        // تحديث الألوان بناءً على نوع الـ View
        switch view {
        case let label as UILabel:
            updateLabelTheme(label)
        case let textField as UITextField:
            updateTextFieldTheme(textField)
        case let textView as UITextView:
            updateTextViewTheme(textView)
        case let button as UIButton:
            updateButtonTheme(button)
        case let imageView as UIImageView:
            updateImageViewTheme(imageView)
        case let tableView as UITableView:
            updateTableViewTheme(tableView)
        case let collectionView as UICollectionView:
            updateCollectionViewTheme(collectionView)
        default:
            updateGenericViewTheme(view)
        }
        
        // تحديث الـ subviews
        view.subviews.forEach { subview in
            updateViewTheme(subview)
        }
    }
    
    
    private func updateLabelTheme(_ label: UILabel) {
        label.textColor = ThemeManager.shared.color(.text)
    }
    
    private func updateTextFieldTheme(_ textField: UITextField) {
        textField.textColor = ThemeManager.shared.color(.text)
        textField.backgroundColor = ThemeManager.shared.color(.invertBackground)
        textField.attributedPlaceholder = NSAttributedString(
            string: textField.placeholder ?? "",
            attributes: [.foregroundColor: ThemeManager.shared.color(.placeholder)]
        )
    }
    
    private func updateTextViewTheme(_ textView: UITextView) {
        textView.textColor = ThemeManager.shared.color(.text)
        textView.backgroundColor = ThemeManager.shared.color(.invertBackground)
    }
    
    private func updateButtonTheme(_ button: UIButton) {
        button.setTitleColor(ThemeManager.shared.color(.primary), for: .normal)
        button.backgroundColor = ThemeManager.shared.color(.mainBackground)
    }
    
    private func updateImageViewTheme(_ imageView: UIImageView) {
        imageView.tintColor = ThemeManager.shared.color(.primary)
    }
    
    private func updateTableViewTheme(_ tableView: UITableView) {
        tableView.backgroundColor = ThemeManager.shared.color(.background)
        tableView.separatorColor = ThemeManager.shared.color(.separator)
        tableView.reloadData()
    }
    
    private func updateCollectionViewTheme(_ collectionView: UICollectionView) {
        collectionView.backgroundColor = ThemeManager.shared.color(.background)
        collectionView.reloadData()
    }
    
    private func updateGenericViewTheme(_ view: UIView) {
        // تحديث الألوان العامة للـ Views الأخرى
        if view.backgroundColor != .clear {
            view.backgroundColor = ThemeManager.shared.color(.mainBackground)
        }
        view.tintColor = ThemeManager.shared.color(.primary)
    }
    
    private func updateNavigationBarTheme() {
        guard let navigationController = navigationController else { return }
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = ThemeManager.shared.color(.navigationBar)
        appearance.titleTextAttributes = [
            .foregroundColor: ThemeManager.shared.color(.text)
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: ThemeManager.shared.color(.text)
        ]
        
        navigationController.navigationBar.standardAppearance = appearance
        
        // iOS 15+ only
        if #available(iOS 15.0, *) {
            navigationController.navigationBar.scrollEdgeAppearance = appearance
        }
        
        // iOS 13+ only
        if #available(iOS 13.0, *) {
            navigationController.navigationBar.compactAppearance = appearance
        }
        
        navigationController.navigationBar.tintColor = ThemeManager.shared.color(.primary)
    }
    
    private func updateTabBarTheme() {
        guard let tabBarController = tabBarController else { return }
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = ThemeManager.shared.color(.tabBar)
        
        // تحديث ألوان العناصر
        appearance.stackedLayoutAppearance.normal.iconColor = ThemeManager.shared.color(.textSecond)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: ThemeManager.shared.color(.textSecond)
        ]
        appearance.stackedLayoutAppearance.selected.iconColor = ThemeManager.shared.color(.primary)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: ThemeManager.shared.color(.primary)
        ]
        
        tabBarController.tabBar.standardAppearance = appearance
        
        // iOS 15+ only
        if #available(iOS 15.0, *) {
            tabBarController.tabBar.scrollEdgeAppearance = appearance
        }
        
        tabBarController.tabBar.tintColor = ThemeManager.shared.color(.primary)
    }
    
    // MARK: - Transition Effects
    
    private func performSnapshotTransition() {
        guard let window = view.window else {
            applyInstantThemeUpdate()
            return
        }
        
        // إنشاء snapshot من الحالة الحالية
        let snapshotView = window.snapshotView(afterScreenUpdates: false)
        if let snapshot = snapshotView {
            window.addSubview(snapshot)
            
            // تطبيق السمة الجديدة
            applyInstantThemeUpdate()
            
            // تأثير الانتقال
            UIView.animate(withDuration: 0.3, animations: {
                snapshot.alpha = 0
            }) { _ in
                snapshot.removeFromSuperview()
            }
        } else {
            applyInstantThemeUpdate()
        }
    }
    
    private func performCrossDissolveTransition() {
        UIView.transition(with: view, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.applyInstantThemeUpdate()
        }, completion: nil)
    }
    
    // MARK: - Helper Methods
    
    private func showBriefMessage(_ message: String) {
        // عرض رسالة مؤقتة (يمكن استخدام Toast أو Alert مخصص)
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            alert.dismiss(animated: true)
        }
    }
    
    // MARK: - Lifecycle Methods
    
    /// يجب استدعاؤها في viewDidLoad
    @objc func setupInstantTheme() {
        enableInstantTheme()
    }
    
    /// يجب استدعاؤها في deinit
    @objc func cleanupInstantTheme() {
        disableInstantTheme()
    }
}

// MARK: - Global Theme System
extension UIViewController {
    
    /// تفعيل النظام العالمي للسمة الفوري
    static func enableGlobalInstantThemeSystem() {
        // Swizzling للطرق الأساسية
        swizzleViewDidLoad()
        swizzleViewWillAppear()
        swizzleDeinit()
    }
    
    private static func swizzleViewDidLoad() {
        let originalSelector = #selector(UIViewController.viewDidLoad)
        let swizzledSelector = #selector(UIViewController.swizzled_viewDidLoad)
        
        guard let originalMethod = class_getInstanceMethod(UIViewController.self, originalSelector),
              let swizzledMethod = class_getInstanceMethod(UIViewController.self, swizzledSelector) else {
            return
        }
        
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
    
    private static func swizzleViewWillAppear() {
        let originalSelector = #selector(UIViewController.viewWillAppear(_:))
        let swizzledSelector = #selector(UIViewController.swizzled_viewWillAppear(_:))
        
        guard let originalMethod = class_getInstanceMethod(UIViewController.self, originalSelector),
              let swizzledMethod = class_getInstanceMethod(UIViewController.self, swizzledSelector) else {
            return
        }
        
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
    
    private static func swizzleDeinit() {
        let originalSelector = NSSelectorFromString("dealloc")
        let swizzledSelector = #selector(UIViewController.swizzled_deinit)
        
        guard let originalMethod = class_getInstanceMethod(UIViewController.self, originalSelector),
              let swizzledMethod = class_getInstanceMethod(UIViewController.self, swizzledSelector) else {
            return
        }
        
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
    
    @objc private func swizzled_viewDidLoad() {
        swizzled_viewDidLoad() // استدعاء الطريقة الأصلية
        
        // تطبيق السمة تلقائياً لجميع ViewControllers
        if shouldAutoEnableTheme() {
            setupInstantTheme()
        }
    }
    
    @objc private func swizzled_viewWillAppear(_ animated: Bool) {
        swizzled_viewWillAppear(animated) // استدعاء الطريقة الأصلية
        
        // تحديث السمة عند ظهور الـ View
        if isThemeSetup {
            applyInstantThemeUpdate()
        }
    }
    
    @objc private func swizzled_deinit() {
        cleanupInstantTheme()
       // swizzled_deinit() // استدعاء الطريقة الأصلية
    }
    
    private func shouldAutoEnableTheme() -> Bool {
        // استثناء بعض الـ ViewControllers من التطبيق التلقائي
        let excludedClasses = [
            "UIAlertController",
            "UIActivityViewController",
            "UIDocumentPickerViewController"
        ]
        
        let className = String(describing: type(of: self))
        return !excludedClasses.contains(className)
    }
}
