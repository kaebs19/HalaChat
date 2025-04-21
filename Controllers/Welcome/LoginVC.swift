//
//  LoginVC.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 19/04/2025.
//

import UIKit

class LoginVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var patternImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    
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
        view.setThemeBackground(.background)
        
        setupNavigationBar(items: [.BackButton])

        self.title = Titles.Login.textTitle
    
        // تحديث العناصر
        updateCustomUIElements()
        
        // تحديث View
        setupView()
        
        // تحديث TextField
        setupTextFields()
        
        
    }
    
    private func updateCustomUIElements() {
        
        titleLabel.customize(text: Lables.welcome.textLib,
                             colorSet: .text,
                             ofSize: .size_32, font: .poppins , fontStyle: .extraBold)
        titleLabel.backgroundColor = .clear
        
        subtitleLabel.customize(text: Lables.welcomeSubtitle.textLib,
                             colorSet: .text,
                                ofSize: .size_16, font: .poppins , fontStyle: .extraBold)
        titleLabel.backgroundColor = .clear

    }
    
    func setupView() {
       // emailView.setThemeBackground(.background)
        emailView.backgroundColor = .clear
        passwordView.setThemeBackground(.secondaryBackground)
    }
    
    func setupTextFields() {
        emailTextField.backgroundColor = .clear
    }
}
