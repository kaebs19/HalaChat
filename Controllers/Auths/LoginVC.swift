//
//  LoginVC.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 19/04/2025.
//

import UIKit

class LoginVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet  var mainView: [UIView]!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var showPasswordImageView: UIImageView!
    
    // MARK: - Variables - Arry
    private var themeObserver: UUID?
    // متغير لتتبع حالة إظهار كلمة المرور

    var isShowPassword: Bool = false {
        didSet {
            passwordTextField.togglePassword()
            let imageName = isShowPassword ? "eye.slash" : "eye"
            let newImage = UIImage(systemName: imageName)
            // استخدام التأثير الانتقالي من امتداد UIImage

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
        // تحديث أي عناصر خاصة عند تغيير السمة
        themeObserver = setupThemeObserver { [weak self] in
            self?.updateCustomUIElements()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // تنظيق وازالة العناصر
        clearThemeObserver(id: themeObserver)
        themeObserver = nil
    }
    
    deinit {
        // تأكيد إضافي على تنظيف الموارد
        clearThemeObserver(id: themeObserver)
        themeObserver = nil
    }
    
    override func viewDidLayoutSubviews() {
        updateCustomUIElements()
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
           isShowPassword.toggle()
           passwordTextField.togglePassword()
    }
}

// MARK: - UI Setup

extension LoginVC {
    
    private func setupUI() {
        // تطبيق السمة العامة
        
        applyTheme()
        
        setupNavigationBar(items: [.BackButton])
        
        self.title = Titles.Login.textTitle
        
        // تحديث العناصر
        updateCustomUIElements()
        
        // تحديث View
        setupView()
        
        // تحديث TextField
        setupTextFields()
        
        // تحديث الازرار
        setupButtons()
        
    }
    
    private func updateCustomUIElements() {
        titleLabel.customize(text: Lables.welcome.textLib,
                             color: .text, ofSize: .size_16 ,
                             font: .cairo , fontStyle: .extraBold)
        subtitleLabel.customize(text: Lables.welcomeSubtitle.textLib,
                                color: .text, ofSize: .size_16,
                                font: .poppins , fontStyle: .bold , lines: 3)
        showPasswordImageView.setThemeTintColor(.text)
        
    }
    
    private func setupView() {
        mainView.forEach { view in
            view.setThemeBackgroundColor(.secondBackground)
            view.addRadius(15)
        }
    }
    
    private func setupTextFields() {
        emailTextField.customizePlaeholder(plaeholder: .email ,
                                       placeholderColor: .placeholderColor,
                                       font: .poppins , fontStyle: .semiBold ,
                                       direction: .auto)
        emailTextField.customizeText()
        
        passwordTextField.customizePlaeholder(plaeholder: .password ,
                                       placeholderColor: .placeholderColor,
                                       font: .poppins , fontStyle: .semiBold ,
                                       direction: .auto)
        passwordTextField.customizeText()
        
    }
    
    private func setupButtons() {
        loginButton.applyGradient(startColor: .Start, endColor: .End ,direction: .diagonalTopLeftToBottomRight ,respectDarkMode: true)
        loginButton.customize(title: .login,
                              titleColor: .onlyWhite,
                              ofSize: .size_18,
                              font: .cairo ,fontStyle: .bold,
                              cornerRadius: 15 )
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        
        forgotPasswordButton.customize(title: .forgotPassword,
                                       titleColor: .text, ofSize: .size_14, font: .poppins)
        forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordTapped), for: .touchUpInside)
        
    }
    
    @objc func loginTapped() {
        print(" loginTapped")
    }
    
    @objc func forgotPasswordTapped() {
        goToVC(storyboard: .Welcome, identifiers: .ForgetPasswordVC)
    }
}



