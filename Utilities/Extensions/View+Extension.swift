
import UIKit

extension UIView {
        
        /// تحديث الألوان في العنصر
        func updateColors() {
            // يمكن تنفيذ منطق لتحديث ألوان العنصر هنا
            setNeedsDisplay()
            
            // تحديث العناصر الفرعية
            subviews.forEach { $0.updateColors() }
        }
        
        /// تعيين لون الخلفية مع دعم السمات
        /// تعيين لون الخلفية مع دعم السمات
        func setThemeBackgroundColor(_ colorSet: AppColors) {
            // إلغاء المراقب السابق إذا وجد
            removeThemeObserver(forKey: &AssociatedKeys.backgroundThemeObserver)
            
            // تعيين اللون الحالي
            backgroundColor = ThemeManager.shared.color(colorSet)
            
            // إضافة مراقب جديد
            let observer = ThemeManager.shared.addThemeObserver { [weak self] in
                self?.backgroundColor = ThemeManager.shared.color(colorSet)
            }
            
            // تخزين المعرف مع العنصر
            setThemeObserver(id: observer, forKey: &AssociatedKeys.backgroundThemeObserver)
}
 

        /// تعيين لون الحدود مع دعم السمات
        func setThemeBorderColor(_ colorSet: AppColors, width: CGFloat = 1.0) {
            // إلغاء المراقب السابق إذا وجد
            removeThemeObserver(forKey: &AssociatedKeys.borderThemeObserver)
            
            // تعيين اللون والعرض الحالي
            layer.borderColor = ThemeManager.shared.color(colorSet).cgColor
            layer.borderWidth = width
            
            // إضافة مراقب جديد
            let observer = ThemeManager.shared.addThemeObserver { [weak self] in
                self?.layer.borderColor = ThemeManager.shared.color(colorSet).cgColor
            }
            
            // تخزين المعرف مع العنصر
            setThemeObserver(id: observer, forKey: &AssociatedKeys.borderThemeObserver)
        }
        
        /// تعيين لون التلوين مع دعم السمات
        func setThemeTintColor(_ colorSet: AppColors) {
            // إلغاء المراقب السابق إذا وجد
            removeThemeObserver(forKey: &AssociatedKeys.tintColorThemeObserver)
            
            // تعيين اللون الحالي
            tintColor = ThemeManager.shared.color(colorSet)
            
            // إضافة مراقب جديد
            let observer = ThemeManager.shared.addThemeObserver { [weak self] in
                self?.tintColor = ThemeManager.shared.color(colorSet)
            }
            
            // تخزين المعرف مع العنصر
            setThemeObserver(id: observer, forKey: &AssociatedKeys.tintColorThemeObserver)
        }
        
        /// إضافة ظل متوافق مع السمة
        func setThemeShadow(colorSet: AppColors = .shadow, radius: CGFloat = 4.0, opacity: Float = 0.15, offset: CGSize = CGSize(width: 0, height: 2)) {
            // إلغاء المراقب السابق إذا وجد
            removeThemeObserver(forKey: &AssociatedKeys.shadowThemeObserver)
            
            // تعيين إعدادات الظل الحالية
            layer.shadowColor = ThemeManager.shared.color(colorSet).cgColor
            layer.shadowRadius = radius
            layer.shadowOpacity = opacity
            layer.shadowOffset = offset
            
            // إضافة مراقب جديد
            let observer = ThemeManager.shared.addThemeObserver { [weak self] in
                self?.layer.shadowColor = ThemeManager.shared.color(colorSet).cgColor
            }
            
            // تخزين المعرف مع العنصر
            setThemeObserver(id: observer, forKey: &AssociatedKeys.shadowThemeObserver)
        }
        
        /// إضافة زوايا منحنية
        func addRadius(_ cornerRadius: CGFloat) {
            self.layer.cornerRadius = cornerRadius
            self.clipsToBounds = cornerRadius > 0
        }
        
