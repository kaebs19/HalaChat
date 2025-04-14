
import UIKit


extension UITextField {
    
    
    // تطبيق لون النص والخلفية المتوافق مع السمة
    
    func setThemeTextColor(_ setColor: ColorSet) {
        // تطبيق لون النص المتوافق مع السمة
        removeThemeObserver(forKey: &AssociatedKeys.themeObserver)
        
        // تعيين اللون الحالي
        textColor = ThemeManager.shared.color(setColor)
        
        // إضافة مراقب جديد
        let observer = ThemeManager.shared.addThemeObserver { [weak self] in
            self?.textColor = ThemeManager.shared.color(setColor)
        }
        
        // تخزين المعرف مع العنصر
        setThemeObserver(id: observer, forKey: &AssociatedKeys.themeObserver)

    }
    
    
    
    func setThemePlaceholderColor(_ colorSet: ColorSet) {

        // إلغاء المراقب السابق إذا وجد
        removeThemeObserver(forKey: &AssociatedKeys.placeholderThemeObserver)
        
        if let placeholder = self.placeholder {
            let font = self.font ?? UIFont.systemFont(ofSize: 14)
            
            attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [
                    NSAttributedString.Key.foregroundColor: ThemeManager.shared.color(colorSet),
                    NSAttributedString.Key.font: font
                ]
                )
            
            // إضافة مراقب جديد
            let observer = ThemeManager.shared.addThemeObserver { [weak self] in
                if let placeholder = self?.placeholder , let font = self?.font {
                    self?.attributedPlaceholder = NSAttributedString(
                        string: placeholder,
                        attributes: [
                            NSAttributedString.Key.foregroundColor: ThemeManager.shared.color(colorSet),
                            NSAttributedString.Key.font: font
                        ])
                }
                
            }
            
            // تخزين المعرف مع العنصر
            setThemeObserver(id: observer, forKey: &AssociatedKeys.placeholderThemeObserver)

        }
    }

    /// تخصيص النص في - TextFields
    func customize(text: TextFields? = nil, placeholder: String? = nil,
    textColorSet: ColorSet, placeholderColorSet: ColorSet? = nil, backgroundColorSet: ColorSet? = nil ,
                   ofSize: Sizes,
                   font: Fonts , fontStyle: FontStyle = .regular ,
                   directionL: Directions = .auto
    ) {
        self.text = text?.textTF ?? self.text
        if let placeholder = placeholder {
            self.placeholder = placeholder
            self.setThemePlaceholderColor(placeholderColorSet ?? .text)
        }
        
        self.setThemeTextColor(textColorSet)
        
        if let backgroundColorSet =  backgroundColorSet {
            self.setThemePlaceholderColor(backgroundColorSet)
        }
        
        self.font = FontManager.shared.font(family: font, style: fontStyle, size: ofSize)
        self.textAlignment = directionL.textAlignment
    }
    
    
 
}
