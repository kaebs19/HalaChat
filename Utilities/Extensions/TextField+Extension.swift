import UIKit
import ObjectiveC

// MARK: - UITextField+Extensions محسّن للنظام الجديد

extension UITextField {
    
    // MARK: - Instant Theme Setup Methods
    
    /// إعداد شامل لحقل النص مع النظام الجديد
    func setupForInstantTheme(
        textColorSet: AppColors = .text,
        placeholderColorSet: AppColors = .placeholder,
        backgroundColorSet: AppColors = .clear,
        borderColorSet: AppColors? = nil,
        tintColorSet: AppColors = .primary,
        cornerRadius: CGFloat = 0,
        borderWidth: CGFloat = 0,
        font: Fonts = .cairo,
        fontSize: Sizes = .size_16,
        fontStyle: FontStyle = .regular,
        textAlignment: Directions = .auto,
        padding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    ) {
        // 🎨 تطبيق الألوان
        textColor = ThemeManager.shared.color(textColorSet)
        backgroundColor = ThemeManager.shared.color(backgroundColorSet)
        tintColor = ThemeManager.shared.color(tintColorSet)
        
        // 📝 تحديث لون النص الافتراضي
        if let placeholder = placeholder {
            attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [.foregroundColor: ThemeManager.shared.color(placeholderColorSet)]
            )
        }
        
        // 🖼️ تطبيق الحدود
        if let borderColor = borderColorSet, borderWidth > 0 {
            layer.borderColor = ThemeManager.shared.color(borderColor).cgColor
            layer.borderWidth = borderWidth
        }
        
        // 🔸 تطبيق الزوايا المنحنية
        if cornerRadius > 0 {
            layer.cornerRadius = cornerRadius
            clipsToBounds = true
        }
        
        // 🔤 تطبيق الخط
        self.font = UIFont(name: font.name, size: fontSize.rawValue) ??
                   UIFont.systemFont(ofSize: fontSize.rawValue, weight: fontStyle.uiFontWeight)
        
        // ↔️ تطبيق اتجاه النص
        self.textAlignment = textAlignment.textAlignment
        
        // 📐 تطبيق الهوامش الداخلية
        setPadding(padding)
        
