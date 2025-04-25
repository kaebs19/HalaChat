import UIKit

extension UIButton {
    
    // تطبيق لون النص المتوافق مع السمة
    func setThemeTitleColor(_ colorSet: AppColors, for state: UIControl.State = .normal) {
        // إلغاء المراقب السابق إذا وجد
        removeThemeObserver(forKey: &AssociatedKeys.themeObserver)
        
        // تعيين اللون الحالي
        setTitleColor(ThemeManager.shared.color(colorSet), for: state)
        
        // إضافة مراقب جديد
        let observer = ThemeManager.shared.addThemeObserver { [weak self] in
            self?.setTitleColor(ThemeManager.shared.color(colorSet), for: state)
        }
        
        // تخزين المعرف مع العنصر
        setThemeObserver(id: observer, forKey: &AssociatedKeys.themeObserver)
    }
    
    // تطبيق لون الخلفية المتوافق مع السمة
    func setButtonBackgroundColor(_ colorSet: AppColors) {
        // إلغاء المراقب السابق إذا وجد
        removeThemeObserver(forKey: &AssociatedKeys.backgroundThemeObserver)
        
        // تعيين اللون الحالي
        backgroundColor = ThemeManager.shared.color(colorSet)
        
        // إضافة مراقب جديد
        let observer = ThemeManager.shared.addThemeObserver { [weak self] in
            self?.backgroundColor = ThemeManager.shared.color(colorSet)
        }
        
        // تخزين المعرف مع العنصر
        setThemeObserver(id: observer, forKey: &AssociatedKeys.backgroundThemeObserver)
    }
    
    // إضافة تأثير ضغط للزر
    func addPressAnimation() {
        addTarget(self, action: #selector(buttonPressed), for: .touchDown)
        addTarget(self, action: #selector(buttonReleased), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    @objc func buttonPressed() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.alpha = 0.9
        }
    }
    
    @objc func buttonReleased() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform.identity
            self.alpha = 1.0
        }
    }
    
    /// إضافة زوايا منحنية
    func addCornerRadius(_ cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = cornerRadius > 0
    }
    
    // للتوافق مع الكود القديم
    func addRadisButton(cornerRadius: CGFloat) {
        addRadius(cornerRadius)
    }
    
    /// تخصيص الزر بشكل كامل
    func customize(
        title: String? = nil,
        titleColor: AppColors,
        backgroundColor: AppColors? = nil,
        font: UIFont? = nil,
        cornerRadius: CGFloat = 0,
        state: UIControl.State = .normal
    ) {
        if let title = title {
            setTitle(title, for: state)
        }
        
        setThemeTitleColor(titleColor, for: state)
        
        if let backgroundColor = backgroundColor {
            setThemeBackgroundColor(backgroundColor)
        }
        
        if let font = font {
            titleLabel?.font = font
        }
        
        if cornerRadius > 0 {
            addRadius(cornerRadius)
        }
    }
    
    /// تخصيص الزر مع النصوص المعرفة (Enum)
    func customize(
        title: Buttons? = nil,
        titleColor: AppColors,
        backgroundColor: AppColors? = nil,
        ofSize: Sizes,
        font: Fonts,
        fontStyle: FontStyle = .regular,
        state: UIControl.State = .normal
    ) {
        if let title = title {
            setTitle(title.textBtn, for: state)
        }
        
        setThemeTitleColor(titleColor, for: state)
        
        if let backgroundColor = backgroundColor {
            setThemeBackgroundColor(backgroundColor)
        }
        
        titleLabel?.font = FontManager.shared.font(family: font, style: fontStyle, size: ofSize)
    }
    
    /// تخصيص الزر باستخدام ألوان UIColor مباشرة
    func customizeWithColor(
        title: Buttons? = nil,
        titleColor: UIColor,
        backgroundColor: UIColor? = nil,
        ofSize: Sizes,
        font: Fonts,
        fontStyle: FontStyle = .regular,
        state: UIControl.State = .normal
    ) {
        if let title = title {
            setTitle(title.textBtn, for: state)
        }
        
        setTitleColor(titleColor, for: state)
        
        if let backgroundColor = backgroundColor {
            self.backgroundColor = backgroundColor
        }
        
        titleLabel?.font = FontManager.shared.font(family: font, style: fontStyle, size: ofSize)
    }
    
    /// تخصيص مرن للزر
    func customizeFlexible(
        title: Buttons? = nil,
        titleColor: UIColor? = nil,
        titleColorSet: AppColors? = nil,
        backgroundColor: UIColor? = nil,
        backgroundColorSet: AppColors? = nil,
        ofSize: Sizes,
        font: Fonts,
        fontStyle: FontStyle = .regular,
        state: UIControl.State = .normal
    ) {
        if let title = title {
            setTitle(title.textBtn, for: state)
        }
        
        // تعيين لون النص (الأولوية للون المباشر، ثم نظام السمات)
        if let color = titleColor {
            setTitleColor(color, for: state)
        } else if let colorSet = titleColorSet {
            setThemeTitleColor(colorSet, for: state)
        }
        
        // تعيين لون الخلفية (الأولوية للون المباشر، ثم نظام السمات)
        if let bgColor = backgroundColor {
            self.backgroundColor = bgColor
        } else if let bgColorSet = backgroundColorSet {
            setThemeBackgroundColor(bgColorSet)
        }
        
        // تعيين الخط
        titleLabel?.font = FontManager.shared.font(family: font, style: fontStyle, size: ofSize)
    }
}
