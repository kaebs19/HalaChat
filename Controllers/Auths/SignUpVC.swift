//
//  SignUpVC.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 20/04/2025.
//

import UIKit

class SignUpVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet  var mainView: [UIView]!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var showPasswordButton: UIButton!
    @IBOutlet weak var showPasswordImageView: UIImageView!
    @IBOutlet weak var brithDateTextField: UITextField!
    @IBOutlet weak var iAgreeImageView: UIImageView!
    @IBOutlet weak var iAgreeButton: UIButton!
    @IBOutlet weak var iAgreeLabel: UILabel!
    @IBOutlet weak var termsButton: UIButton!
    @IBOutlet weak var conditionButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var agreementLabel: UILabel!
    
    // MARK: - Variables - Arry
    private var themeObserverId: UUID?
    /// متغير لتتبع حالة الموافقة
    private var isAgreedToTerms: Bool = false
    
    // متغير لتتبع حالة إظهار كلمة المرور

    var isShowPassword: Bool = false {
        didSet {
            passwordTextField.togglePassword()
            let imageName = isShowPassword ? "eye.slash" : "eye"
            let newImage = UIImage(systemName: imageName)
            
            UIImage.applyThemeTransition(to: showPasswordImageView,
                                         image: newImage,
                                         colorSet: .text)
        }
    }

    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("تم تغيير السمة - تحديث العناصر")

        themeObserverId = setupThemeObserver { [weak self] in
            self?.updateCustomUIElements()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // تنظيف وازالة العناصر

        clearThemeObserver(id: themeObserverId)
        if let observer = themeObserverId {
            ThemeManager.shared.removeThemeObserver(id: observer)
        }
    }

    // تنظيف وازالة العناصر اظافي
    deinit {
        clearThemeObserver(id: themeObserverId)
        themeObserverId = nil
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUI()
    }
    
    @IBAction func showPasswordClickBut(_ sender: UIButton) {

        // تحديد الصورة الجديدة قبل التبديل
        let imageName = !isShowPassword ? "eye.slash" : "eye"
        let newImage = UIImage(systemName: imageName)
        
        // تطبيق تأثير الدوران
        UIImage.applyThemeFlipTransition(
            to: showPasswordImageView,
            image: newImage,
            colorSet: .text,
            direction: .vertical
        )
        
        // تبديل حالة إظهار كلمة المرور
        // ملاحظة: يجب وضع هذا بعد تطبيق التأثير لأننا استخدمنا !isShowPassword
        isShowPassword.toggle()
        passwordTextField.togglePassword()
        
    }
    
    
}


extension SignUpVC {
    
    private func setupUI() {
        // تطبيق السمة العامة
        applyTheme()
        
        setStyledTitle(title: .SignUp)
        
        setupNavigationBar(items: [.BackButton])
        
        updateCustomUIElements()
    }
    
    private func updateCustomUIElements() {
        titleLabel.customize(text: Lables.createAccount.textLib,
                             color: .text,
                             ofSize: .size_22,
                             font: .poppins , fontStyle: .extraBold)
        showPasswordImageView.tintColor = ThemeManager.shared.color(.text)
        
        // 1. ضبط حقل كلمة المرور ليكون مخفيًا (نجوم) بشكل افتراضي
        passwordTextField.isSecureTextEntry = true
        showPasswordImageView.tintColor = ThemeManager.shared.color(.text)

        // 2. ضبط حالة الموافقة على الشروط
        isAgreedToTerms = false
        iAgreeImageView.image = UIImage(systemName: "circle")
        iAgreeImageView.tintColor = ThemeManager.shared.color(.text)

        agreementLabel.customize(text: Lables.argeement.textLib,
                                 color: .ashBlue,
                                 ofSize: .size_10, font: .cairo ,
                                 lines: 2)
        iAgreeLabel.customize(text: Lables.iAgree.textLib,
                                 color: .text, ofSize: .size_12, font: .poppins)
        setupViews()
        setupTextFields()
        setupButtons()
    }
    
    private func setupViews() {
        mainView.forEach { views in
            views.setThemeBackgroundColor(.secondBackground)
            views.addRadius(15)
        }
    }
    
    private func setupTextFields() {
        userNameTextField.customizePlaeholder(plaeholder: .username ,
                                              placeholderColor: .placeholderColor)
        emailTextField.customizePlaeholder(plaeholder: .email ,
                                           placeholderColor: .placeholderColor)
        passwordTextField.customizePlaeholder(plaeholder: .password ,
                                              placeholderColor: .placeholderColor,
                                              font: .poppins , fontStyle: .semiBold ,
                                              direction: .auto)
        passwordTextField.customizeText()
        
        brithDateTextField.customizePlaeholder(plaeholder: .dateOfBirth ,
                                               placeholderColor: .placeholderColor)
        
        [userNameTextField,emailTextField  ,brithDateTextField].forEach { textFT in
            textFT.customizeText()
        }
        
        
    }
    
    private func setupButtons() {
        iAgreeButton.addTarget(self,
                               action: #selector(checkPressIagreeButton),
                               for: .touchUpInside)
        
        signupButton.customize(title: .signup,
                              titleColor: .onlyWhite,
                              ofSize: .size_18,
                               font: .cairo ,fontStyle: .bold,
                              cornerRadius: 15 )
        signupButton.applyGradient(startColor: .Start, endColor: .End , direction: .diagonalTopRightToBottomLeft , respectDarkMode: true)

        signupButton.addTarget(self,
                               action: #selector(signupButtonTapped),
                               for: .touchUpInside)
        termsButton.customize(title: .terms,
                              titleColor: .text, ofSize: .size_14,
                              font: .poppins)
        conditionButton.customize(title: .terms,
                              titleColor: .text, ofSize: .size_14,
                              font: .poppins)
    }
    
    
    @objc func checkPressIagreeButton() {
        
        // تطبيق تأثير النبض
        UIImage.applyPulseEffect(to: iAgreeImageView) { _ in
            // تبديل حالة الموافقة بعد الانتهاء من تأثير النبض
            self.isAgreedToTerms.toggle()
            
            // تحديد الصورة والألوان المناسبة
            let imageName = self.isAgreedToTerms ? "checkmark.circle.fill" : "circle"
            let newImage = UIImage(systemName: imageName)
            let colorSet: AppColors = self.isAgreedToTerms ? .primary : .text
            
            // تطبيق التأثير الانتقالي
            UIImage.applyThemeTransition(
                to: self.iAgreeImageView,
                image: newImage,
                colorSet: colorSet
            )
        }
        
    }
    
    @objc func signupButtonTapped() {
        goToVC(identifiers: .HomeVC)
    }
}
