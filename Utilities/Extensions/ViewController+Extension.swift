import UIKit
import MOLH
import SwiftMessages

// MARK: - Navigation Bar Styling

extension UIViewController {
    
    /// إعداد عناصر شريط التنقل
    func setupNavigationBar(items: [NavigationBar]) {
        var rightBar: [UIBarButtonItem] = []
        var leftBar: [UIBarButtonItem] = []
        
        for item in items {
            switch item {
            case .Help:
                // نص بدون صورة
                rightBar.append(UIBarButtonItem(
                    title: Titles.Help.textTitle,
                    style: .plain,
                    target: self,
                    action: #selector(showHelpButtonAction)
                ))
                
            case .BackButton:
                // زر رجوع مع صورة
                if let backImage = AppImage.back.tintedImage(with: ThemeManager.shared.color(.primary)) {
                    leftBar.append(UIBarButtonItem(
                        image: backImage.withRenderingMode(.alwaysTemplate),
                        style: .plain,
                        target: self,
                        action: #selector(backButtonAction)
                    ))
                }
                
            case .SearchBar:
                if let searchImage = AppImage.search.tintedImage(with: ThemeManager.shared.color(.primary)) {
                    leftBar.append(UIBarButtonItem(
                        image: searchImage,
                        style: .plain,
                        target: self,
                        action: #selector(showSearchButtonAction)
                    ))
                }
                
            case .Notification:
                if let notificationImage = AppImage.notification.tintedImage(with: ThemeManager.shared.color(.primary)) {
                    rightBar.append(UIBarButtonItem(
                        image: notificationImage,
                        style: .plain,
                        target: self,
                        action: #selector(showNotificationButtonAction)
                    ))
                }
                
            case .More:
                if let moreImage = AppImage.more.tintedImage(with: ThemeManager.shared.color(.primary)) {
                    rightBar.append(UIBarButtonItem(
                        image: moreImage,
                        style: .plain,
                        target: self,
                        action: #selector(showMoreButtonAction)
                    ))
                }
                
            case .list:
                if let listImage = AppImage.list.tintedImage(with: ThemeManager.shared.color(.primary)) {
                    rightBar.append(UIBarButtonItem(
                        image: listImage,
                        style: .plain,
                        target: self,
                        action: #selector(showListButtonAction)
                    ))
                }
                
            case .Close:
                if let closeImage = AppImage.close.tintedImage(with: ThemeManager.shared.color(.primary)) {
                    leftBar.append(UIBarButtonItem(
                        image: closeImage,
                        style: .plain,
                        target: self,
                        action: #selector(backButtonAction)
                    ))
                }
            }
        }
        
        navigationItem.rightBarButtonItems = rightBar
        navigationItem.leftBarButtonItems = leftBar
    }
    
    // MARK: - Navigation Bar Actions
    
    @objc func showHelpButtonAction() {
        print("showHelpButtonAction")
    }
    
    @objc func backButtonAction() {
        popViewController()
    }
    
    @objc func showSearchButtonAction() {
        print("showSearchButtonAction")
    }
    
    @objc func showNotificationButtonAction() {
        print("showNotificationButtonAction")
    }
    
    @objc func showMoreButtonAction() {
        print("showMoreButtonAction")
    }
    
    @objc func showListButtonAction() {
        print("showListButtonAction")
    }
}

// MARK: - Navigation Operations

extension UIViewController {
    
    enum NavigationStyle {
        case push
        case present(animated: Bool = true, completion: (() -> Void)? = nil)
    }
    
    /// الانتقال لواجهة جديدة مع خيارات متقدمة
    func goToVC(
        storyboard: Storyboards = .Main,
        identifiers: Identifiers,
        navigationStyle: NavigationStyle = .push,
        animationOptions: UIView.AnimationOptions = .transitionCrossDissolve,
        duration: TimeInterval = 0.3,
        configure: ((UIViewController) -> Void)? = nil
    ) {
        let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: identifiers.rawValue)
        
