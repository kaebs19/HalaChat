

import UIKit

extension UIView {
  
    // تطبيق لون الخلفية المتوافق مع السمة
    func setThemeBackground(_ colorSet:ColorSet) {
        // إلغاء المراقب السابق
        removeThemeObserver(forKey: &AssociatedKeys.backgroundThemeObserver)
            
        // تعيين اللون الحالي
        backgroundColor = ThemeManager.shared.color(colorSet)
   
        // إضافة مراقب جديد
        let observerId = ThemeManager.shared.addThemeObserver { [weak self] in
            self?.backgroundColor = ThemeManager.shared.color(colorSet)
        }
        
        // تخزين المعرف مع العنصر
        setThemeObserver(id: observerId, forKey: &AssociatedKeys.backgroundThemeObserver)
    }
    
    // إضافة دالة بديلة بنفس المعنى لتوحيد التسمية مع الامتدادات الأخرى
    func setThemeBackgroundColor(_ colorSet: ColorSet) {
        setThemeBackground(colorSet)
    }
    
    
    // إضافة ظل متوافق مع السمة
    func addShadow(colorSet: ColorSet = .shadow
                   , radius: CGFloat = 4.0 , opacity: Float = 0.15,
                   offset: CGSize = CGSize(width: 0, height: 2)
    ) {
        self.layer.shadowColor = ThemeManager.shared.color(colorSet).cgColor
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        
        // إضافة مراقب للتحديث عند تغيير السمة
        let observerId = ThemeManager.shared.addThemeObserver { [weak self] in
            self?.layer.shadowColor = ThemeManager.shared.color(colorSet).cgColor
        }
        
        // تخزين المعرف مع العنصر
        setThemeObserver(id: observerId, forKey: &AssociatedKeys.borderThemeObserver)
    }
    
    // تطبيق لون الحدود المتوافق مع السمة
    func addBorder(_ colorSet: ColorSet, width: CGFloat = 1.0) {
        // إلغاء المراقب السابق
        removeThemeObserver(forKey: &AssociatedKeys.borderThemeObserver)
        
        self.layer.borderColor = ThemeManager.shared.color(colorSet).cgColor
        self.layer.borderWidth = width
        
        // إضافة مراقب جديد
        
        let observer = ThemeManager.shared.addThemeObserver { [weak self]  in
            self?.layer.borderColor = ThemeManager.shared.color(colorSet).cgColor
        }
        
        setThemeObserver(id: observer, forKey: &AssociatedKeys.borderThemeObserver)
    }
                   
    


}