        // 💾 حفظ المعاملات للتحديث التلقائي
        saveTextFieldParameters(
            textColorSet: textColorSet,
            placeholderColorSet: placeholderColorSet,
            backgroundColorSet: backgroundColorSet,
            borderColorSet: borderColorSet,
            tintColorSet: tintColorSet,
            borderWidth: borderWidth,
            placeholder: placeholder
        )
    }
    
    /// تحديث ألوان حقل النص
    func updateInstantThemeColors() {
        guard let parameters = getTextFieldParameters() else {
            return
        }
        
        // 🎨 تحديث الألوان
        textColor = ThemeManager.shared.color(parameters.textColorSet)
        backgroundColor = ThemeManager.shared.color(parameters.backgroundColorSet)
        tintColor = ThemeManager.shared.color(parameters.tintColorSet)
        
        // 📝 تحديث لون النص الافتراضي
        if let placeholder = parameters.placeholder {
            attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [.foregroundColor: ThemeManager.shared.color(parameters.placeholderColorSet)]
            )
        }
        
        // 🖼️ تحديث لون الحدود
        if parameters.borderWidth > 0, let borderColor = parameters.borderColorSet {
            layer.borderColor = ThemeManager.shared.color(borderColor).cgColor
        }
    }
    
    // MARK: - Text & Placeholder Methods
    
    /// تعيين النص مع التنسيق
    func setText(
        _ text: String?,
        color: AppColors = .text,
        font: Fonts = .cairo,
        fontSize: Sizes = .size_16,
        fontStyle: FontStyle = .regular
    ) {
        self.text = text
        textColor = ThemeManager.shared.color(color)
        self.font = UIFont(name: font.name, size: fontSize.rawValue) ??
                   UIFont.systemFont(ofSize: fontSize.rawValue, weight: fontStyle.uiFontWeight)
    }
    
    /// تعيين النص الافتراضي مع التنسيق
    func setPlaceholder(
        _ placeholder: TextFields,
        color: AppColors = .placeholder,
        font: Fonts? = nil,
        fontSize: Sizes? = nil,
        fontStyle: FontStyle? = nil
    ) {
        let placeholderFont = font != nil ?
            UIFont(name: font!.name, size: fontSize?.rawValue ?? self.font?.pointSize ?? 16) ??
            UIFont.systemFont(ofSize: fontSize?.rawValue ?? self.font?.pointSize ?? 16, weight: fontStyle?.uiFontWeight ?? .regular) :
            self.font
        
        attributedPlaceholder = NSAttributedString(
            string: placeholder.textTF,
            attributes: [
                .foregroundColor: ThemeManager.shared.color(color),
                .font: placeholderFont as Any
            ]
        )
        
        // 💾 حفظ النص الافتراضي للتحديث
        if var parameters = getTextFieldParameters() {
            parameters.placeholder = placeholder.textTF
            parameters.placeholderColorSet = color
            saveTextFieldParameters(parameters)
        }
    }
    
    // MARK: - Specialized Setup Methods
    
    /// إعداد حقل البريد الإلكتروني
    func setupAsEmailField(
        placeholder: TextFields = .email,
        cornerRadius: CGFloat = 8,
        borderColor: AppColors = .border,
        borderWidth: CGFloat = 1
    ) {
        setupForInstantTheme(
            placeholderColorSet: .placeholder,
            backgroundColorSet: .textFieldBackground,
            borderColorSet: borderColor,
            cornerRadius: cornerRadius,
            borderWidth: borderWidth
        )
        
        setPlaceholder(placeholder)
        keyboardType = .emailAddress
        autocapitalizationType = .none
        autocorrectionType = .no
        textContentType = .emailAddress
    }
    
    /// إعداد حقل كلمة المرور
    func setupAsPasswordField(
        placeholder: TextFields = .password,
        cornerRadius: CGFloat = 8,
        borderColor: AppColors = .border,
        borderWidth: CGFloat = 1,
        showToggleButton: Bool = true
    ) {
        setupForInstantTheme(
            placeholderColorSet: .placeholder,
            backgroundColorSet: .textFieldBackground,
            borderColorSet: borderColor,
            cornerRadius: cornerRadius,
            borderWidth: borderWidth,
            padding: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: showToggleButton ? 40 : 8)
        )
        
        setPlaceholder(placeholder)
        isSecureTextEntry = true
        textContentType = .password
        
        if showToggleButton {
            addPasswordToggleButton()
        }
    }
    
    /// إعداد حقل البحث
    func setupAsSearchField(
        placeholder: TextFields = .searech,
        cornerRadius: CGFloat = 20,
        backgroundColor: AppColors = .searchBackground,
        showSearchIcon: Bool = true
    ) {
        setupForInstantTheme(
            placeholderColorSet: .placeholder,
            backgroundColorSet: backgroundColor,
            cornerRadius: cornerRadius,
            padding: UIEdgeInsets(top: 0, left: showSearchIcon ? 35 : 15, bottom: 0, right: 15)
        )
        
        setPlaceholder(placeholder)
        keyboardType = .default
        returnKeyType = .search
        clearButtonMode = .whileEditing
        
        if showSearchIcon {
            addSearchIcon()
        }
    }
    
    /// إعداد حقل رقم الهاتف
    func setupAsPhoneField(
        placeholder: TextFields = .phoneNumber,
        cornerRadius: CGFloat = 8,
        borderColor: AppColors = .border,
        borderWidth: CGFloat = 1,
        countryCode: String = "+966"
    ) {
        setupForInstantTheme(
            placeholderColorSet: .placeholder,
            backgroundColorSet: .textFieldBackground,
            borderColorSet: borderColor,
            cornerRadius: cornerRadius,
            borderWidth: borderWidth,
            textAlignment: .left,
            padding: UIEdgeInsets(top: 0, left: 60, bottom: 0, right: 8)
        )
        
        setPlaceholder(placeholder)
        keyboardType = .phonePad
        
        addCountryCodeLabel(countryCode)
    }
    
    // MARK: - Helper Methods
    
    /// إضافة زر إظهار/إخفاء كلمة المرور
    private func addPasswordToggleButton() {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "eye.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.setImage(UIImage(systemName: "eye.slash.fill")?.withRenderingMode(.alwaysTemplate), for: .selected)
        button.tintColor = ThemeManager.shared.color(.placeholder)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        containerView.addSubview(button)
        button.center = containerView.center
        
        rightView = containerView
        rightViewMode = .always
    }
    
    /// إضافة أيقونة البحث
    private func addSearchIcon() {
        let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate))
        imageView.tintColor = ThemeManager.shared.color(.placeholder)
        imageView.frame = CGRect(x: 10, y: 0, width: 20, height: 20)
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 20))
        containerView.addSubview(imageView)
        
        leftView = containerView
        leftViewMode = .always
    }
    
    /// إضافة رمز الدولة للهاتف
    private func addCountryCodeLabel(_ code: String) {
        let label = UILabel()
        label.text = code
        label.textColor = ThemeManager.shared.color(.text)
        label.font = font
        label.sizeToFit()
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: bounds.height))
        containerView.addSubview(label)
        label.center = containerView.center
        
        leftView = containerView
        leftViewMode = .always
    }
    
    /// تبديل إظهار/إخفاء كلمة المرور
    @objc private func togglePasswordVisibility(_ sender: UIButton) {
        sender.isSelected.toggle()
        isSecureTextEntry.toggle()
        
        // الحفاظ على موضع المؤشر
        if let textRange = selectedTextRange {
            let cursorPosition = offset(from: beginningOfDocument, to: textRange.start)
            
            // تحديث النص لإظهار التغيير
            let text = self.text
            self.text = nil
            self.text = text
            
            // استعادة موضع المؤشر
            if let newPosition = position(from: beginningOfDocument, offset: cursorPosition) {
                selectedTextRange = self.textRange(from: newPosition, to: newPosition)
            }
        }
    }
    
    /// تعيين الهوامش الداخلية
    private func setPadding(_ padding: UIEdgeInsets) {
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding.left, height: bounds.height))
        leftView = leftPaddingView
        leftViewMode = leftViewMode == .never ? .always : leftViewMode
        
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding.right, height: bounds.height))
        rightView = rightPaddingView
        rightViewMode = rightViewMode == .never ? .always : rightViewMode
    }
    
    // MARK: - Validation Methods
    
    /// التحقق من صحة البريد الإلكتروني
    func isValidEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: text)
    }
    
    /// التحقق من قوة كلمة المرور
    func passwordStrength() -> PasswordStrength {
        guard let password = text, !password.isEmpty else { return .weak }
        
        var strength = 0
        
        // طول كلمة المرور
        if password.count >= 8 { strength += 1 }
        if password.count >= 12 { strength += 1 }
        
        // تحتوي على أحرف كبيرة
        if password.range(of: "[A-Z]", options: .regularExpression) != nil { strength += 1 }
        
        // تحتوي على أحرف صغيرة
        if password.range(of: "[a-z]", options: .regularExpression) != nil { strength += 1 }
        
        // تحتوي على أرقام
        if password.range(of: "[0-9]", options: .regularExpression) != nil { strength += 1 }
        
        // تحتوي على رموز خاصة
        if password.range(of: "[!@#$%^&*(),.?\":{}|<>]", options: .regularExpression) != nil { strength += 1 }
        
        switch strength {
        case 0...2: return .weak
        case 3...4: return .medium
        default: return .strong
        }
    }
    
    /// قوة كلمة المرور
    enum PasswordStrength {
        case weak, medium, strong
        
        var color: AppColors {
            switch self {
                case .weak: return AppColors.error
                case .medium: return AppColors.warning
                case .strong: return AppColors.success
            }
        }
        
        var text: String {
            switch self {
            case .weak: return "ضعيفة"
            case .medium: return "متوسطة"
            case .strong: return "قوية"
            }
        }
    }
}

