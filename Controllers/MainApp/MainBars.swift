//
//  MainBars.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 02/05/2025.
//

import UIKit

class MainBars: UITabBarController {
    
    // MARK: - Properties
    private var selectedIndexs: Int = 0
    private var indicatorView: UIView?
    private var indicatorConstraints: [NSLayoutConstraint] = []
    

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        // ✅ إضافة: تفعيل نظام السمة الجديد
        enableInstantTheme(transitionStyle: .snapshot)

        DispatchQueue.main.async {
            self.updateTabBarItemTitles(selectedIndex: self.selectedIndex)
        }
    }
  
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // تحديث موضع المؤشر عند تغيير أبعاد الشاشة
        if let indicatorView = indicatorView {
            updateIndicatorPosition(forSelectedIndex: selectedIndexs, animated: false)
        }
    }
    

    
}

extension MainBars {
    
    // MARK: - UI Setup
    func setupUI() {
        hideNavigationBar(animated: true)
        // إعداد عناصر شريط التبويب
        setupTabBarItems()
        
        // تخصيص مظهر شريط التبويب
        customizeTabBarAppearance()
        
        // إضافة مؤشر متحرك للتبويب المحدد
        setupMovingIndicator()
        
        // إضافة ظل لشريط التبويب
        setupTabBarShadow()
        
        // تعيين التبويب الافتراضي
        selectedIndex = 0
        updateIndicatorPosition(forSelectedIndex: 0, animated: false)
    }
    

    
    /// إعداد عناصر شريط التبويب
    private func setupTabBarItems() {
        // تكوين عناصر شريط التبويب
        let homeConfig = TabBarItemConfig(title: .Home,
                                          selectedImage: AppImage.homeSelected.image ?? UIImage(), unselectedImage: AppImage.homeUnselected.image ?? UIImage())
        let messagesConfig = TabBarItemConfig(title: .Messages,
                                              selectedImage: AppImage.messageSelected.image ?? UIImage(), unselectedImage: AppImage.messageUnselected.image ?? UIImage())
        let notificationsConfig = TabBarItemConfig(title: .Notifications,
                                                   selectedImage: AppImage.notificationSelected.image ?? UIImage(), unselectedImage: AppImage.notificationUnselected.image ?? UIImage())
        let accountConfig = TabBarItemConfig(title: .Account,
                                             selectedImage: AppImage.accountSelected.image ?? UIImage(), unselectedImage: AppImage.accountUnselected.image ?? UIImage())
        
        guard let viewControllers = self.viewControllers,
              viewControllers.count >= 4 else { return }
        if let homeVC = viewControllers[0] as? UINavigationController {
            configureTabBarItem(for: homeVC, with: homeConfig)
        }
        
        if let messagesVC = viewControllers[1] as? UINavigationController {
            configureTabBarItem(for: messagesVC, with: messagesConfig)
        }
        
        if let notificationsVC = viewControllers[2] as? UINavigationController {
            configureTabBarItem(for: notificationsVC, with: notificationsConfig)
        }
        
        if let accountVC = viewControllers[3] as? UINavigationController {
            configureTabBarItem(for: accountVC, with: accountConfig)
        }
        
    }
    
    /// تكوين عنصر TabBar لـ ViewController محدد

    private func configureTabBarItem(for viewController: UIViewController, with config: TabBarItemConfig) {
        
        let tabBarItem = UITabBarItem( title: "",
                                       image: config.unselectedImage.withRenderingMode(.alwaysOriginal),
                                       selectedImage: config.selectedImage.withRenderingMode(.alwaysTemplate))
        
        tabBarItem.accessibilityLabel = config.title.titleName
        viewController.tabBarItem = tabBarItem
        
    }
    
    // MARK: - Tab Bar Appearance
    
