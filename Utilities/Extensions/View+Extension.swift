import UIKit
import ObjectiveC


// MARK: - 📐 Basic Layout Methods (طرق التخطيط الأساسية)
extension UIView {
    
    /// إضافة زوايا منحنية لجميع الزوايا
    /// - Parameter cornerRadius: نصف قطر الانحناء
    /// - Note: هذه الطريقة تطبق الانحناء على جميع الزوايا الأربع
    func addRadius(_ cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = cornerRadius > 0
    }
    
    /// إضافة انحناء للزوايا المحددة
    /// - Note: يمكن تحديد زوايا معينة فقط للانحناء (مثل الأعلى فقط)
    func addCorner(corners: [CornerType], radius: CGFloat) {
        self.layer.cornerRadius = radius
        
        var cornerMask: CACornerMask = []
        
        for corner in corners {
            cornerMask.insert(corner.caCorners)
        }
        
        self.layer.maskedCorners = cornerMask
        
        // إنشاء المسار بناءً على الزوايا المحددة
        let rect = self.bounds
        var uiCorners: UIRectCorner = []
        
        for corner in corners {
            uiCorners.insert(corner.uiRectCorner)
        }
        
        let bezierPath = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: uiCorners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        
        // إنشاء طبقة القناع وتطبيقها
        let maskLayer = CAShapeLayer()
        maskLayer.path = bezierPath.cgPath
        self.layer.mask = maskLayer
        
        // تأكد من استخدام clipsToBounds لعرض الانحناءات بشكل صحيح
        self.clipsToBounds = true
    }
    
    /// إضافة انحناء لزاوية واحدة فقط
    /// - Note: اختصار لـ addCorner(corners:radius:) لزاوية واحدة
    func addCorner(corner: CornerType, radius: CGFloat) {
        addCorner(corners: [corner], radius: radius)
    }
    
    /// تحويل العنصر إلى شكل دائري
    /// - Note: يستخدم أصغر بعد (العرض أو الارتفاع) لحساب نصف القطر
    func makeCircular() {
        self.layer.cornerRadius = min(self.frame.width, self.frame.height) / 2
        self.layer.masksToBounds = true
    }
}

// MARK: - 🎨 Instant Theme Setup Methods (إعداد النظام الجديد للمناظر)
extension UIView {
    
    /// إعداد شامل للمنظر مع النظام الجديد
    /// - Note: جميع الألوان ستتحدث تلقائياً عند تغيير السمة
    func setupForInstantTheme(
        backgroundColorSet: AppColors = .clear,
        borderColorSet: AppColors? = nil,
        shadowColorSet: AppColors? = nil,
        cornerRadius: CGFloat = 0,
        borderWidth: CGFloat = 0,
        shadowRadius: CGFloat = 0,
        shadowOffset: CGSize = CGSize(width: 0, height: 2),
        shadowOpacity: Float = 0.1
    ) {
        // 🎨 تطبيق لون الخلفية مباشرة
        backgroundColor = ThemeManager.shared.color(backgroundColorSet)
        
        // 🔸 تطبيق الزوايا المنحنية
        if cornerRadius > 0 {
            addRadius(cornerRadius)
        }
        
        // 🖼️ تطبيق الحدود إذا تم تحديدها
        if let borderColor = borderColorSet, borderWidth > 0 {
            layer.borderColor = ThemeManager.shared.color(borderColor).cgColor
            layer.borderWidth = borderWidth
        }
        
        // 🌫️ تطبيق الظل إذا تم تحديده
        if let shadowColor = shadowColorSet, shadowRadius > 0 {
            layer.shadowColor = ThemeManager.shared.color(shadowColor).cgColor
            layer.shadowRadius = shadowRadius
            layer.shadowOpacity = shadowOpacity
            layer.shadowOffset = shadowOffset
            layer.masksToBounds = false
        }
        
        // 💾 حفظ معاملات التحديث للنظام الجديد
        saveViewParameters(
            backgroundColorSet: backgroundColorSet,
            borderColorSet: borderColorSet,
            shadowColorSet: shadowColorSet,
            borderWidth: borderWidth,
            shadowRadius: shadowRadius,
            shadowOffset: shadowOffset,
            shadowOpacity: shadowOpacity
        )
    }
    