// MARK: - Parameters Storage

private extension UITextField {
    
    /// حفظ معاملات حقل النص
    func saveTextFieldParameters(
        textColorSet: AppColors,
        placeholderColorSet: AppColors,
        backgroundColorSet: AppColors,
        borderColorSet: AppColors?,
        tintColorSet: AppColors,
        borderWidth: CGFloat,
        placeholder: String?
    ) {
        let parameters = TextFieldParameters(
            textColorSet: textColorSet,
            placeholderColorSet: placeholderColorSet,
            backgroundColorSet: backgroundColorSet,
            borderColorSet: borderColorSet,
            tintColorSet: tintColorSet,
            borderWidth: borderWidth,
            placeholder: placeholder
        )
        
        objc_setAssociatedObject(
            self,
            &AssociatedKeys.textFieldParameters,
            parameters,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
    }
    
    /// حفظ معاملات محدثة
    func saveTextFieldParameters(_ parameters: TextFieldParameters) {
        objc_setAssociatedObject(
            self,
            &AssociatedKeys.textFieldParameters,
            parameters,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
    }
    
    /// استرجاع معاملات حقل النص
    func getTextFieldParameters() -> TextFieldParameters? {
        return objc_getAssociatedObject(self, &AssociatedKeys.textFieldParameters) as? TextFieldParameters
    }
}

// MARK: - Parameter Structure

/// هيكل معاملات حقل النص
private struct TextFieldParameters {
    let textColorSet: AppColors
    var placeholderColorSet: AppColors
    let backgroundColorSet: AppColors
    let borderColorSet: AppColors?
    let tintColorSet: AppColors
    let borderWidth: CGFloat
    var placeholder: String?
}

// MARK: - Associated Keys

extension AssociatedKeys {
    /// مفتاح حفظ معاملات حقل النص
    static var textFieldParameters: UInt8 = 40
}

// MARK: - Legacy Methods (Deprecated)

extension UITextField {
    
    /// طريقة قديمة - محذرة
    @available(*, deprecated, message: "استخدم setupForInstantTheme بدلاً من هذه الطريقة")
    func setThemeTextColor(_ colorSet: AppColors) {
        textColor = ThemeManager.shared.color(colorSet)
    }
    
    /// طريقة قديمة - محذرة
    @available(*, deprecated, message: "استخدم setPlaceholder بدلاً من هذه الطريقة")
    func setThemePlaceholderColor(_ colorSet: AppColors) {
        if let placeholder = placeholder {
            attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [.foregroundColor: ThemeManager.shared.color(colorSet)]
            )
        }
    }
    
    /// طريقة قديمة - محذرة
    @available(*, deprecated, message: "استخدم setupForInstantTheme بدلاً من هذه الطريقة")
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
                   direction: Directions? = nil) {
        // استخدام الطريقة الجديدة
        setupForInstantTheme(
            textColorSet: textColor ?? .text,
            placeholderColorSet: placeholderColor ?? .placeholder,
            backgroundColorSet: backgroundColor ?? .clear,
            borderColorSet: borderColor,
            cornerRadius: cornerRadius,
            borderWidth: borderWidth,
            font: font ?? .cairo,
            fontSize: ofSize ?? .size_16,
            fontStyle: fontStyle ?? .regular,
            textAlignment: direction ?? .auto,
            padding: padding ?? UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        )
        
        if let placeholder = placeholder {
            setPlaceholder(placeholder)
        }
        
        if let text = text {
            self.text = text
        }
    }
}

