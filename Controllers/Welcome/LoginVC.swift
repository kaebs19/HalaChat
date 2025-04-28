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
    
    // MARK: - Variables - Arry
    private var themeObserver: UUID?
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // تحديث أي عناصر خاصة عند تغيير السمة
        themeObserver = setupThemeObserver {
            self.updateCustomUIElements()
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
        
    }
    
    @objc func loginTapped() {
        print(" loginTapped")
    }
}


extension LoginVC: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.placeholder = ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField.text?.isEmpty ?? true {
            // استعادة النص الافتراضي
            if textField == emailTextField {
                textField.placeholder = TextFields.email.textTF
            } else if textField == passwordTextField {
                textField.placeholder = TextFields.password.textTF
            }
        }
    }
    
}

