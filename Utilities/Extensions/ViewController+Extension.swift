
import UIKit
import MOLH



// MARK: - Theme Management - دوال إدارة السمة



extension UIViewController {
    
    /// تطبيق السمة على عناصر العرض
    /// يقوم بتطبيق السمة الحالية على جميع عناصر العرض في الواجهة.
    /// - **Note**: يتم استدعاء هذه الدالة تلقائياً عند تغيير السمة في التطبيق.
    
    func applyTheme() {
        view.setThemeBackground(.background)
        ThemeManager.shared.applyTheme(to: view)
    }
    
    /// إعداد مراقبة تغييرات السمة
    ///     /// يقوم بإعداد مراقب لتغييرات السمة وتنفيذ إجراء عند حدوث التغيير.
    /// - **Parameter** completion: الإجراء الذي سيتم تنفيذه بعد تطبيق السمة الجديدة.
    /// - **Returns**: معرّف فريد للمراقب يُستخدم لإزالته لاحقاً.
    
    func setupThemeObserver(completion: @escaping ()-> Void) -> UUID {
        
        return ThemeManager.shared.addThemeObserver { [weak self] in
            guard let self = self else { return }
            self.applyTheme()
            completion()
        }
    }
    
    /// تنظيف المراقبين
    ///  يقوم بإزالة مراقب تغييرات السمة باستخدام المعرّف الخاص به.
    /// - **Parameter** id: المعرّف الفريد للمراقب المراد إزالته.
    
    func clearThemeObserver(id: UUID?) {
        if let observerId = id {
            ThemeManager.shared.removeThemeObserver(id: observerId)
        }
    }
    
}

// MARK: - Navigation Bar Styling  - دوال تخصيص شريط التنقل
extension UIViewController {
    
    
    
    /// يقوم بإعداد شريط التنقل بالألوان والعنوان المناسبين للسمة الحالية.
    /// - **Parameters**:
    ///   - title: عنوان شريط التنقل (اختياري).
    ///   - backgroundColor: لون خلفية شريط التنقل (القيمة الافتراضية: .background).
    ///   - textColor: لون النص في شريط التنقل (القيمة الافتراضية: .text).
    ///   - tintColor: لون العناصر التفاعلية في شريط التنقل (القيمة الافتراضية: .primary).
    
