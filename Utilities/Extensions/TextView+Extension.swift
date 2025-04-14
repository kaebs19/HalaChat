

import UIKit


extension UITextView {
    
    
    // تطبيق لون النص المتوافق مع السمة
    // تطبيق لون النص المتوافق مع السمة
    func setThemeTextColor(_ colorSet: ColorSet) {
        // إلغاء المراقب السابق إذا وجد
        removeThemeObserver(forKey: &AssociatedKeys.themeObserver)
        
        // تعيين اللون الحالي
        textColor = ThemeManager.shared.color(colorSet)
        
        // إضافة مراقب جديد
        let observerId = ThemeManager.shared.addThemeObserver { [weak self] in
            self?.textColor = ThemeManager.shared.color(colorSet)
        }
        
        // تخزين المعرف مع العنصر
        setThemeObserver(id: observerId, forKey: &AssociatedKeys.themeObserver)
    }

    
    /// تخصيص النص في - TextView
    
    func customize(
    text: TextViews? = nil,
    textColorSet: ColorSet , backgroundColorSet: ColorSet? = nil,
    family: Fonts,
    style: FontStyle = .regular,
    size: Sizes,
    color: UIColor = .black,
    direction: Directions = .Normal
    ) {
        
        self.text = text?.textTV ?? self.text
        self.setThemeTextColor(textColorSet)
        
        if let backgroundColorSet = backgroundColorSet {
            self.backgroundColor = ThemeManager.shared.color(backgroundColorSet)
        }
        
        self.font = FontManager.shared.font(family: family, style: style, size: size)
        self.textAlignment = direction.textAlignment
    }
    
    

    
}