        configure?(vc)
        
        switch navigationStyle {
        case .push:
            guard let navigationController = navigationController else {
                print("❌ Error: No navigation controller found")
                return
            }
            
            UIView.transition(
                with: navigationController.view,
                duration: duration,
                options: animationOptions,
                animations: {
                    navigationController.pushViewController(vc, animated: false)
                }
            )
            
        case .present(let animated, let completion):
            present(vc, animated: animated, completion: completion)
        }
    }
    
    /// إظهار شريط التنقل
    func showNavigationBar(animated: Bool = true) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    /// إخفاء شريط التنقل
    func hideNavigationBar(animated: Bool = true) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    /// الرجوع للواجهة السابقة
    func popViewController(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }
    
    /// الرجوع للواجهة الرئيسية
    func popToRootViewController(animated: Bool = true) {
        navigationController?.popToRootViewController(animated: animated)
    }
    
    /// إغلاق الواجهة المعروضة
    func dismissViewController(animated: Bool = true, completion: (() -> Void)? = nil) {
        dismiss(animated: animated, completion: completion)
    }
    
    /// إخفاء شريط التبويب
    func hideOrShowTabBar(isHidden: Bool = true) {
        tabBarController?.tabBar.isHidden = isHidden
    }
    
    /// إخفاء زر الرجوع
    func hideBackButton(isHidden: Bool = true) {
        navigationItem.hidesBackButton = isHidden
        if isHidden {
            navigationItem.leftBarButtonItems = nil
        }
    }
    
    /// تعيين زر رجوع فارغ
    func setEmptyBackButton() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

// MARK: - Messages

extension UIViewController {
    
    /// عرض رسالة توضيحية
    func showMessage(title: String, message: String, theme: Theme = .info) {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(theme)
        view.configureDropShadow()
        view.configureContent(title: title, body: message)
        view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
        view.button?.isHidden = true
        SwiftMessages.show(view: view)
    }
}

// MARK: - Title Styling للنظام الجديد

extension UIViewController {
    
    /// تعيين عنوان منسق للشريط مع النظام الجديد
    /// - مثال الاستخدام:
    /// ```swift
    /// // في viewDidLoad
    /// setStyledTitle(title: .welcome)
    ///
    /// // أو مع تخصيصات
    /// setStyledTitle(
    ///     title: .profile,
    ///     colorSet: .primary,
    ///     fontSize: .size_18,
    ///     useLargeTitle: true
    /// )
    /// ```
    func setStyledTitle(
        title: Titles,
        colorSet: AppColors = .text,
        font: Fonts? = nil,
        fontStyle: FontStyle = .semiBold,
        fontSize: Sizes = .size_18,
        alignment: NSTextAlignment? = nil,
        useLargeTitle: Bool = false
    ) {
        // إعداد العنوان الكبير
        navigationController?.navigationBar.prefersLargeTitles = useLargeTitle
        navigationItem.largeTitleDisplayMode = useLargeTitle ? .always : .never
        
        // الخط المستخدم
        let fontToUse = font != nil ?
            FontManager.shared.font(family: font!, style: fontStyle, size: fontSize) :
            FontManager.shared.fontForCurrentLanguage(style: fontStyle, size: fontSize)
        
        // لون النص
        let textColor = ThemeManager.shared.color(colorSet)
        
        if useLargeTitle {
            // عنوان كبير
            navigationItem.title = title.textTitle
            
            let largeTitleAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: textColor,
                .font: fontToUse
            ]
            
            navigationController?.navigationBar.largeTitleTextAttributes = largeTitleAttributes
            
            // حفظ المعاملات للتحديث التلقائي
            saveTitleParameters(
                title: title,
                colorSet: colorSet,
                font: font,
                fontStyle: fontStyle,
                fontSize: fontSize,
                isLargeTitle: true
            )
            
        } else {
            // عنوان صغير مخصص
            let titleLabel = UILabel()
            titleLabel.text = title.textTitle
            titleLabel.textColor = textColor
            titleLabel.font = fontToUse
            titleLabel.textAlignment = alignment ?? (isEnglish() ? .left : .right)
            titleLabel.sizeToFit()
            
            navigationItem.titleView = titleLabel
            
            // حفظ المعاملات للتحديث التلقائي
            saveTitleParameters(
                title: title,
                colorSet: colorSet,
                font: font,
                fontStyle: fontStyle,
                fontSize: fontSize,
                isLargeTitle: false,
                alignment: alignment
            )
        }
    }
    
    /// تحديث عنوان الشريط عند تغيير السمة
    func updateNavigationTitle() {
        guard let parameters = getTitleParameters() else { return }
        
        let fontToUse = parameters.font != nil ?
            FontManager.shared.font(family: parameters.font!, style: parameters.fontStyle, size: parameters.fontSize) :
            FontManager.shared.fontForCurrentLanguage(style: parameters.fontStyle, size: parameters.fontSize)
        
        let textColor = ThemeManager.shared.color(parameters.colorSet)
        
        if parameters.isLargeTitle {
            navigationItem.title = parameters.title.textTitle
            
            let largeTitleAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: textColor,
                .font: fontToUse
            ]
            
            navigationController?.navigationBar.largeTitleTextAttributes = largeTitleAttributes
            
        } else if let titleLabel = navigationItem.titleView as? UILabel {
            titleLabel.text = parameters.title.textTitle
            titleLabel.textColor = textColor
            titleLabel.font = fontToUse
            titleLabel.textAlignment = parameters.alignment ?? (isEnglish() ? .left : .right)
            titleLabel.sizeToFit()
        }
    }
}

