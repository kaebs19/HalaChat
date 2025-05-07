//
//  ForgetPasswordVC.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 06/05/2025.
//

import UIKit

class ForgetPasswordVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var passwordSutitleLbl: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var sendButton: UIButton!
    
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
        super.viewDidLayoutSubviews()
        setupUI()
        updateCustomUIElements()
    }
    
}

// MARK: - UI Setup

extension ForgetPasswordVC {
    
    private func setupUI() {
        
        // تطبيق السمات
        applyTheme()
        
        setupNavigationBar(items: [.BackButton])
        setStyledTitle(title: .forgotPassword,
                       fontStyle: .extraBold ,FontSize: .size_22  ,
                       useLargeTitle: true)
        updateCustomUIElements()
    }
    
    private func updateCustomUIElements() {
        passwordSutitleLbl.customize(text: Lables.forgotPasswordSubtitle.textLib,
                                     color: .text,
                                     ofSize: .size_16, font: .poppins , fontStyle: .bold ,
                                     lines: 3)
        setupViews()
        
        setupTextFields()
        
        setupButtons()
    }
    
    private func setupViews() {
        passwordView.setThemeBackgroundColor(.secondBackground)
        passwordView.addRadius(15)
    }
    
    private func setupTextFields() {
        passwordTextField.customizePlaeholder(plaeholder: .password)
        passwordTextField.customizeText()
    }
    
    private func setupButtons() {
        sendButton.customize( title: .send,
                              titleColor: .onlyWhite,
                              ofSize: .size_18,
                              font: .poppins ,fontStyle: .extraBold)
        sendButton.addRadius(15)
        sendButton.applyGradient(startColor: .Start, endColor: .End , direction: .diagonalTopRightToBottomLeft , respectDarkMode: true)

    }
    
    
}