    /// تخصيص مظهر شريط التبويب
    private func customizeTabBarAppearance() {
        
        // إنشاء مظهر جديد
        
        let appearance = UITabBarAppearance()
        
        // تخصيص الخلفية
        appearance.configureWithOpaqueBackground()
        
        appearance.backgroundColor = ThemeManager.shared.color(.tabBarBackground)
        
        // تخصيص الحدود العلوية
        appearance.shadowColor = ThemeManager.shared.color(.separator).withAlphaComponent(0.3)
        
        // تخصيص مظهر العناصر
        let itemAppearance = UITabBarItemAppearance()
        
        // نمط العنصر العادي
        itemAppearance.normal.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: Fonts.poppins.name, size: Sizes.size_10.rawValue) ?? UIFont.systemFont(ofSize: Sizes.size_10.rawValue),
            NSAttributedString.Key.backgroundColor: UIColor.clear
        ]
        
        // نمط العنصر المحدد
        itemAppearance.selected.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: Sizes.size_10.rawValue,
                                                           weight: FontStyle.semiBold.uiFontWeight),
            NSAttributedString.Key.foregroundColor: ThemeManager.shared.color(.primary),
    ]
        
        // تطبيق مظهر العناصر
        appearance.stackedLayoutAppearance = itemAppearance
        appearance.inlineLayoutAppearance = itemAppearance
        appearance.compactInlineLayoutAppearance = itemAppearance
        
        // تطبيق المظهر على TabBar
        tabBar.standardAppearance = appearance
        
        // ✅ تحديث: إضافة فحص الإصدار
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
        
    }
    
    /// إعداد ظل لشريط التبويب
    private func setupTabBarShadow() {
        tabBar.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -2)
        tabBar.layer.shadowRadius = 6
        tabBar.layer.shadowOpacity = 0.1
    }
    
    
    // MARK: - Moving Indicator
    private func setupMovingIndicator() {
        
        // إنشاء المؤشر
        let indicator = UIView()
        
        indicator.backgroundColor = ThemeManager.shared.color(.primary)
        indicator.layer.cornerRadius = 2
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        // إضافة المؤشر للـ TabBar
        tabBar.addSubview(indicator)
        tabBar.clipsToBounds = false
        
        // تخزين مرجع للمؤشر
        self.indicatorView = indicator
    }
    
    /// تحديث موضع المؤشر
    private func updateIndicatorPosition(forSelectedIndex index: Int , animated: Bool) {
        
        guard let indicatorView = indicatorView ,
              let items = tabBar.items,
              index < items.count else { return }
        
        // حساب موضع العنصر المحدد
        let tabWidth = tabBar.bounds.width / CGFloat(items.count)
        let indicatorWidth = tabWidth / 2
        let indicatorX = tabWidth * CGFloat(index) + (tabWidth - indicatorWidth) / 2
        
        NSLayoutConstraint.deactivate(indicatorConstraints)
        
        indicatorConstraints = [
            
            indicatorView.bottomAnchor.constraint(equalTo: tabBar.topAnchor, constant: 4),
            indicatorView.widthAnchor.constraint(equalToConstant: indicatorWidth),
            indicatorView.heightAnchor.constraint(equalToConstant: 4),
            indicatorView.centerXAnchor.constraint(equalTo: tabBar.leadingAnchor, constant: indicatorX + indicatorWidth / 2)

        ]
        
        NSLayoutConstraint.activate(indicatorConstraints)
        
        // تطبيق التحديث مع أو بدون تأثير انتقالي
        if animated {
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        } else {
            view.layoutIfNeeded()
        }
    }
    
    // MARK: - Tab Bar Delegate
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        // الحصول على الفهرس المحدد
        guard let index = tabBar.items?.firstIndex(of: item) else { return }
        
        // تحديث المؤشر الحالي أولاً
        selectedIndexs = index
        
        // تحديث موضع المؤشر
        updateIndicatorPosition(forSelectedIndex: index, animated: true)
        
        // تطبيق تأثير النبض
        applyPulseEffectToTabBarItem(at: index)
        
        // تحديث عناوين التبويبات - إظهار العنوان المحدد فقط
        DispatchQueue.main.async {
            self.updateTabBarItemTitles(selectedIndex: index)
        }
    }

    /// تطبيق تأثير نبض للعنصر المحدد
    private func applyPulseEffectToTabBarItem(at index: Int) {
        
        let tabBarButtons = tabBar.subviews.filter { $0 is UIControl }
        guard index < tabBarButtons.count else { return }

        let targetView = tabBarButtons[index]
        
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.fromValue = 1.0
        pulse.toValue = 1.2
        pulse.duration = pulse.settlingDuration
        pulse.damping = 7
        pulse.initialVelocity = 0.5
        pulse.mass = 0.8
        pulse.stiffness = 120

        targetView.layer.add(pulse, forKey: "pulse")

        
    }
    
    
    
    
    /// تحديث عناوين التبويبات لإظهار العنوان المحدد فقط

    private func updateTabBarItemTitles(selectedIndex: Int) {
        guard let items = tabBar.items else { return }
        
        // تحديث جميع العناوين
        for (index, item) in items.enumerated() {
            if index == selectedIndex {
                // إظهار العنوان للعنصر المحدد فقط
                item.title = item.accessibilityLabel
            } else {
                // إخفاء العنوان للعناصر غير المحددة
                item.title = ""
            }
        }
    }

    /// إضافة خلفية للعنصر المحدد
    private func addBackgroundToSelectedTab(tabBarButton: UIControl) {
        
        /// إضافة خلفية للعنصر المحدد
        removeBackgroundFromTab(tabBarButton: tabBarButton)
        
        // إنشاء خلفية جديدة
        let backgroundView = UIView()
        backgroundView.tag = 999 // تحديد تاج للخلفية لسهولة العثور عليها لاحقاً
        backgroundView.backgroundColor = ThemeManager.shared.color(.tabBarBackground)
        backgroundView.layer.cornerRadius = 15
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        // إضافة الخلفية تحت جميع العناصر الأخرى
        tabBarButton.insertSubview(backgroundView, at: 0)
        
        // تكوين قيود الخلفية
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: tabBarButton.leadingAnchor, constant: 8),
            backgroundView.trailingAnchor.constraint(equalTo: tabBarButton.trailingAnchor, constant: -8),
            backgroundView.topAnchor.constraint(equalTo: tabBarButton.topAnchor, constant: 5),
            backgroundView.bottomAnchor.constraint(equalTo: tabBarButton.bottomAnchor, constant: -5)

            ])
    }
    
    
    /// إزالة الخلفية من العنصر
    private func removeBackgroundFromTab(tabBarButton: UIControl) {
        if let backgroundView = tabBarButton.viewWithTag(999) {
            backgroundView.removeFromSuperview()
        }
    }
}

struct TabBarItemConfig {
    let title: TitleBar
    let selectedImage: UIImage
    let unselectedImage: UIImage
}


enum TitleBar: String, CaseIterable {
    case Home = "HomeTitle"
    case Notifications = "NotificationsTitle"
    case Messages = "MessagesTitle"
    case Account = "AccountTitle"
    
    var titleName: String {
        return NSLocalizedString(self.rawValue.localized, comment: "")
    }
}
