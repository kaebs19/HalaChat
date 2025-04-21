
import UIKit

extension UIButton {
    
    // تطبيق لون النص والخلفية المتوافق مع السمة
    func setThemeTitleColor(_ colorSet: ColorSet , for state: UIControl.State = .normal) {
        
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
    
    
    
    /// تخصيص النص في Button
    func customize(title: Buttons? = nil,
                   titleColorSet:ColorSet, backgroundColorSet:ColorSet? = nil,
                   ofSize: Sizes,
                   font: Fonts , fontStyle: FontStyle = .regular,
                   state: UIControl.State = .normal
                   
    ) {
        if let title = title {
            self.setTitle(title.textBtn, for: state)
        }
        self.setThemeTitleColor(titleColorSet, for: state)
        
        if let backgroundColorSet = backgroundColorSet {
            self.setThemeBackgroundColor(backgroundColorSet)
        }
        
        
        self.titleLabel?.font = FontManager.shared.font(family: font, style: fontStyle , size: ofSize)
    }
    
    // إضافة تأثير ضغط للزر
    
    func addPressAnimation() {
        addTarget(self, action: #selector(buttonPressed), for: .touchDown)
        addTarget(self, action: #selector(buttonReleased), for: [.touchUpInside , .touchUpOutside , .touchCancel])
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
    
    /// اظافة زوايا منحنية الاطراف
    func addRadisButton(cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
    }
    
    /// تخصيص النص في Button باستخدام ألوان مخصصة من نوع UIColor
    /// - Parameters:
    ///   - title: نص الزر (اختياري)
    ///   - titleColor: لون النص مباشرة (UIColor)
    ///   - backgroundColor: لون الخلفية مباشرة (UIColor) (اختياري)
    ///   - ofSize: حجم الخط
    ///   - font: نوع الخط
    ///   - fontStyle: نمط الخط (القيمة الافتراضية: .regular)
    ///   - state: حالة الزر (القيمة الافتراضية: .normal)
    
    func customizeWithColor(title: Buttons? = nil,
                            titleColor: UIColor,
                            backgroundColor: UIColor? = nil,
                            ofSize: Sizes,
                            font: Fonts ,
                            fontStyle: FontStyle = .regular,
                            state: UIControl.State = .normal
    ) {
        // تعيين النص إذا تم تمريره
        if let title = title {
            self.setTitle(title.textBtn, for: state)
        }
        
        // تعيين لون النص
        self.setTitleColor(titleColor, for: state)
        
        // تعيين لون الخلفية إذا تم تمريره
        if let backgroundColor = backgroundColor {
            self.backgroundColor = backgroundColor
        }
        
        self.titleLabel?.font = FontManager.shared.font(family: font, style: fontStyle, size: ofSize)
    }
    
    /// تخصيص النص في Button مع دعم مزدوج للألوان (من نظام السمات أو مباشرة)
    /// - Parameters:
    ///   - title: نص الزر (اختياري)
    ///   - titleColor: لون النص مباشرة (UIColor) (اختياري)
    ///   - titleColorSet: لون النص من نظام السمات (اختياري)
    ///   - backgroundColor: لون الخلفية مباشرة (UIColor) (اختياري)
    ///   - backgroundColorSet: لون الخلفية من نظام السمات (اختياري)
    ///   - ofSize: حجم الخط
    ///   - font: نوع الخط
    ///   - fontStyle: نمط الخط (القيمة الافتراضية: .regular)
    ///   - state: حالة الزر (القيمة الافتراضية: .normal)
    func customizeFlexible(
            title: Buttons? = nil,
            titleColor: UIColor? = nil,
            titleColorSet: ColorSet? = nil,
            backgroundColor: UIColor? = nil,
            backgroundColorSet: ColorSet? = nil,
            ofSize: Sizes,
            font: Fonts,
            fontStyle: FontStyle = .regular,
            state: UIControl.State = .normal
        ) {
            // تعيين النص إذا تم تمريره
            if let title = title {
                self.setTitle(title.textBtn, for: state)
            }
            
            // تعيين لون النص (الأولوية للون المباشر، ثم نظام السمات)
            if let color = titleColor {
                self.setTitleColor(color, for: state)
            } else if let colorSet = titleColorSet {
                self.setThemeTitleColor(colorSet, for: state)
            }
            
            // تعيين لون الخلفية (الأولوية للون المباشر، ثم نظام السمات)
            if let bgColor = backgroundColor {
                self.backgroundColor = bgColor
            } else if let bgColorSet = backgroundColorSet {
                self.setThemeBackgroundColor(bgColorSet)
            }
            
            // تعيين الخط
            self.titleLabel?.font = FontManager.shared.font(family: font, style: fontStyle, size: ofSize)
        }
    
}