    /// تحديث ألوان المنظر (يُستخدم في applyInstantThemeUpdate)
    /// - Note: إذا لم تحدد معاملات، ستستخدم المعاملات المحفوظة من setupForInstantTheme
    func updateInstantThemeColors(
        backgroundColorSet: AppColors? = nil,
        borderColorSet: AppColors? = nil,
        shadowColorSet: AppColors? = nil
    ) {
        // 📥 استرجاع المعاملات المحفوظة
        guard let parameters = getViewParameters() else {
            return
        }
        
        // 🎨 تحديث لون الخلفية
        let bgColor = backgroundColorSet ?? parameters.backgroundColorSet
        backgroundColor = ThemeManager.shared.color(bgColor)
        
        // 🖼️ تحديث لون الحدود
        if parameters.borderWidth > 0 {
            let borderColor = borderColorSet ?? parameters.borderColorSet
            if let borderColor = borderColor {
                layer.borderColor = ThemeManager.shared.color(borderColor).cgColor
            }
        }
        
        // 🌫️ تحديث لون الظل
        if parameters.shadowRadius > 0 {
            let shadowColor = shadowColorSet ?? parameters.shadowColorSet
            if let shadowColor = shadowColor {
                layer.shadowColor = ThemeManager.shared.color(shadowColor).cgColor
            }
        }
    }
}

// MARK: - 🌈 Gradient Methods (طرق التدرجات)
extension UIView {
    
