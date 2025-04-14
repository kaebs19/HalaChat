

import UIKit

extension UILabel {
    
    // تطبيق لون النص المتوافق مع السمة
       func setThemeTextColor(_ colorSet: ColorSet) {
           // إلغاء المراقب السابق إذا وجد
           removeThemeObserver(forKey: &AssociatedKeys.themeObserver)
           
           // تعيين اللون الحالي
           textColor = ThemeManager.shared.color(colorSet)
           
           // إضافة مراقب جديد
           let observer = ThemeManager.shared.addThemeObserver { [weak self]  in
               self?.textColor = ThemeManager.shared.color(colorSet)
           }
           
           // تخزين المعرف مع العنصر
           setThemeObserver(id: observer, forKey: &AssociatedKeys.themeObserver)

       }
    
    /// دالة تخصيص نصوص  - UILable
    func customize(text: String? , colorSet: ColorSet ,ofSize: Sizes ,
                   font: Fonts , fontStyle: FontStyle = .regular , direction: Directions = .auto,
                   lines: Int = 1 , adjustsFontSizeToFitWidth: Bool = false)
            {
                
                self.text = text ?? ""
                self.setThemeTextColor(colorSet)
                self.font = FontManager.shared.font(family: font, style: fontStyle, size: ofSize)
                
                self.textAlignment = direction.textAlignment
                self.numberOfLines = lines
                self.adjustsFontForContentSizeCategory = adjustsFontSizeToFitWidth
            }
    
    /// Adds a fade-in animation to the label
    func animateTextChange(to newText: String, duration: TimeInterval = 0.3) {
        UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve, animations: {
            self.text = newText
        }, completion: nil)
    }

    /// تأثير انتقالي لتغيير النص
    func animateTextChange(to newText: String, withDuration duration: TimeInterval = 0.3, delay: TimeInterval = 0) {
        
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseInOut, animations: {
            self.text = newText
        }, completion: nil)
    }

}
