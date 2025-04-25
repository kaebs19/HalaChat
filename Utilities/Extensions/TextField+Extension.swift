
import UIKit


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
    func customize(placeholder: String? = nil,
               text: String? = nil,
               textColor: AppColors,
               placeholderColor: AppColors? = nil,
               backgroundColor: AppColors? = nil,
               borderColor: AppColors? = nil,
               cornerRadius: CGFloat = 0,
               borderWidth: CGFloat = 0,
               font: UIFont? = nil,
               padding: UIEdgeInsets? = nil) {
        
        // تعيين النص والنص الافتراضي
        self.text = text
        if let placeholder = placeholder {
            self.placeholder = placeholder
        }
        
        // تعيين لون النص
        setThemeTextColor(textColor)
        
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
            self.font = font
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

}
