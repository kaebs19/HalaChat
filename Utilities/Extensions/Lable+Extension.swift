import UIKit

// MARK: - ✅ UILabel+Extensions مصحح للنظام الجديد

extension UILabel {
    
    // MARK: - ✅ Basic Setup Methods (No Theme Dependency)
    
    /// إعداد أساسي للـ Label (بدون ألوان ديناميكية)
    func setupBasic(
        text: String? = nil,
        font: Fonts,
        fontStyle: FontStyle = .regular,
        ofSize: Sizes,
        direction: Directions = .auto,
        lines: Int = 1,
        adjustsFontSizeToFitWidth: Bool = false
    ) {
        self.text = text ?? ""
        self.font = FontManager.shared.font(family: font, style: fontStyle, size: ofSize)
        self.textAlignment = direction.textAlignment
        self.numberOfLines = lines
        self.adjustsFontForContentSizeCategory = adjustsFontSizeToFitWidth
    }
    
    /// تخصيص Label باستخدام UIColor مباشرة (لا يتأثر بتغيير السمة)
    func customizeWithDirectColor(
        text: String? = nil,
        color: UIColor,
        backgroundColor: UIColor? = nil,
        font: Fonts,
        fontStyle: FontStyle = .regular,
        ofSize: Sizes,
        direction: Directions = .auto,
        lines: Int = 1,
        adjustsFontSizeToFitWidth: Bool = false
    ) {
        // الإعداد الأساسي
        setupBasic(
            text: text,
            font: font,
            fontStyle: fontStyle,
            ofSize: ofSize,
            direction: direction,
            lines: lines,
            adjustsFontSizeToFitWidth: adjustsFontSizeToFitWidth
        )
        
        // الألوان المباشرة
        self.textColor = color
        if let backgroundColor = backgroundColor {
            self.backgroundColor = backgroundColor
        }
    }
    
    // MARK: - ✅ Instant Theme Compatible Methods
    
    /// تخصيص Label للنظام الجديد (متوافق مع InstantTheme)
    func setupForInstantTheme(
        text: String? = nil,
        textColorSet: AppColors,
        backgroundColorSet: AppColors? = nil,
        font: Fonts,
        fontStyle: FontStyle = .regular,
        ofSize: Sizes,
        direction: Directions = .auto,
        lines: Int = 1,
        adjustsFontSizeToFitWidth: Bool = false
    ) {
        // الإعداد الأساسي
        setupBasic(
            text: text,
            font: font,
            fontStyle: fontStyle,
            ofSize: ofSize,
            direction: direction,
            lines: lines,
            adjustsFontSizeToFitWidth: adjustsFontSizeToFitWidth
        )
        
        // حفظ معاملات الألوان للتحديث التلقائي
        saveLabelColorParameters(
            textColorSet: textColorSet,
            backgroundColorSet: backgroundColorSet
        )
        
        // تطبيق الألوان الأولية
        applyInstantColors(
            textColorSet: textColorSet,
            backgroundColorSet: backgroundColorSet
        )
    }
    
    /// تطبيق الألوان مباشرة (للاستخدام الفوري)
    func applyInstantColors(
        textColorSet: AppColors,
        backgroundColorSet: AppColors? = nil
    ) {
        // تطبيق لون النص
        self.textColor = ThemeManager.shared.color(textColorSet)
        
        // تطبيق لون الخلفية إذا تم تحديده
        if let backgroundColorSet = backgroundColorSet {
            self.backgroundColor = ThemeManager.shared.color(backgroundColorSet)
        }
    }
    
    /// تحديث الألوان للنظام الجديد (يُستخدم في applyInstantThemeUpdate)
    func updateInstantThemeColors() {
        guard let parameters = getLabelColorParameters() else { return }
        
        // تحديث لون النص
        self.textColor = ThemeManager.shared.color(parameters.textColorSet)
        
        // تحديث لون الخلفية إذا كان محدد
        if let backgroundColorSet = parameters.backgroundColorSet {
            self.backgroundColor = ThemeManager.shared.color(backgroundColorSet)
        }
    }
    
    /// تحديث ألوان محددة (استخدام مباشر)
    func updateInstantThemeColors(
        textColorSet: AppColors,
        backgroundColorSet: AppColors? = nil
    ) {
        // تحديث لون النص
        self.textColor = ThemeManager.shared.color(textColorSet)
        
        // تحديث لون الخلفية
        if let backgroundColorSet = backgroundColorSet {
            self.backgroundColor = ThemeManager.shared.color(backgroundColorSet)
        }
    }
    
    // MARK: - ✅ Convenience Methods for Common Use Cases
    
    /// إعداد Label للعناوين الرئيسية
    func setupAsMainTitle(
        text: String,
        colorSet: AppColors = .textColor,
        font: Fonts = .cairo,
        fontStyle: FontStyle = .bold,
        ofSize: Sizes = .size_24,
        direction: Directions = .Center
    ) {
        setupForInstantTheme(
            text: text,
            textColorSet: colorSet,
            font: font,
            fontStyle: fontStyle,
            ofSize: ofSize,
            direction: direction,
            lines: 0
        )
    }
    
