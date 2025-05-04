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
    private var themeObserver: UUID?
    private var indicatorView: UIView?
    private var indicatorConstraints: [NSLayoutConstraint] = []
    

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // تحديث أي عناصر خاصة عند تغيير السمة
        themeObserver = setupThemeObserver { [weak self] in
            self?.customizeTabBarAppearance()
            self?.updateIndicatorPosition(forSelectedIndex: self?.selectedIndexs ?? 0, animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // تحديث موضع المؤشر عند تغيير أبعاد الشاشة
        if let indicatorView = indicatorView {
            updateIndicatorPosition(forSelectedIndex: selectedIndexs, animated: false)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // تنظيق وازالة العناصر
        clearThemeObserver(id: themeObserver)
        themeObserver = nil
    }
    
    
    deinit {
        // تأكيد إضافي على تنظيف الموارد
        clearThemeObserver(id: themeObserver)
        themeObserver = nil
    }

    
}

extension MainBars {
    
    // MARK: - UI Setup
    func setupUI() {
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
        
        // إنشاء ViewControllers
        let homeVC = UINavigationController(rootViewController: HomeVC())
        let messagesVC = UINavigationController(rootViewController: MessagesVC())
        let notificationsVC = UINavigationController(rootViewController: NotificationVC())
        let accountVC = UINavigationController(rootViewController: AccountVC())
        
        // تعيين Tab Bar Items
        configureTabBarItem(for: homeVC, with: homeConfig)
        configureTabBarItem(for: messagesVC, with: homeConfig)
        configureTabBarItem(for: notificationsVC, with: notificationsConfig)
        configureTabBarItem(for: accountVC, with: accountConfig)
        
        // تعيين Tab Bar Items
        viewControllers = [homeVC, messagesVC, notificationsVC, accountVC]

    }
    
    /// تكوين عنصر TabBar لـ ViewController محدد

    private func configureTabBarItem(for viewController: UIViewController, with config: TabBarItemConfig) {
        let tabBarItem = UITabBarItem( title: config.title.titleName,
                                       image: config.unselectedImage.withRenderingMode(.alwaysOriginal),
                                       selectedImage: config.selectedImage.withRenderingMode(.alwaysTemplate))
        
        viewController.tabBarItem = tabBarItem
    }
    
    // MARK: - Tab Bar Appearance
    
    /// تخصيص مظهر شريط التبويب
    private func customizeTabBarAppearance() {
        
        // إنشاء مظهر جديد
        
        let appearance = UITabBarAppearance()
        
        // تخصيص الخلفية
        appearance.configureWithOpaqueBackground()
        
        appearance.backgroundColor = ThemeManager.shared.color(.background)
        
        // تخصيص الحدود العلوية
        appearance.shadowColor = ThemeManager.shared.color(.separator).withAlphaComponent(0.3)
        
        // تخصيص مظهر العناصر
        let itemAppearance = UITabBarItemAppearance()
        
        // نمط العنصر العادي
        itemAppearance.normal.titleTextAttributes = [
            NSAttributedString.Key.font: Fonts.poppins.name,
            NSAttributedString.Key.backgroundColor: ThemeManager.shared.color(.textSecond)
        ]
        
        // نمط العنصر المحدد
        itemAppearance.selected.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: Sizes.size_10.rawValue,
                                                           weight: FontStyle.semiBold.uiFontWeight),
            NSAttributedString.Key.foregroundColor: ThemeManager.shared.color(.primary)
    ]
        
        // تطبيق مظهر العناصر
        appearance.stackedLayoutAppearance = itemAppearance
        appearance.inlineLayoutAppearance = itemAppearance
        appearance.compactInlineLayoutAppearance = itemAppearance
        
        // تطبيق المظهر على TabBar
        tabBar.standardAppearance = appearance
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
        
        // تحديث موضع المؤشر
        updateIndicatorPosition(forSelectedIndex: index, animated: true)
    }
    
    /// تطبيق تأثير نبض للعنصر المحدد
    private func applyPulseEffectToTabBarItem(at index: Int) {
        
        // الحصول على مرجع للعنصر المحدد
        guard index + 1 < tabBar.subviews.count else { return }
        let subview = tabBar.subviews[index + 1]
        
        // تطبيق التأثير
        UIView.animate(withDuration: 0.15, animations: {
            subview.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        } , completion: { _ in
            UIView.animate(withDuration: 0.15, animations: {
                subview.transform = CGAffineTransform.identity
            })
            
        })
        
    }
}

struct TabBarItemConfig {
    let title: TitleBar
    let selectedImage: UIImage
    let unselectedImage: UIImage
}


enum TitleBar: String, CaseIterable {
    case Home = "HomeTitle"
    case Notifications = "MassageTitle"
    case Messages = "NotificationsTitle"
    case Account = "AccountTitle"
    
    var titleName: String {
        return NSLocalizedString(self.rawValue.localized, comment: "")
    }
}
