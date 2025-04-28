
import UIKit
import SkyFloatingLabelTextField

extension UITextField {
    
    
    /// تعيين لون النص مع دعم السمات
    func setThemeTextColor(_ colorSet: AppColors) {
        // إلغاء المراقب السابق إذا وجد
        removeThemeObserver(forKey: &AssociatedKeys.textColorThemeObserver)
        
        // تعيين اللون الحالي
        textColor = ThemeManager.shared.color(colorSet)
        
        // إضافة مراقب جديد
        let observer = ThemeManager.shared.addThemeObserver { [weak self] in
            self?.textColor = ThemeManager.shared.color(colorSet)
        }
        
        // تخزين المعرف مع العنصر
        setThemeObserver(id: observer, forKey: &AssociatedKeys.textColorThemeObserver)
    }
    
    /// تعيين لون النص الافتراضي مع دعم السمات
    func setThemePlaceholderColor(_ colorSet: AppColors) {
        // إلغاء المراقب السابق إذا وجد
        removeThemeObserver(forKey: &AssociatedKeys.placeholderThemeObserver)
        
        // تحديث النص الافتراضي
        updatePlaceholderColor(ThemeManager.shared.color(colorSet))
        
        // إضافة مراقب جديد
        let observer = ThemeManager.shared.addThemeObserver { [weak self] in
            self?.updatePlaceholderColor(ThemeManager.shared.color(colorSet))
        }
        
        // تخزين المعرف مع العنصر
        setThemeObserver(id: observer, forKey: &AssociatedKeys.placeholderThemeObserver)
    }
    
    /// تحديث لون النص الافتراضي
    private func updatePlaceholderColor(_ color: UIColor) {
        if let placeholder = placeholder {
            attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [NSAttributedString.Key.foregroundColor: color]
            )
        }
    }

    

    /// تخصيص النص في - TextFields
    /// إعداد حقل النص بالكامل
    func customize(placeholder: TextFields? = nil,
               text: String? = nil,
               textColor: AppColors? = nil,
               placeholderColor: AppColors? = nil,
               backgroundColor: AppColors? = nil,
               borderColor: AppColors? = nil,
               cornerRadius: CGFloat = 0,
               borderWidth: CGFloat = 0,
               font: Fonts? = nil,
                   ofSize: Sizes? = nil,
                   fontStyle: FontStyle? = nil,
               padding: UIEdgeInsets? = nil,
                   direction: Directions? = nil
    ) {
        
        // تعيين النص والنص الافتراضي
        self.text = text
        if let placeholder = placeholder {
            self.placeholder = placeholder.textTF
        }
        
        // تعيين لون النص
        setThemeTextColor(textColor ?? .text )
        
        // تعيين لون النص الافتراضي
        if let placeholderColor = placeholderColor {
            setThemePlaceholderColor(placeholderColor)
        }
        
        // تعيين لون الخلفية
        if let backgroundColor = backgroundColor {
            setThemeBackgroundColor(backgroundColor)
        }
        
        // تعيين الحدود
        if let borderColor = borderColor, borderWidth > 0 {
            setThemeBorderColor(borderColor, width: borderWidth)
        }
        
        // تعيين الزوايا المنحنية
        if cornerRadius > 0 {
            addRadius(cornerRadius)
        }
        
        // تعيين الخط
        if let font = font {
            self.font = UIFont(name: font.name, size: ofSize?.rawValue ?? 0)
        }
        
        // تعيين اتجاه النص

        if let direction = direction {
            self.textAlignment = direction.textAlignment
        }
        
        // تعيين الهوامش الداخلية
        if let padding = padding {
            let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding.left, height: bounds.height))
            leftView = leftPaddingView
            leftViewMode = .always
            
            let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding.right, height: bounds.height))
            rightView = rightPaddingView
            rightViewMode = .always
        }
    }
    

 
    func customizePlaeholder(plaeholder: TextFields
                         , placeholderColor: AppColors? = .text ,
                         font: Fonts? = .poppins , fontStyle: FontStyle = .regular,
                         ofSize: Sizes = .size_16,
                         direction: Directions = .auto ) {
        
        // تعيين Placeholder مع اللون والنص
        let plaeholderText = plaeholder.textTF ?? ""
        self.attributedPlaceholder = NSAttributedString(
            string: plaeholderText,
            attributes: [
                .foregroundColor: placeholderColor?.color ?? AppColors.text.color
        ])
        
        // تعيين الخط
        self.font = UIFont(name: font?.name ?? Fonts.poppins.name, size: ofSize.rawValue)
        // تعيين اتجاه النص
        self.textAlignment = direction.textAlignment
        
    }
    
    func customizeText(text: String? = nil,
                       textColor: AppColors? = .text , font: Fonts = .poppins ,
                       fontStyle: FontStyle = .regular,
                       ofSize: Sizes = .size_16,
                       direction: Directions = .auto
    ) {
        // تعيين النص إذا توفر

        if let text = text {
            self.text = text
        }
        // تعيين لون النص

        self.textColor = textColor?.color ?? AppColors.text.color
        
        // تعيين الخط
        self.font = UIFont(name: font.rawValue, size: ofSize.rawValue) ?? UIFont.systemFont(ofSize: ofSize.rawValue, weight: fontStyle.uiFontWeight)
        // تعيين اتجاه النص
        self.textAlignment = direction.textAlignment
    }
}
