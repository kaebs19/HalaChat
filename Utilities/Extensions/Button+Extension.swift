import UIKit
import ObjectiveC

// MARK: - UIButton+Extensions للنظام الجديد

extension UIButton {
    
    // MARK: - Associated Keys

    private struct AssociatedKeys {
        static var buttonParameters: UInt8 = 50
        static var activityIndicator: UInt8 = 51
        static var originalTitle: UInt8 = 52
    }
    
    
    
    // MARK: - Instant Theme Setup
    
    /// إعداد شامل للزر مع النظام الجديد
    func setupForInstantTheme(
        title: Buttons? = nil,
        titleColorSet: AppColors,
        backgroundColorSet: AppColors? = nil,
        borderColorSet: AppColors? = nil,
        tintColorSet: AppColors? = nil,
        ofSize: Sizes,
        font: Fonts = .cairo,
        fontStyle: FontStyle = .regular,
        state: UIControl.State = .normal,
        alignment: Directions? = nil,
        cornerRadius: CGFloat = 0,
        borderWidth: CGFloat = 0,
        shadowColorSet: AppColors? = nil,
        shadowRadius: CGFloat = 0,
        shadowOffset: CGSize = CGSize(width: 0, height: 2),
        shadowOpacity: Float = 0.1,
        enablePressAnimation: Bool = true
    ) {
        // 📝 إعداد النص
        if let title = title {
            setTitle(title.textBtn, for: state)
        }
        
        // 🔤 إعداد الخط
        titleLabel?.font = FontManager.shared.font(family: font, style: fontStyle, size: ofSize)
        
        // ↔️ المحاذاة
        if let alignment = alignment {
            titleLabel?.textAlignment = alignment.textAlignment
        }
        
        // 🔸 الزوايا
        if cornerRadius > 0 {
            layer.cornerRadius = cornerRadius
            clipsToBounds = true
        }
        
        // 🖼️ الحدود
        if borderWidth > 0, let borderColorSet = borderColorSet {
            layer.borderWidth = borderWidth
            layer.borderColor = ThemeManager.shared.color(borderColorSet).cgColor
        }
        
        // 🌫️ الظل
        if let shadowColorSet = shadowColorSet, shadowRadius > 0 {
            layer.shadowColor = ThemeManager.shared.color(shadowColorSet).cgColor
            layer.shadowRadius = shadowRadius
            layer.shadowOpacity = shadowOpacity
            layer.shadowOffset = shadowOffset
            layer.masksToBounds = false
        }
        
        // 🎯 تأثير الضغط
        if enablePressAnimation {
            addPressAnimation()
        }
        
        // 🎨 تطبيق الألوان
        setTitleColor(ThemeManager.shared.color(titleColorSet), for: state)
        
        if let backgroundColorSet = backgroundColorSet {
            backgroundColor = ThemeManager.shared.color(backgroundColorSet)
        }
        
        if let tintColorSet = tintColorSet {
            tintColor = ThemeManager.shared.color(tintColorSet)
        }
        
        // 💾 حفظ المعاملات للتحديث التلقائي
        saveButtonParameters(
            titleColorSet: titleColorSet,
            backgroundColorSet: backgroundColorSet,
            borderColorSet: borderColorSet,
            tintColorSet: tintColorSet,
            borderWidth: borderWidth,
            shadowColorSet: shadowColorSet,
            shadowRadius: shadowRadius,
            state: state
        )
    }
    
    /// تحديث ألوان الزر
    func updateInstantThemeColors() {
        guard let parameters = getButtonParameters() else {
            return
        }
        
        // 🎨 تحديث لون النص
        setTitleColor(ThemeManager.shared.color(parameters.titleColorSet), for: parameters.state)
        
        // 🎨 تحديث لون الخلفية
        if let backgroundColorSet = parameters.backgroundColorSet {
            backgroundColor = ThemeManager.shared.color(backgroundColorSet)
        }
        
        // 🎨 تحديث لون الصبغة
        if let tintColorSet = parameters.tintColorSet {
            tintColor = ThemeManager.shared.color(tintColorSet)
        }
        
        // 🖼️ تحديث لون الحدود
        if parameters.borderWidth > 0, let borderColorSet = parameters.borderColorSet {
            layer.borderColor = ThemeManager.shared.color(borderColorSet).cgColor
        }
        
        // 🌫️ تحديث لون الظل
        if parameters.shadowRadius > 0, let shadowColorSet = parameters.shadowColorSet {
            layer.shadowColor = ThemeManager.shared.color(shadowColorSet).cgColor
        }
    }
    
