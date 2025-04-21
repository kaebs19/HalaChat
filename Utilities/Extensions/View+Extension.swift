

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
                   
    
    /// إضافة تدرج خطي للخلفية باستخدام لونين أو أكثر
    /// - Parameters:
    ///   - colors: مصفوفة من الألوان من نوع Colors enum
    ///   - direction: اتجاه التدرج (أفقي، عمودي، قطري، إلخ)
    ///   - locations: مواقع الألوان في التدرج (اختياري)

    func applyGradient(colors: [Colors], direction: GradientDirection = .horizontal, locations: [NSNumber]? = nil) {
        // إزالة أي طبقة تدرج موجودة مسبقاً
           self.layer.sublayers?.filter { $0.name == "gradientLayer" }.forEach { $0.removeFromSuperlayer() }
           
           // تحويل الألوان من enum إلى UIColor
           let uiColors = colors.compactMap { $0.uitColor }
           guard !uiColors.isEmpty else { return }
           
           // إنشاء طبقة التدرج
           let gradientLayer = CAGradientLayer()
           gradientLayer.name = "gradientLayer"
           gradientLayer.frame = self.bounds
           
           // تعيين الألوان
           gradientLayer.colors = uiColors.map { $0.cgColor }
           
           // تعيين مواقع الألوان إذا تم تمريرها
           if let locations = locations {
               gradientLayer.locations = locations
           }
           
           // تعيين اتجاه التدرج
           switch direction {
           case .horizontal:
               gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
               gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
           case .vertical:
               gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
               gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
           case .diagonalTopLeftToBottomRight:
               gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
               gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
           case .diagonalTopRightToBottomLeft:
               gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
               gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
           case .custom(let startPoint, let endPoint):
               gradientLayer.startPoint = startPoint
               gradientLayer.endPoint = endPoint
           }
           
           // إضافة طبقة التدرج للعرض
           self.layer.insertSublayer(gradientLayer, at: 0)
           
           // ربط التدرج بتغيير حجم العرض
           self.layer.layoutIfNeeded()
    }
    
    func addRadius(cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
    }


}
