
import UIKit
import MOLH
import SwiftMessages


// MARK: - Theme Management - دوال إدارة السمة



extension UIViewController {
    
    /// تطبيق السمة على عناصر العرض
    /// يقوم بتطبيق السمة الحالية على جميع عناصر العرض في الواجهة.
    /// - **Note**: يتم استدعاء هذه الدالة تلقائياً عند تغيير السمة في التطبيق.
    
    func applyTheme() {
        updateViewColors()
    }
    
    
    /// تحديث ألوان العناصر الرئيسية
    private func updateViewColors() {
        // تطبيق الألوان على العناصر الرئيسية
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.tintColor = ThemeManager.shared.color(.primary)
            navigationBar.barTintColor = ThemeManager.shared.color(.background)
            
            // تحديث لون النص في شريط التنقل
            navigationBar.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: ThemeManager.shared.color(.text)
            ]
        }
        
        // تحديث لون النص في حالة العرض
        setNeedsStatusBarAppearanceUpdate()
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
    
    func setupNavigationBar(items: [NavigationBar]) {
        
        var rightBar: [UIBarButtonItem] = []
        var leftBar: [UIBarButtonItem] = []
        
        for item in items {
            switch item {
                    
                case .Help:
                    // نص فقط بدون استخدم صور
                    rightBar.append(UIBarButtonItem(title: Titles.Help.textTitle,
                                                    style: .plain, target: self,
                                                    action: #selector(showHelpButtonAction)))
                    
                case .BackButton:
                    // مع استخدم الصورة
                    let backImage = AppImage.back.tintedImage(with: ThemeManager.shared.color(.primary))
                    leftBar.append(UIBarButtonItem(image: backImage?.withRenderingMode(.alwaysTemplate),
                                                   style: .plain, target: self,
                                                   action: #selector(backButtonAction)))
                    
                case .SearchBar:
                    let searchImage = AppImage.search.tintedImage(with: ThemeManager.shared.color(.primary))
                    leftBar.append(UIBarButtonItem(image: searchImage,
                                                   style: .plain, target: self,
                                                   action: #selector(showSearchButtonAction)))
                    
                case .Notification:
                    let notificationImage = AppImage.notification.tintedImage(with: ThemeManager.shared.color(.primary))
                    rightBar.append(UIBarButtonItem(image: notificationImage,
                                                    style: .plain, target: self,
                                                    action: #selector(showNotificationButtonAction)))
                case .More:
                    let moreImage = AppImage.more.tintedImage(with: ThemeManager.shared.color(.primary))
                    rightBar.append(UIBarButtonItem(image: moreImage,
                                                    style: .plain, target: self,
                                                    action: #selector(showMoreButtonAction)))
                case .list:
                    let listImage = AppImage.list.tintedImage(with: ThemeManager.shared.color(.primary))
                    rightBar.append(UIBarButtonItem(image: listImage,
                                                    style: .plain, target: self,
                                                    action: #selector(showListButtonAction)))
                case .Close:
                    let closeImage = AppImage.close.tintedImage(with: ThemeManager.shared.color(.primary))
                    leftBar.append(UIBarButtonItem(image: closeImage,
                                                   style: .plain, target: self,
                                                   action: #selector(backButtonAction)))
            }
        }
        
        self.navigationItem.rightBarButtonItems = rightBar
        self.navigationItem.leftBarButtonItems = leftBar
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
        storyboard: Storyboards = .Main,
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
    
    /// إخفاء زر العودة (Back Button) في شريط التنقل
    /// - Parameters:
    ///   - isHidden: ما إذا كان سيتم إخفاء زر العودة (القيمة الافتراضية: true).
    ///   - animated: ما إذا كان سيتم تطبيق التغيير بتأثير حركي (القيمة الافتراضية: false).
    
    func hideBackButton(isHidden: Bool = true, animated: Bool = false) {
        if isHidden {
            // إخفاء زر العودة
            navigationItem.hidesBackButton = true
            // إزالة أي زر مخصص للرجوع في الجانب الأيسر
            navigationItem.leftBarButtonItems = nil
        } else {
            // إظهار زر العودة الافتراضي
            navigationItem.hidesBackButton = false
        }
        
        if animated {
            navigationController?.setNavigationBarHidden(false, animated: false)
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    /// استبدال زر العودة بزر مخصص أو بعنوان فارغ
    /// - Parameters:
    ///   - title: العنوان المراد استخدامه بدلاً من "العودة" (للتخصيص أو تركه فارغًا)
    ///   - target: الكائن الذي سيتلقى إجراء النقر
    ///   - action: الإجراء الذي سيتم تنفيذه عند النقر
    func customizeBackButton(title: String? = nil, target: AnyObject? = nil, action: Selector? = nil) {
        let backItem = UIBarButtonItem(title: title, style: .plain, target: target ?? self, action: action ?? #selector(backButtonAction))
        // تعيين الزر كعنصر في الجانب الأيسر
        navigationItem.backBarButtonItem = backItem
    }
    
    /// تعيين زر الرجوع فارغاً (لا نص مع الاحتفاظ بالسهم)
    func setEmptyBackButton() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        // جعل عنوان زر العودة فارغاً في الواجهة التالية
        let backItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        
    }
    
}

extension UIViewController {
    
    /*
     اظهار رسائل التوضيحية
     
     */
    func showMessage(title: String, message: String , theme: Theme) {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(theme)
        view.configureDropShadow()
        view.configureContent(title: title, body: message)
        view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
        view.button?.isHidden = true
        // Show the message.
        SwiftMessages.show(view: view)
        
    }
}


// MARK -- Title
extension UIViewController {
    /// تعيين عنوان منسق للشاشة
    ///
    /// - Parameters:
    ///   - title: النص المراد عرضه
    ///   - color: لون النص (اختياري، افتراضي: .text)
    ///   - fontFamily: عائلة الخط (اختياري، يستخدم الخط حسب اللغة الحالية)
    ///   - fontStyle: نمط الخط (اختياري، افتراضي: .semiBold)
    ///   - fontSize: حجم الخط (اختياري، افتراضي: .size_16)
    ///   - alignment: محاذاة النص (اختياري، افتراضي: حسب اتجاه اللغة)
    ///   - useLargeTitle: هل يتم عرض العنوان كـ "Large Title"؟ (اختياري، افتراضي: false)

    func setStyledTitle(title: Titles,
                        Color: AppColors = .text,
                        font: Fonts? = .poppins,
                        fontStyle: FontStyle = .semiBold,
                        FontSize: Sizes = .size_16,
                        alignment: NSTextAlignment? = nil,
                        useLargeTitle: Bool = false) {
        
        // تعيين إذا كان نستخدم العنوان الكبير
        navigationController?.navigationBar.prefersLargeTitles = useLargeTitle
        navigationItem.largeTitleDisplayMode = useLargeTitle ? .always : .never
        
        if useLargeTitle {
            // استخدام الخاصية الأساسية title بدلًا من titleView (للعنوان الكبير)
            navigationItem.title = title.textTitle
            
            // تعيين لون الخط الكبير عبر مظهر navigationBar
            let textColor = ColorTheme.current == .dark ? Color.darkModeColor : Color.lightModeColor
            let fontToUse: UIFont = font != nil ?
                FontManager.shared.font(family: font!, style: fontStyle, size: FontSize) :
                FontManager.shared.fontForCurrentLanguage(style: fontStyle, size: FontSize)

            let largeTitleAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: textColor,
                .font: fontToUse
            ]
            
            navigationController?.navigationBar.largeTitleTextAttributes = largeTitleAttributes

        } else {
            // إنشاء label مخصص للعناوين الصغيرة
            let titleLabel = UILabel()
            titleLabel.text = title.textTitle
            titleLabel.textColor = ColorTheme.current == .dark ? Color.darkModeColor : Color.lightModeColor
            titleLabel.font = font != nil ?
                FontManager.shared.font(family: font!, style: fontStyle, size: FontSize) :
                FontManager.shared.fontForCurrentLanguage(style: fontStyle, size: FontSize)
            titleLabel.textAlignment = alignment ?? (isEnglish() ? .right : .left)
            
            navigationItem.titleView = titleLabel
        }
    }
    
    
    
    /// تعيين عنوان منسق من مجموعة النصوص
    ///
    /// مثال الاستخدام: `setStyledTitle(Titles.SignUp.textTitle, color: .primary)`
    ///
    /// - Parameters:
    ///   - textKey: المفتاح المرجعي للنص من مجموعة Titles
    ///   - color: لون النص (اختياري، افتراضي: .text)
    ///   - fontFamily: عائلة الخط (اختياري، يستخدم الخط حسب اللغة الحالية)
    ///   - fontStyle: نمط الخط (اختياري، افتراضي: .semiBold)
    ///   - fontSize: حجم الخط (اختياري، افتراضي: .size_16)
    ///   - alignment: محاذاة النص (اختياري، افتراضي: حسب اتجاه اللغة)
    func setStyledTitle ( textKey: String,
                           color: AppColors = .text,
                           fontFamily: String? = nil,
                          fontStyle: FontStyle = .semiBold,
                           fontSize: Sizes = .size_16,
                           alignment: NSTextAlignment = .natural){

        setStyledTitle(textKey: textKey, color: color, fontFamily: fontFamily, fontStyle: fontStyle, fontSize: fontSize, alignment: alignment)

    }
        
  
     
    
}


extension UIViewController {
    /// أضف مراقب لتغيير الثيم
    func registerForThemeChanges() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(themeDidChange),
            name: ThemeManager.themeChangedNotification,
            object: nil
        )
    }
    
    /// إلغاء المراقبة عند الانتهاء
    func unregisterFromThemeChanges() {
        NotificationCenter.default.removeObserver(
            self,
            name: ThemeManager.themeChangedNotification,
            object: nil
        )
    }
    
    /// استدعاء عند تغيير الثيم
    @objc func themeDidChange() {
        view.updateColors()
        setNeedsStatusBarAppearanceUpdate()
    }
    
    
}