    /// تطبيق تدرج فوري بدون حفظ المعاملات
    /// - Note: هذه الطريقة تطبق التدرج فوراً بدون حفظ للتحديث التلقائي
    func applyGradientInstant(
        startColor: GradientColors,
        endColor: GradientColors,
        direction: GradientDirection = .horizontal,
        locations: [NSNumber]? = nil,
        alpha: CGFloat = 1.0,
        respectDarkMode: Bool = true
    ) {
        // 🗑️ إزالة طبقات التدرج السابقة
        layer.sublayers?.filter { $0.name == "gradientLayer" }.forEach { $0.removeFromSuperlayer() }
        
        // 🌙 تحديد الوضع الحالي
        let isDarkMode = ThemeManager.shared.isDarkModeActive && respectDarkMode
        
        // 🎨 الحصول على الألوان
        let startUIColor = startColor.colorWithAppearance(alpha: alpha, darkMode: isDarkMode)
        let endUIColor = endColor.colorWithAppearance(alpha: alpha, darkMode: isDarkMode)
        
        // 🎭 إنشاء طبقة التدرج
        let gradientLayer = CAGradientLayer()
        gradientLayer.name = "gradientLayer"
        gradientLayer.frame = bounds
        gradientLayer.colors = [startUIColor.cgColor, endUIColor.cgColor]
        
        if let locations = locations {
            gradientLayer.locations = locations
        }
        
        // 📐 تعيين الاتجاه
        setGradientDirection(gradientLayer, direction: direction)
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    /// تطبيق تدرج مع التحديث التلقائي (الطريقة المفضلة)
    /// - Note: هذه الطريقة تطبق التدرج وتحفظ المعاملات للتحديث التلقائي
    func applyGradient(
        startColor: GradientColors,
        endColor: GradientColors,
        direction: GradientDirection = .horizontal,
        locations: [NSNumber]? = nil,
        alpha: CGFloat = 1.0,
        respectDarkMode: Bool = true
    ) {
        // 🎨 تطبيق التدرج فوراً
        applyGradientInstant(
            startColor: startColor,
            endColor: endColor,
            direction: direction,
            locations: locations,
            alpha: alpha,
            respectDarkMode: respectDarkMode
        )
        
        // 💾 حفظ المعاملات لإعادة التطبيق لاحقاً
        saveGradientParameters(
            startColor: startColor,
            endColor: endColor,
            direction: direction,
            locations: locations,
            alpha: alpha,
            respectDarkMode: respectDarkMode
        )
    }
    
    /// إعادة تطبيق التدرج (يُستخدم في applyInstantThemeUpdate و viewDidLayoutSubviews)
    /// - Note: يستخدم المعاملات المحفوظة من applyGradient
    func reapplyGradient() {
        guard let parameters = getGradientParameters() else {
            return
        }
        
        applyGradientInstant(
            startColor: parameters.startColor,
            endColor: parameters.endColor,
            direction: parameters.direction,
            locations: parameters.locations,
            alpha: parameters.alpha,
            respectDarkMode: parameters.respectDarkMode
        )
    }
    
    /// إزالة التدرج من المنظر
    /// - Note: يزيل طبقة التدرج والمعاملات المحفوظة
    func removeGradient() {
        // 🗑️ إزالة طبقة التدرج
        layer.sublayers?.filter { $0.name == "gradientLayer" }.forEach { $0.removeFromSuperlayer() }
        
        // 🧹 إزالة المعاملات المحفوظة
        objc_setAssociatedObject(self, &AssociatedKeys.gradientParameters, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    /// دالة مساعدة لتعيين اتجاه التدرج
    /// - Parameters:
    ///   - gradientLayer: طبقة التدرج
    ///   - direction: الاتجاه المطلوب
   
    private func setGradientDirection(_ gradientLayer: CAGradientLayer, direction: GradientDirection) {
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
    }

}

// MARK: - 🏗️ Container Setup Methods (طرق إعداد الحاويات)
extension UIView {
    
    /// تهيئة شاملة للحاوية مع النظام الجديد
    /// - Note: جميع الألوان ستتحدث تلقائياً عند تغيير السمة
    func setupContainerView(
        withColor color: AppColors = .titleViewBackground,
        radius: CGFloat = 0,
        corners: [CornerType] = [],
        border: (color: AppColors, width: CGFloat)? = nil,
        shadow: (color: AppColors, opacity: Float, offset: CGSize, radius: CGFloat)? = nil
    ) {
        // 🎨 تطبيق لون الخلفية مباشرة
        backgroundColor = ThemeManager.shared.color(color)
        
        // 🔸 تطبيق الزوايا المنحنية
        if !corners.isEmpty && radius > 0 {
            addCorner(corners: corners, radius: radius)
        } else if radius > 0 {
            addRadius(radius)
        }
        
        // 🖼️ تطبيق الحدود إذا تم تحديدها
        if let borderSettings = border {
            layer.borderColor = ThemeManager.shared.color(borderSettings.color).cgColor
            layer.borderWidth = borderSettings.width
        }
        
        // 🌫️ تطبيق الظل إذا تم تحديده
        if let shadowSettings = shadow {
            layer.shadowColor = ThemeManager.shared.color(shadowSettings.color).cgColor
            layer.shadowRadius = shadowSettings.radius
            layer.shadowOpacity = shadowSettings.opacity
            layer.shadowOffset = shadowSettings.offset
            layer.masksToBounds = false
        }
        
        // 💾 حفظ معاملات التحديث للنظام الجديد
        saveContainerParameters(color: color, border: border, shadow: shadow)
    }
    
    /// تحديث ألوان الحاوية (يُستخدم في applyInstantThemeUpdate)
    /// - Note: يستخدم المعاملات المحفوظة من setupContainerView
    func updateContainerColors() {
        guard let parameters = getContainerParameters() else {
            return
        }
        
        // 🎨 تحديث لون الخلفية
        backgroundColor = ThemeManager.shared.color(parameters.backgroundColor)
        
        // 🖼️ تحديث لون الحدود
        if let border = parameters.border {
            layer.borderColor = ThemeManager.shared.color(border.color).cgColor
        }
        
        // 🌫️ تحديث لون الظل
        if let shadow = parameters.shadow {
            layer.shadowColor = ThemeManager.shared.color(shadow.color).cgColor
        }
    }
}

// MARK: - 🎯 Specialized Container Setup Methods (طرق إعداد متخصصة للحاويات)
extension UIView {
    
    /// تهيئة حاوية رئيسية للتطبيق
    /// - Parameter color: لون الخلفية (افتراضي: .mainBackground)
    /// - Note: للشاشات الرئيسية والخلفيات العامة
    func setupAsTitleContainer(color: AppColors = .mainBackground) {
        setupContainerView(withColor: color)
    }
    
    /// تهيئة حاوية للمحتوى
    /// - Note: للمحتوى الداخلي والأقسام
    func setupAsContentContainer(color: AppColors = .secondBackground, radius: CGFloat = 0, addShadow: Bool = false) {
        var shadowSettings: (color: AppColors, opacity: Float, offset: CGSize, radius: CGFloat)? = nil
        
        if addShadow {
            shadowSettings = (.shadow, 0.15, CGSize(width: 0, height: 2), 4.0)
        }
        
        setupContainerView(withColor: color, radius: radius, shadow: shadowSettings)
    }
    
    /// تهيئة حاوية للبطاقات (Cards)
    /// - Note: للبطاقات والعناصر البارزة
    func setupAsCardContainer(color: AppColors = .card, radius: CGFloat = 8, addShadow: Bool = true) {
        var shadowSettings: (color: AppColors, opacity: Float, offset: CGSize, radius: CGFloat)? = nil
        
        if addShadow {
            shadowSettings = (.shadow, 0.1, CGSize(width: 0, height: 2), 4.0)
        }
        
        setupContainerView(withColor: color, radius: radius, shadow: shadowSettings)
    }
    
    /// تهيئة حاوية دائرية للأزرار والأيقونات
    /// - Warning: يجب استدعاؤها بعد تحديد الأبعاد أو في viewDidLayoutSubviews
    func setupAsCircularControl(color: AppColors = .secondBackground) {
        backgroundColor = ThemeManager.shared.color(color)
        makeCircular()
        
        // 💾 حفظ المعاملات
        saveContainerParameters(color: color, border: nil, shadow: nil)
    }
    
    /// تهيئة حاوية للرأس (Header)
    /// - Note: للرؤوس والعناوين العلوية
    func setupAsHeaderContainer(color: AppColors = .headerBackground, bottomRadius: CGFloat = 16) {
        setupContainerView(
            withColor: color,
            radius: bottomRadius,
            corners: [.bottomLeft, .bottomRight]
        )
    }
    
    /// تهيئة حاوية للذيل (Footer)
    /// - Note: للذيول والعناوين السفلية
    func setupAsFooterContainer(color: AppColors = .headerBackground, topRadius: CGFloat = 16) {
        setupContainerView(
            withColor: color,
            radius: topRadius,
            corners: [.topLeft, .topRight]
        )
    }
}

// MARK: - 💾 Parameters Storage Methods (طرق حفظ المعاملات الداخلية)
extension UIView {
    
    /// حفظ معاملات المنظر لإعادة التطبيق
    /// - Note: للاستخدام الداخلي فقط
    private func saveViewParameters(
        backgroundColorSet: AppColors,
        borderColorSet: AppColors?,
        shadowColorSet: AppColors?,
        borderWidth: CGFloat,
        shadowRadius: CGFloat,
        shadowOffset: CGSize,
        shadowOpacity: Float
    ) {
        let parameters = ViewParameters(
            backgroundColorSet: backgroundColorSet,
            borderColorSet: borderColorSet,
            shadowColorSet: shadowColorSet,
            borderWidth: borderWidth,
            shadowRadius: shadowRadius,
            shadowOffset: shadowOffset,
            shadowOpacity: shadowOpacity
        )
        
        objc_setAssociatedObject(
            self,
            &AssociatedKeys.viewParameters,
            parameters,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
    }
    
    /// استرجاع معاملات المنظر المحفوظة
    /// - Returns: معاملات المنظر أو nil إذا لم تكن محفوظة
    /// - Note: للاستخدام الداخلي فقط
    private func getViewParameters() -> ViewParameters? {
        return objc_getAssociatedObject(self, &AssociatedKeys.viewParameters) as? ViewParameters
    }
    
    /// حفظ معاملات التدرج لإعادة التطبيق
    /// - Note: للاستخدام الداخلي فقط
    private func saveGradientParameters(
        startColor: GradientColors,
        endColor: GradientColors,
        direction: GradientDirection,
        locations: [NSNumber]?,
        alpha: CGFloat,
        respectDarkMode: Bool
    ) {
        let parameters = GradientParameters(
            startColor: startColor,
            endColor: endColor,
            direction: direction,
            locations: locations,
            alpha: alpha,
            respectDarkMode: respectDarkMode
        )
        
        objc_setAssociatedObject(
            self,
            &AssociatedKeys.gradientParameters,
            parameters,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
    }
    
    /// استرجاع معaملات التدرج المحفوظة
    /// - Returns: معاملات التدرج أو nil إذا لم تكن محفوظة
    /// - Note: للاستخدام الداخلي فقط
    private func getGradientParameters() -> GradientParameters? {
        return objc_getAssociatedObject(self, &AssociatedKeys.gradientParameters) as? GradientParameters
    }
    
    /// حفظ معاملات الحاوية لإعادة التطبيق
    /// - Note: للاستخدام الداخلي فقط
    private func saveContainerParameters(
        color: AppColors,
        border: (color: AppColors, width: CGFloat)?,
        shadow: (color: AppColors, opacity: Float, offset: CGSize, radius: CGFloat)?
    ) {
        let parameters = ContainerParameters(
            backgroundColor: color,
            border: border,
            shadow: shadow
        )
        
        objc_setAssociatedObject(
            self,
            &AssociatedKeys.containerParameters,
            parameters,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
    }
    
    /// استرجاع معاملات الحاوية المحفوظة
    /// - Returns: معاملات الحاوية أو nil إذا لم تكن محفوظة
    /// - Note: للاستخدام الداخلي فقط
    private func getContainerParameters() -> ContainerParameters? {
        return objc_getAssociatedObject(self, &AssociatedKeys.containerParameters) as? ContainerParameters
    }
}

// MARK: - 📊 Parameter Structures (هياكل المعاملات)

/// هيكل معاملات المنظر العامة
private struct ViewParameters {
    let backgroundColorSet: AppColors
    let borderColorSet: AppColors?
    let shadowColorSet: AppColors?
    let borderWidth: CGFloat
    let shadowRadius: CGFloat
    let shadowOffset: CGSize
    let shadowOpacity: Float
}

/// هيكل معاملات التدرج
private struct GradientParameters {
    let startColor: GradientColors
    let endColor: GradientColors
    let direction: GradientDirection
    let locations: [NSNumber]?
    let alpha: CGFloat
    let respectDarkMode: Bool
}

/// هيكل معاملات الحاوية
private struct ContainerParameters {
    let backgroundColor: AppColors
    let border: (color: AppColors, width: CGFloat)?
    let shadow: (color: AppColors, opacity: Float, offset: CGSize, radius: CGFloat)?
}

// MARK: - 🔑 Associated Keys (مفاتيح الربط للحفظ)
extension AssociatedKeys {
    /// مفتاح حفظ معاملات التدرج
    static var gradientParameters: UInt8 = 20
    /// مفتاح حفظ معاملات الحاوية
    static var containerParameters: UInt8 = 30
    /// مفتاح حفظ معاملات المنظر العامة
    static var viewParameters: UInt8 = 35
}

// MARK: - 📐 Corner Type Definition (تعريف أنواع الزوايا)
extension UIView {
    
    /// تعريف أنواع الزوايا المختلفة للانحناء
    /// - Note: يدعم تحديد زوايا منفردة أو متعددة للانحناء
    enum CornerType {
        /// الزاوية العلوية اليسرى
        case topLeft
        /// الزاوية العلوية اليمنى
        case topRight
        /// الزاوية السفلية اليسرى
        case bottomLeft
        /// الزاوية السفلية اليمنى
        case bottomRight
        /// جميع الزوايا الأربع
        case allCorners
        
        /// تحويل إلى CACornerMask للاستخدام مع Core Animation
        /// - Returns: القيمة المناسبة لـ CACornerMask
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
        
        /// تحويل إلى UIRectCorner للاستخدام مع UIBezierPath
        /// - Returns: القيمة المناسبة لـ UIRectCorner
        var uiRectCorner: UIRectCorner {
            switch self {
            case .topLeft:
                return .topLeft
            case .topRight:
                return .topRight
            case .bottomLeft:
                return .bottomLeft
            case .bottomRight:
                return .bottomRight
            case .allCorners:
                return .allCorners
            }
        }
    }
}



// MARK: - 🚫 Legacy Methods (طرق النظام القديم - للتوافق العكسي)
extension UIView {
    
    /// تعيين لون الخلفية باستخدام النظام القديم
    /// - Parameter color: لون الخلفية من نظام الألوان
    /// - Warning: هذه الطريقة قديمة ولا تدعم التحديث التلقائي. استخدم setupForInstantTheme بدلاً منها
    /// - Note: محفوظة للتوافق العكسي فقط
    @available(*, deprecated, message: "استخدم setupForInstantTheme بدلاً من هذه الطريقة للحصول على التحديث التلقائي")
    func setThemeBackgroundColor(_ color: AppColors) {
        backgroundColor = ThemeManager.shared.color(color)
    }
    
    /// تعيين لون الحدود باستخدام النظام القديم
    /// - Parameters:
    ///   - color: لون الحدود من نظام الألوان
    ///   - width: عرض الحدود
    /// - Warning: هذه الطريقة قديمة ولا تدعم التحديث التلقائي. استخدم setupForInstantTheme بدلاً منها
    /// - Note: محفوظة للتوافق العكسي فقط
    @available(*, deprecated, message: "استخدم setupForInstantTheme بدلاً من هذه الطريقة للحصول على التحديث التلقائي")
    func setThemeBorderColor(_ color: AppColors, width: CGFloat = 1.0) {
        layer.borderColor = ThemeManager.shared.color(color).cgColor
        layer.borderWidth = width
    }
    
    /// تعيين لون الظل باستخدام النظام القديم
    /// - Parameters:
    ///   - color: لون الظل من نظام الألوان
    ///   - radius: نصف قطر الظل
    ///   - opacity: شفافية الظل
    ///   - offset: إزاحة الظل
    /// - Warning: هذه الطريقة قديمة ولا تدعم التحديث التلقائي. استخدم setupForInstantTheme بدلاً منها
    /// - Note: محفوظة للتوافق العكسي فقط
    @available(*, deprecated, message: "استخدم setupForInstantTheme بدلاً من هذه الطريقة للحصول على التحديث التلقائي")
    func setThemeShadowColor(_ color: AppColors, radius: CGFloat = 4.0, opacity: Float = 0.1, offset: CGSize = CGSize(width: 0, height: 2)) {
        layer.shadowColor = ThemeManager.shared.color(color).cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.masksToBounds = false
    }
}

// MARK: - 📝 Usage Examples & Implementation Guide (أمثلة الاستخدام ودليل التطبيق)

/*
🎯 دليل الاستخدام الشامل لـ UIView+Extensions:

===============================================
📐 1. الأشكال الأساسية (Basic Shapes):
===============================================

✅ زوايا منحنية لجميع الجهات:
view.addRadius(12)

✅ زوايا منحنية لجهات محددة:
view.addCorner(corners: [.topLeft, .topRight], radius: 16)

✅ زاوية منحنية واحدة:
view.addCorner(corner: .topLeft, radius: 8)

✅ شكل دائري:
view.makeCircular() // يجب استدعاؤها بعد تحديد الأبعاد

===============================================
🎨 2. إعداد النظام الجديد (New Theme System):
===============================================

✅ إعداد بسيط:
view.setupForInstantTheme(backgroundColorSet: .card)

✅ إعداد شامل:
view.setupForInstantTheme(
    backgroundColorSet: .card,
    borderColorSet: .border,
    shadowColorSet: .shadow,
    cornerRadius: 12,
    borderWidth: 1,
    shadowRadius: 4
)

✅ تحديث الألوان (في applyInstantThemeUpdate):
view.updateInstantThemeColors()

===============================================
🌈 3. التدرجات (Gradients):
===============================================

✅ تدرج بسيط:
view.applyGradient(
    startColor: .primaryGradientStart,
    endColor: .primaryGradientEnd
)

✅ تدرج متقدم:
view.applyGradient(
    startColor: .primaryGradientStart,
    endColor: .primaryGradientEnd,
    direction: .vertical,
    locations: [0.0, 0.3, 1.0],
    alpha: 0.8
)

✅ إعادة تطبيق التدرج (في viewDidLayoutSubviews):
view.reapplyGradient()

✅ إزالة التدرج:
view.removeGradient()

===============================================
🏗️ 4. الحاويات المتخصصة (Specialized Containers):
===============================================

✅ حاوية رئيسية:
view.setupAsTitleContainer()

✅ حاوية محتوى:
view.setupAsContentContainer(radius: 12, addShadow: true)

✅ بطاقة:
view.setupAsCardContainer()

✅ حاوية دائرية:
view.setupAsCircularControl() // في viewDidLayoutSubviews

✅ رأس الصفحة:
view.setupAsHeaderContainer(bottomRadius: 20)

✅ ذيل الصفحة:
view.setupAsFooterContainer(topRadius: 20)

===============================================
🔄 5. دورة الحياة المثلى (Optimal Lifecycle):
===============================================

✅ في viewDidLoad:
override func viewDidLoad() {
    super.viewDidLoad()
    enableInstantTheme(transitionStyle: .snapshot)
    setupUI() // إعداد واحد فقط
}

✅ في applyInstantThemeUpdate:
override func applyInstantThemeUpdate() {
    super.applyInstantThemeUpdate()
    updateThemeColors() // تحديث الألوان فقط
}

✅ في viewDidLayoutSubviews:
override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    reapplyLayoutDependentElements() // العناصر المعتمدة على الأبعاد فقط
}

===============================================
⚠️ 6. أخطاء شائعة يجب تجنبها:
===============================================

❌ لا تفعل:
override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    setupUI() // ❌ إعادة إعداد كاملة!
}

✅ افعل:
override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    profileImageView.makeCircular() // ✅ إعادة تطبيق ما يحتاج فقط
    backgroundView.reapplyGradient() // ✅ إعادة تطبيق التدرجات
}

❌ لا تفعل:
func updateColors() {
    view.backgroundColor = UIColor.red // ❌ ألوان ثابتة
}

✅ افعل:
func updateColors() {
    view.updateInstantThemeColors() // ✅ ألوان ديناميكية
}

===============================================
🎯 7. مثال شامل للتطبيق:
===============================================

class WelcomeVC: UIViewController {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var actionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 🎯 تفعيل النظام الجديد
        enableInstantTheme(transitionStyle: .snapshot)
        
        // 🎨 إعداد الواجهة
        setupUI()
    }
    
    private func setupUI() {
        // 🏗️ إعداد الحاويات
        headerView.setupAsHeaderContainer()
        contentView.setupAsContentContainer(radius: 16, addShadow: true)
        
        // 🎨 إعداد العناصر
        profileImageView.setupForInstantTheme(
            backgroundColorSet: .secondBackground,
            cornerRadius: 8
        )
        
        // 🌈 إعداد التدرج
        actionButton.applyGradient(
            startColor: .primaryGradientStart,
            endColor: .primaryGradientEnd,
            direction: .horizontal
        )
    }
    
    override func applyInstantThemeUpdate() {
        super.applyInstantThemeUpdate()
        
        // ✅ تحديث الألوان تلقائياً
        headerView.updateInstantThemeColors()
        contentView.updateInstantThemeColors()
        profileImageView.updateInstantThemeColors()
        actionButton.reapplyGradient()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // ✅ إعادة تطبيق العناصر المعتمدة على الأبعاد
        profileImageView.makeCircular()
        actionButton.reapplyGradient()
    }
}

===============================================
🚀 8. النتائج المتوقعة:
===============================================

✅ أداء عالي (لا إعادة إعداد غير ضرورية)
✅ تحديث تلقائي للألوان عند تغيير السمة
✅ كود نظيف وسهل الصيانة
✅ تجربة مستخدم سلسة
✅ استهلاك ذاكرة منخفض
✅ لا مشاكل في الأداء

*/