    func setupNavigationBar(items: [NavigationBar] ) {
        
        var rightBar: [UIBarButtonItem] = []
        var leftBar: [UIBarButtonItem] = []
        
        for item in items {
            switch item {

                case .Help:
                    // نص فقط بدون استخدم صور
                    rightBar.append(UIBarButtonItem(title: Titles.Help.localized,
                                                   style: .plain, target: self,
                                                   action: #selector(showHelpButtonAction)))
                    
                case .BackButton:
                    // مع استخدم الصورة
                    let backImage = AppImage.back.tintedImage(with: .primary)
                    leftBar.append(UIBarButtonItem(image: backImage,
                                                   style: .plain, target: self,
                                                   action: #selector(backButtonAction)))
                    
                case .SearchBar:
                    let searchImage = AppImage.search.tintedImage(with: .primary)
                    leftBar.append(UIBarButtonItem(image: searchImage,
                                                   style: .plain, target: self,
                                                   action: #selector(showSearchButtonAction)))
                    
                case .Notification:
                    let notificationImage = AppImage.notification.tintedImage(with: .primary)
                    rightBar.append(UIBarButtonItem(image: notificationImage,
                                                    style: .plain, target: self,
                                                    action: #selector(showNotificationButtonAction)))
                case .More:
                    let moreImage = AppImage.more.tintedImage(with: .primary)
                    rightBar.append(UIBarButtonItem(image: moreImage,
                                                    style: .plain, target: self,
                                                    action: #selector(showMoreButtonAction)))
                case .list:
                    let listImage = AppImage.list.tintedImage(with: .primary)
                    rightBar.append(UIBarButtonItem(image: listImage,
                                                    style: .plain, target: self,
                                                    action: #selector(showListButtonAction)))
                case .Close:
                    let closeImage = AppImage.close.tintedImage(with: .primary)
                    leftBar.append(UIBarButtonItem(image: closeImage,
                                                   style: .plain, target: self,
                                                   action: #selector(backButtonAction)))
            }
        }
        
        
    }
    
    /// معالج حدث النقر على زر المساعدة في شريط التنقل.
    
    @objc func showHelpButtonAction() {
        print("showHelpButtonAction")
    }
    
    /// معالج حدث النقر على زر الرجوع في شريط التنقل.
    
    @objc func backButtonAction() {
        self.popViewController()
    }
    
    @objc func showSearchButtonAction() {
        print("showSearchButtonAction")
    }
    
    @objc func showNotificationButtonAction () {
        print("showNotificationButtonAction")
    }
    
    @objc func showMoreButtonAction() {
        print("showMoreButtonAction")
    }
    
    @objc func showListButtonAction() {
        print("showHelpButtonAction")
    }
}

// MARK: - Navigation Operations - دوال التنقل بين الواجهات
extension UIViewController {
    
    enum NavigationStyle {
        case push
        case present(animated: Bool, completion: (() -> Void)? = nil)
    }
    
    /// الانتقال إلى واجهة جديدة / Navigate to a new view controller
    /// ينتقل إلى واجهة عرض جديدة مع خيارات تخصيص متنوعة.
    /// - **Parameters**:
    ///   - storyboard: اسم ملف Storyboard المحتوي على الواجهة (القيمة الافتراضية: .Main).
    ///   - identifiers: معرّف الواجهة المراد الانتقال إليها.
    ///   - navigationStyle: أسلوب الانتقال (دفع أو عرض).
    ///   - animationOptions: خيارات الرسوم المتحركة للانتقال.
    ///   - duration: مدة الرسوم المتحركة بالثواني.
    ///   - configure: دالة تخصيص اختيارية للتطبيق على الواجهة الجديدة قبل الانتقال.
    
    func goToVC(
        storyboard: Storyborards = .Main,
        identifiers: Identifiers,
        navigationStyle: NavigationStyle = .push,
        animationOptions: UIView.AnimationOptions = .showHideTransitionViews,
        duration: TimeInterval = 0.5,
        configure: ((UIViewController) -> Void)? = nil
    ) {
        let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: identifiers.rawValue)
        
        configure?(vc) // تنفيذ التخصيص
        
        switch navigationStyle {
            case .push:
                if let navigationController = self.navigationController {
                    UIView.transition(with: navigationController.view, duration: duration, options: animationOptions) {
                        navigationController.pushViewController(vc, animated: false)
                    }
                } else {
                    print("Error: No navigation controller found for push navigation.")
                }
            case .present(animated: let animated, completion: let completion):
                UIView.transition(with: self.view, duration: duration, options: animationOptions) {
                    self.present(vc, animated: animated, completion: completion)
                }
        }
    }
    
    
    /// إظهار شريط التنقل / Show navigation bar
    ///  يُظهر شريط التنقل إذا كان مخفياً.
    /// - **Parameter** animated: ما إذا كان سيتم إظهار شريط التنقل بتأثير حركي (القيمة الافتراضية: true).
    
    func showNavigationBar(animated: Bool = true) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    /// يُخفي شريط التنقل إذا كان ظاهراً.
    /// - **Parameter** animated: ما إذا كان سيتم إخفاء شريط التنقل بتأثير حركي (القيمة الافتراضية: true).
    func hideNavigationBar(animated: Bool = true) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    /// ينتقل إلى الواجهة السابقة في مكدس التنقل.
    /// - **Parameter** animated: ما إذا كان سيتم الانتقال بتأثير حركي (القيمة الافتراضية: true).
    func popViewController(animated: Bool = true) {
        self.navigationController?.popViewController(animated: animated)
    }
    
    
    /// ينتقل إلى الواجهة الرئيسية (الأولى) في مكدس التنقل.
    /// - **Parameter** animated: ما إذا كان سيتم الانتقال بتأثير حركي (القيمة الافتراضية: true).
    func popToRootViewController(animated: Bool = true) {
        self.navigationController?.popToRootViewController(animated: animated)
    }
    
    /// يقوم بإغلاق الواجهة الحالية التي تم عرضها مسبقاً بأسلوب present.
    /// - **Parameters**:
    ///   - animated: ما إذا كان سيتم الإغلاق بتأثير حركي (القيمة الافتراضية: true).
    ///   - completion: الإجراء الذي سيتم تنفيذه بعد إكمال الإغلاق (اختياري).
    func dismissViewController(animated: Bool = true, completion: (() -> Void)? = nil) {
        self.dismiss(animated: animated, completion: completion)
    }
    
    /// ينتقل إلى واجهة محددة بالنوع في مكدس التنقل.
    /// - **Parameters**:
    ///   - ofClass: نوع الواجهة المراد الانتقال إليها.
    ///   - animated: ما إذا كان سيتم الانتقال بتأثير حركي (القيمة الافتراضية: true).
    /// - **Note**: إذا لم يتم العثور على الواجهة المطلوبة، سيتم طباعة رسالة خطأ.
    func popToViewController(ofClass: AnyClass, animated: Bool = true) {
        if let navigationController = self.navigationController {
            for viewController in navigationController.viewControllers {
                if viewController.isKind(of: ofClass) {
                    navigationController.popToViewController(viewController, animated: animated)
                    return
                }
            }
        }
        print("Error: View controller of specified class not found in navigation stack.")
    }
    
    /// يتحكم في ظهور أو إخفاء شريط التبويب.
    /// - **Parameter** isHidden: ما إذا كان شريط التبويب سيكون مخفياً (القيمة الافتراضية: true).
    func hideOrShowTabBar(isHidden: Bool = true) {
        self.tabBarController?.tabBar.isHidden = isHidden
    }
    
    
}