        /// إضافة تدرج خطي للخلفية باستخدام لونين أو أكثر
        func applyGradient(colors: [AppColors], direction: GradientDirection = .horizontal, locations: [NSNumber]? = nil) {
            // إزالة أي طبقة تدرج موجودة مسبقاً
            self.layer.sublayers?.filter { $0.name == "gradientLayer" }.forEach { $0.removeFromSuperlayer() }
            
            // تحويل الألوان من enum إلى UIColor
            let uiColors = colors.map { ThemeManager.shared.color($0) }
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
            
            // إضافة مراقب لتحديث التدرج عند تغيير السمة
            let observer = ThemeManager.shared.addThemeObserver { [weak self] in
                guard let self = self else { return }
                
                // إزالة التدرج السابق
                self.layer.sublayers?.filter { $0.name == "gradientLayer" }.forEach { $0.removeFromSuperlayer() }
                
                // تحويل الألوان من enum إلى UIColor بناءً على السمة الحالية
                let updatedColors = colors.map { ThemeManager.shared.color($0) }
                
                // إنشاء طبقة تدرج جديدة
                let newGradientLayer = CAGradientLayer()
                newGradientLayer.name = "gradientLayer"
                newGradientLayer.frame = self.bounds
                newGradientLayer.colors = updatedColors.map { $0.cgColor }
                
                if let locations = locations {
                    newGradientLayer.locations = locations
                }
                
                // تعيين اتجاه التدرج
                switch direction {
                case .horizontal:
                    newGradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
                    newGradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
                case .vertical:
                    newGradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
                    newGradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
                case .diagonalTopLeftToBottomRight:
                    newGradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
                    newGradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
                case .diagonalTopRightToBottomLeft:
                    newGradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
                    newGradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
                case .custom(let startPoint, let endPoint):
                    newGradientLayer.startPoint = startPoint
                    newGradientLayer.endPoint = endPoint
                }
                
                // إضافة طبقة التدرج للعرض
                self.layer.insertSublayer(newGradientLayer, at: 0)
            }
            
            // تخزين المعرف مع العنصر - يمكن استخدام backgroundThemeObserver نفسه
            setThemeObserver(id: observer, forKey: &AssociatedKeys.backgroundThemeObserver)
        }

        
        /// إضافة تدرج باستخدام ألوان GradientColors محددة مسبقاً
        ///
        /// - Parameters:
        ///   - startColor: لون بداية التدرج
        ///   - endColor: لون نهاية التدرج
        ///   - direction: اتجاه التدرج
        ///   - locations: مواقع الألوان (اختياري)
        ///   - alpha: شفافية الألوان (اختياري)
        ///   - respectedDarkMode: هل يجب تعديل الألوان في الوضع الداكن (اختياري)
        func applyGradient(startColor: GradientColors, endColor: GradientColors,
                           direction: GradientDirection = .horizontal,
                           locations: [NSNumber]? = nil,
                           alpha: CGFloat = 1.0,
                           respectDarkMode: Bool = true) {
            
            // إزالة أي طبقة تدرج موجودة مسبقاً
            self.layer.sublayers?.filter { $0.name == "gradientLayer" }.forEach { $0.removeFromSuperlayer() }
            
            // تحديد هل نحن في الوضع الداكن
            let isDarkMode = ThemeManager.shared.isDarkModeActive && respectDarkMode
            
            // الحصول على ألوان التدرج مع مراعاة وضع العرض
            let startUIColor = startColor.colorWithAppearance(alpha: alpha, darkMode: isDarkMode)
            let endUIColor = endColor.colorWithAppearance(alpha: alpha, darkMode: isDarkMode)
            
            // إنشاء طبقة التدرج
            let gradientLayer = CAGradientLayer()
            gradientLayer.name = "gradientLayer"
            gradientLayer.frame = self.bounds
            
            // تعيين الألوان والتوزيع
            gradientLayer.colors = [startUIColor.cgColor, endUIColor.cgColor]
            
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
            
            // ضبط أبعاد طبقة التدرج عند تغيير حجم العرض
            self.layoutIfNeeded()
            
            // إضافة مراقب لتحديث التدرج عند تغيير السمة
            let observer = ThemeManager.shared.addThemeObserver { [weak self, startColor, endColor, direction, locations, alpha, respectDarkMode] in
                guard let self = self else { return }
                
                // إعادة تطبيق التدرج مع الألوان المحدثة
                self.reapplyGradient(startColor: startColor, endColor: endColor, direction: direction,
                                    locations: locations, alpha: alpha, respectDarkMode: respectDarkMode)
            }
            
            // تخزين المعرف مع العنصر
            setThemeObserver(id: observer, forKey: &AssociatedKeys.backgroundThemeObserver)
        }


        /// إعادة تطبيق التدرج مع الألوان المحدثة (دالة مساعدة داخلية)
        private func reapplyGradient(startColor: GradientColors, endColor: GradientColors,
                                   direction: GradientDirection,
                                   locations: [NSNumber]? = nil,
                                   alpha: CGFloat = 1.0,
                                   respectDarkMode: Bool = true) {
            
            // إزالة التدرج السابق
            self.layer.sublayers?.filter { $0.name == "gradientLayer" }.forEach { $0.removeFromSuperlayer() }
            
            // تحديد هل نحن في الوضع الداكن
            let isDarkMode = ThemeManager.shared.isDarkModeActive && respectDarkMode
            
            // الحصول على ألوان التدرج مع مراعاة وضع العرض
            let startUIColor = startColor.colorWithAppearance(alpha: alpha, darkMode: isDarkMode)
            let endUIColor = endColor.colorWithAppearance(alpha: alpha, darkMode: isDarkMode)
            
            // إنشاء طبقة تدرج جديدة
            let newGradientLayer = CAGradientLayer()
            newGradientLayer.name = "gradientLayer"
            newGradientLayer.frame = self.bounds
            
            // تعيين الألوان والتوزيع
            newGradientLayer.colors = [startUIColor.cgColor, endUIColor.cgColor]
            
            if let locations = locations {
                newGradientLayer.locations = locations
            }
            
            // تعيين اتجاه التدرج
            switch direction {
            case .horizontal:
                newGradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
                newGradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            case .vertical:
                newGradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
                newGradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
            case .diagonalTopLeftToBottomRight:
                newGradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
                newGradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
            case .diagonalTopRightToBottomLeft:
                newGradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
                newGradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
            case .custom(let startPoint, let endPoint):
                newGradientLayer.startPoint = startPoint
                newGradientLayer.endPoint = endPoint
            }
            
            // إضافة طبقة التدرج للعرض
            self.layer.insertSublayer(newGradientLayer, at: 0)
        }

}