// MARK: - Usage Examples

/*
🎯 دليل الاستخدام الشامل لـ UITextField+Extensions:

===============================================
📝 1. الإعداد الأساسي:
===============================================

✅ إعداد بسيط:
textField.setupForInstantTheme()

✅ إعداد مخصص:
textField.setupForInstantTheme(
    textColorSet: .text,
    placeholderColorSet: .placeholder,
    backgroundColorSet: .textFieldBackground,
    borderColorSet: .border,
    cornerRadius: 8,
    borderWidth: 1,
    font: .cairo,
    fontSize: .size_16
)

===============================================
📧 2. الحقول المتخصصة:
===============================================

✅ حقل البريد الإلكتروني:
emailField.setupAsEmailField(placeholder: .email)

✅ حقل كلمة المرور:
passwordField.setupAsPasswordField(showToggleButton: true)

✅ حقل البحث:
searchField.setupAsSearchField(showSearchIcon: true)

✅ حقل الهاتف:
phoneField.setupAsPhoneField(countryCode: "+966")

===============================================
🔍 3. التحقق من الصحة:
===============================================

✅ التحقق من البريد الإلكتروني:
if emailField.isValidEmail() {
    // بريد صحيح
}

✅ قوة كلمة المرور:
let strength = passwordField.passwordStrength()
strengthLabel.text = strength.text
strengthLabel.textColor = ThemeManager.shared.color(strength.color)

===============================================
🔄 4. دورة الحياة:
===============================================

✅ في viewDidLoad:
override func viewDidLoad() {
    super.viewDidLoad()
    enableInstantTheme()
    setupTextFields()
}

✅ في applyInstantThemeUpdate:
override func applyInstantThemeUpdate() {
    super.applyInstantThemeUpdate()
    emailField.updateInstantThemeColors()
    passwordField.updateInstantThemeColors()
}

===============================================
💡 5. مثال شامل:
===============================================

class LoginVC: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enableInstantTheme()
        setupFields()
    }
    
    private func setupFields() {
        // إعداد حقل البريد
        emailField.setupAsEmailField()
        
        // إعداد حقل كلمة المرور
        passwordField.setupAsPasswordField()
    }
    
    override func applyInstantThemeUpdate() {
        super.applyInstantThemeUpdate()
        emailField.updateInstantThemeColors()
        passwordField.updateInstantThemeColors()
    }
    
    @IBAction func loginTapped() {
        // التحقق من الصحة
        guard emailField.isValidEmail() else {
            showError("البريد الإلكتروني غير صحيح")
            return
        }
        
        let passwordStrength = passwordField.passwordStrength()
        if passwordStrength == .weak {
            showWarning("كلمة المرور ضعيفة")
        }
        
        // تسجيل الدخول...
    }
}

*/