    /// إعداد Label للعناوين الفرعية
    func setupAsSubtitle(
        text: String,
        colorSet: AppColors = .textSecond,
        font: Fonts = .poppins,
        fontStyle: FontStyle = .regular,
        ofSize: Sizes = .size_16,
        direction: Directions = .Center,
        numberOfLines: Int = 0
    ) {
        setupForInstantTheme(
            text: text,
            textColorSet: colorSet,
            font: font,
            fontStyle: fontStyle,
            ofSize: ofSize,
            direction: direction,
            lines: numberOfLines
        )
    }
    
    /// إعداد Label للنصوص العادية
    func setupAsBodyText(
        text: String,
        colorSet: AppColors = .text,
        font: Fonts = .poppins,
        fontStyle: FontStyle = .regular,
        ofSize: Sizes = .size_14,
        direction: Directions = .auto,
        numberOfLines: Int = 0
    ) {
        setupForInstantTheme(
            text: text,
            textColorSet: colorSet,
            font: font,
            fontStyle: fontStyle,
            ofSize: ofSize,
            direction: direction,
            lines: numberOfLines
        )
    }
    
    /// إعداد Label للتسميات الصغيرة
    func setupAsCaption(
        text: String,
        colorSet: AppColors = .textSecond,
        font: Fonts = .poppins,
        fontStyle: FontStyle = .regular,
        ofSize: Sizes = .size_12,
        direction: Directions = .auto
    ) {
        setupForInstantTheme(
            text: text,
            textColorSet: colorSet,
            font: font,
            fontStyle: fontStyle,
            ofSize: ofSize,
            direction: direction,
            lines: 1
        )
    }
    
    // MARK: - ✅ Migration Support (للتوافق مع الكود القديم)
    
    /// مساعد للانتقال من النظام القديم للجديد
    @available(*, deprecated, message: "استخدم setupForInstantTheme بدلاً من هذه الطريقة")
    func customize(
        text: String? = nil,
        color: AppColors,
        ofSize: Sizes,
        font: Fonts,
        fontStyle: FontStyle = .regular,
        direction: Directions = .auto,
        lines: Int = 1,
        adjustsFontSizeToFitWidth: Bool = false
    ) {
        // تحويل للنظام الجديد
        setupForInstantTheme(
            text: text,
            textColorSet: color,
            font: font,
            fontStyle: fontStyle,
            ofSize: ofSize,
            direction: direction,
            lines: lines,
            adjustsFontSizeToFitWidth: adjustsFontSizeToFitWidth
        )
    }
    
    /// نفس الدالة القديمة لكن محدثة (للتوافق)
    @available(*, deprecated, message: "هذه الدالة مطابقة لـ customize - استخدم setupForInstantTheme")
    func customizeWithColor(
        text: String? = nil,
        color: AppColors,
        ofSize: Sizes,
        font: Fonts,
        fontStyle: FontStyle = .regular,
        direction: Directions = .auto,
        lines: Int = 1,
        adjustsFontSizeToFitWidth: Bool = false
    ) {
        // استدعاء النسخة الجديدة
        setupForInstantTheme(
            text: text,
            textColorSet: color,
            font: font,
            fontStyle: fontStyle,
            ofSize: ofSize,
            direction: direction,
            lines: lines,
            adjustsFontSizeToFitWidth: adjustsFontSizeToFitWidth
        )
    }
    
    // MARK: - ✅ Animation Methods (محسّنة)
    
    /// تأثير انتقالي لتغيير النص مع تأثير fade
    func animateTextChange(
        to newText: String,
        duration: TimeInterval = 0.3,
        delay: TimeInterval = 0,
        completion: (() -> Void)? = nil
    ) {
        UIView.transition(
            with: self,
            duration: duration,
            options: .transitionCrossDissolve,
            animations: {
                self.text = newText
            },
            completion: { _ in
                completion?()
            }
        )
    }
    
    /// تأثير انتقالي لتغيير النص واللون معاً
    func animateTextAndColorChange(
        to newText: String,
        colorSet: AppColors,
        duration: TimeInterval = 0.3,
        delay: TimeInterval = 0,
        completion: (() -> Void)? = nil
    ) {
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: .curveEaseInOut,
            animations: {
                self.text = newText
                self.textColor = ThemeManager.shared.color(colorSet)
            },
            completion: { _ in
                completion?()
            }
        )
    }
    
    /// تأثير نابض للنص
    func pulseAnimation(duration: TimeInterval = 0.6) {
        UIView.animate(
            withDuration: duration/2,
            animations: {
                self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                self.alpha = 0.7
            },
            completion: { _ in
                UIView.animate(withDuration: duration/2) {
                    self.transform = CGAffineTransform.identity
                    self.alpha = 1.0
                }
            }
        )
    }
}

// MARK: - ✅ Internal Color Parameters Management

extension UILabel {
    
    /// معاملات الألوان للـ Label
    private struct LabelColorParameters {
        let textColorSet: AppColors
        let backgroundColorSet: AppColors?
    }
    
    /// حفظ معاملات الألوان
    private func saveLabelColorParameters(
        textColorSet: AppColors,
        backgroundColorSet: AppColors?
    ) {
        let parameters = LabelColorParameters(
            textColorSet: textColorSet,
            backgroundColorSet: backgroundColorSet
        )
        
        objc_setAssociatedObject(
            self,
            &AssociatedKeys.labelColorParameters,
            parameters,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
    }
    
    /// الحصول على معاملات الألوان المحفوظة
    private func getLabelColorParameters() -> LabelColorParameters? {
        return objc_getAssociatedObject(
            self,
            &AssociatedKeys.labelColorParameters
        ) as? LabelColorParameters
    }
}

