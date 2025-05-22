
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

extension UIView {
    
    // تعريف الزوايا المختلفة

    enum CornerType {
        case topLeft
        case topRight
        case bottomLeft
        case bottomRight
        case allCorners
        
        var caCorners: CACornerMask {
            switch self {
                case .topLeft:
                    return .layerMinXMinYCorner
                case .topRight:
                    return .layerMaxXMinYCorner
                case .bottomLeft:
                    return .layerMinXMaxYCorner
                case .bottomRight:
                    return .layerMaxXMaxYCorner
                case .allCorners:
                    return [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            }
        }
    }
    
    
    
    /// إضافة انحناء للزوايا المحددة
    /// - Parameters:
    ///   - corners: مصفوفة تحتوي على الزوايا التي سيتم تطبيق الانحناء عليها
    ///   - radius: نصف قطر الانحناء

    func addCorner(corners: [CornerType] , radius: CGFloat) {
        
        self.layer.cornerRadius = radius
        
        var cornerMask: CACornerMask = []
        
        for corner in corners {
            cornerMask.insert(corner.caCorners)
        }
        
        self.layer.maskedCorners = cornerMask
        
        var bezierPath: UIBezierPath?
        
        let topLeft = corners.contains(.topLeft) || corners.contains(.allCorners)
        let topRight = corners.contains(.topRight) || corners.contains(.allCorners)
        let bottomLeft = corners.contains(.bottomLeft) || corners.contains(.allCorners)
        let bottomRight = corners.contains(.bottomRight) || corners.contains(.allCorners)

        
        // إنشاء المسار بناءً على الزوايا المحددة
        let rect = self.bounds
        bezierPath = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: [
                                    topLeft ? .topLeft : [],
                                    topRight ? .topRight : [],
                                    bottomLeft ? .bottomLeft : [],
                                    bottomRight ? .bottomRight : []
                                ],
                                cornerRadii: CGSize(width: radius, height: radius))
        // إنشاء طبقة القناع وتطبيقها
        if let bezierPath = bezierPath {
            let maskLayer = CAShapeLayer()
            maskLayer.path = bezierPath.cgPath
            self.layer.mask = maskLayer
        }
        // تأكد من استخدام clipsToBounds لعرض الانحناءات بشكل صحيح
        self.clipsToBounds = true

    }
    
    /// إضافة انحناء لزاوية واحدة فقط
    /// - Parameters:
    ///   - corner: الزاوية التي سيتم تطبيق الانحناء عليها
    ///   - radius: نصف قطر الانحناء
    func addCorner(corner: CornerType, radius: CGFloat) {
        addCorner(corners: [corner], radius: radius)
    }

    
    func makeCircular() {
        self.layer.cornerRadius = min(self.frame.width , self.frame.height) / 2
        self.layer.masksToBounds = true
    }

}



extension UIView {
    
    // MARK: - تهيئة Container Views
    
    // MARK: - تهيئة Container Views
    
    /// تهيئة شاملة للـ container لتجنب تكرار الكود
    /// - Parameters:
    ///   - color: لون الخلفية من نظام الألوان
    ///   - radius: نصف قطر الزوايا (0 لعدم استخدام زوايا منحنية)
    ///   - corners: الزوايا المراد تطبيق الانحناء عليها (فارغة لتطبيق الانحناء على جميع الزوايا)
    ///   - border: إعدادات الحدود (nil لعدم استخدام حدود)
    ///   - shadow: إعدادات الظل (nil لعدم استخدام ظل)
    ///   - blur: إعدادات تأثير الضبابية (nil لعدم استخدام الضبابية)

    func setupContainerView(withColor color: AppColors = .titleViewBackground,
                            radius: CGFloat = 0,
                            corners: [CornerType] = [],
                            border: (color: AppColors, width: CGFloat)? = nil,
                            shadow: (color: AppColors, opacity: Float, offset: CGSize, radius: CGFloat)? = nil
                            

    ) {
        // 1. تطبيق لون الخلفية
        backgroundColor = color.color
        
        // 2. تطبيق الزوايا المنحنية
        if !corners.isEmpty && radius > 0 {
            // زوايا محددة مع نصف قطر
            addCorner(corners: corners, radius: radius)
        } else if radius > 0 {
            // جميع الزوايا بنفس نصف القطر
            addRadius(radius)
        }
        // 3. تطبيق الحدود إذا تم تحديدها
        if let boarderSettings = border {
            setThemeBorderColor(boarderSettings.color, width: boarderSettings.width)
        }
        
        // 4. تطبيق الظل إذا تم تحديده
        if let shadowSettings = shadow {
                  setThemeShadow(
                      colorSet: shadowSettings.color,
                      radius: shadowSettings.radius,
                      opacity: shadowSettings.opacity,
                      offset: shadowSettings.offset
                  )
              }
        
        // 5. تطبيق تأثير الضبابية إذا تم تحديده
//              if let blurStyle = blur {
//                  applyBlurEffect(style: blurStyle)
//              }
    }
    
    // MARK: - واجهات تهيئة متخصصة للاستخدام الشائع
    
    /// تهيئة container رئيسي للتطبيق
    func setupAnTitleContainer(color: AppColors = .mainBackground) {
        setupContainerView(withColor: color)
    }
    
    /// تهيئة container للمحتوى
    func setupAsContentContainer(color: AppColors = .secondBackground, radius: CGFloat = 0, addShadow: Bool = false) {
        var shadowSettings: (color: AppColors, opacity: Float, offset: CGSize, radius: CGFloat)? = nil
        
        if addShadow {
            shadowSettings = (.shadow, 0.15, CGSize(width: 0, height: 2), 4.0)
        }
        
        setupContainerView(withColor: color, radius: radius, shadow: shadowSettings)
    }
    
    /// تهيئة container للأزرار الدائرية
    func setupAsCircularControl(color: AppColors = .secondBackground) {
        setThemeTintColor(color)
        makeCircular()
    }
    
    /// تهيئة container مع تأثير الضبابية
//    func setupAsBlurContainer(style: UIBlurEffect.Style = .systemMaterial, radius: CGFloat = 0) {
//        setupContainerView(withColor: .clear, radius: radius, blur: style)
//    }
    
    /// تهيئة container للبطاقات (Cards)
    func setupAsCardContainer(color: AppColors = .card, radius: CGFloat = 8, addShadow: Bool = true) {
        var shadowSettings: (color: AppColors, opacity: Float, offset: CGSize, radius: CGFloat)? = nil
        
        if addShadow {
            shadowSettings = (.shadow, 0.1, CGSize(width: 0, height: 2), 4.0)
        }
        
        setupContainerView(withColor: color, radius: radius, shadow: shadowSettings)
    }

}