    // MARK: - Animation Effects
    
    /// إضافة تأثير ضغط للزر
    func addPressAnimation() {
        addTarget(self, action: #selector(buttonPressed), for: .touchDown)
        addTarget(self, action: #selector(buttonReleased), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    /// إزالة تأثير الضغط
    func removePressAnimation() {
        removeTarget(self, action: #selector(buttonPressed), for: .touchDown)
        removeTarget(self, action: #selector(buttonReleased), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    @objc private func buttonPressed() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.alpha = 0.9
        }
    }
    
    @objc private func buttonReleased() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform.identity
            self.alpha = 1.0
        }
    }
    
    // MARK: - Loading State
    
    /// إظهار مؤشر التحميل
    func showLoading() {
        // حفظ النص الأصلي
        objc_setAssociatedObject(
            self,
            &AssociatedKeys.originalTitle,
            currentTitle,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
        
        // إخفاء النص
        setTitle("", for: .normal)
        
        // إنشاء مؤشر التحميل
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = currentTitleColor
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        
        addSubview(activityIndicator)
        
        // توسيط المؤشر
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        // حفظ المرجع
        objc_setAssociatedObject(
            self,
            &AssociatedKeys.activityIndicator,
            activityIndicator,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
        
        // تعطيل الزر
        isEnabled = false
    }
    
    /// إخفاء مؤشر التحميل
    func hideLoading() {
        // إزالة المؤشر
        if let activityIndicator = objc_getAssociatedObject(
            self,
            &AssociatedKeys.activityIndicator
        ) as? UIActivityIndicatorView {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
        
        // استعادة النص الأصلي
        if let originalTitle = objc_getAssociatedObject(
            self,
            &AssociatedKeys.originalTitle
        ) as? String {
            setTitle(originalTitle, for: .normal)
        }
        
        // تفعيل الزر
        isEnabled = true
    }
}

// MARK: - Parameters Storage

private extension UIButton {
    
    /// حفظ معاملات الزر
    func saveButtonParameters(
        titleColorSet: AppColors,
        backgroundColorSet: AppColors?,
        borderColorSet: AppColors?,
        tintColorSet: AppColors?,
        borderWidth: CGFloat,
        shadowColorSet: AppColors?,
        shadowRadius: CGFloat,
        state: UIControl.State
    ) {
        let parameters = ButtonParameters(
            titleColorSet: titleColorSet,
            backgroundColorSet: backgroundColorSet,
            borderColorSet: borderColorSet,
            tintColorSet: tintColorSet,
            borderWidth: borderWidth,
            shadowColorSet: shadowColorSet,
            shadowRadius: shadowRadius,
            state: state
        )
        
        objc_setAssociatedObject(
            self,
            &AssociatedKeys.buttonParameters,
            parameters,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
    }
    
    /// استرجاع معاملات الزر
    func getButtonParameters() -> ButtonParameters? {
        return objc_getAssociatedObject(self, &AssociatedKeys.buttonParameters) as? ButtonParameters
    }
}

// MARK: - Parameter Structure

/// هيكل معاملات الزر
private struct ButtonParameters {
    let titleColorSet: AppColors
    let backgroundColorSet: AppColors?
    let borderColorSet: AppColors?
    let tintColorSet: AppColors?
    let borderWidth: CGFloat
    let shadowColorSet: AppColors?
    let shadowRadius: CGFloat
    let state: UIControl.State
}



// MARK: - Deprecated Methods

extension UIButton {
    
    /// طريقة قديمة - محذرة
    @available(*, deprecated, message: "استخدم setupForInstantTheme بدلاً من هذه الطريقة")
    func customize(
        title: Buttons? = nil,
        ofSize: Sizes,
        font: Fonts,
        fontStyle: FontStyle = .regular,
        state: UIControl.State = .normal,
        alignment: Directions? = nil,
        cornerRadius: CGFloat = 0
    ) {
        if let title = title {
            setTitle(title.textBtn, for: state)
        }
        
        titleLabel?.font = FontManager.shared.font(family: font, style: fontStyle, size: ofSize)
        
        if let alignment = alignment {
            titleLabel?.textAlignment = alignment.textAlignment
        }
        
        if cornerRadius > 0 {
            addRadius(cornerRadius)
        }
        
        addPressAnimation()
    }
}