// MARK: - Private Helpers

private extension UIViewController {
    
    private struct AssociatedKeys {
        static var titleParameters: UInt8 = 60
    }
    
    struct TitleParameters {
        let title: Titles
        let colorSet: AppColors
        let font: Fonts?
        let fontStyle: FontStyle
        let fontSize: Sizes
        let isLargeTitle: Bool
        let alignment: NSTextAlignment?
    }
    
    func saveTitleParameters(
        title: Titles,
        colorSet: AppColors,
        font: Fonts?,
        fontStyle: FontStyle,
        fontSize: Sizes,
        isLargeTitle: Bool,
        alignment: NSTextAlignment? = nil
    ) {
        let parameters = TitleParameters(
            title: title,
            colorSet: colorSet,
            font: font,
            fontStyle: fontStyle,
            fontSize: fontSize,
            isLargeTitle: isLargeTitle,
            alignment: alignment
        )
        
        objc_setAssociatedObject(
            self,
            &AssociatedKeys.titleParameters,
            parameters,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
    }
    
    func getTitleParameters() -> TitleParameters? {
        return objc_getAssociatedObject(self, &AssociatedKeys.titleParameters) as? TitleParameters
    }
}

// MARK: - كيفية الاستخدام

/*
🎯 أمثلة الاستخدام:

1️⃣ **عنوان بسيط:**
```swift
override func viewDidLoad() {
    super.viewDidLoad()
    setStyledTitle(title: .welcome)
}
```

2️⃣ **عنوان مخصص:**
```swift
setStyledTitle(
    title: .profile,
    colorSet: .primary,
    font: .cairo,
    fontStyle: .bold,
    fontSize: .size_20
)
```

3️⃣ **عنوان كبير:**
```swift
setStyledTitle(
    title: .home,
    useLargeTitle: true
)
```

4️⃣ **تحديث العنوان في applyInstantThemeUpdate:**
```swift
override func applyInstantThemeUpdate() {
    super.applyInstantThemeUpdate()
    updateNavigationTitle()
}
```

5️⃣ **إضافة أزرار شريط التنقل:**
```swift
setupNavigationBar(items: [.BackButton, .Notification, .More])
```

6️⃣ **عرض رسالة:**
```swift
showMessage(title: "نجاح", message: "تم الحفظ بنجاح", theme: .success)
```
*/
