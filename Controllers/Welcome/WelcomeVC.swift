//
//  Welcome.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 15/04/2025.
//

import UIKit

class WelcomeVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    
    // MARK: - Variables - Arry
    private var themeObserverId: UUID?

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        print("Welcome")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        themeObserverId = setupThemeObserver { [weak self] in
            // تحديث أي عناصر خاصة عند تغيير السمة
            self?.updateCustomUIElements()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // تنظيف وازالة العناصر
        clearThemeObserver(id: themeObserverId)

    }
    
    deinit {
        // تأكيد إضافي على تنظيف الموارد
        clearThemeObserver(id: themeObserverId)
     
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateCustomUIElements()
    }
    
    // MARK: - Actions
    
    
}

extension WelcomeVC {
    
    private func setupUI() {
        updateCustomUIElements()
    }
    
    private func updateCustomUIElements() {
        titleLabel.customize(text: Lables.findNew.textLib,
                             color: .text, ofSize: .size_16 ,
                             font: .cairo , fontStyle: .extraBold)
        subtitleLabel.customize(text: Lables.findNewSubtitle.textLib,
                             color: .text, ofSize: .size_16,
                             font: .poppins , fontStyle: .bold , lines: 3)
        
        setupViews()
        
        setupButton()
    }
    
    private func setupViews() {
   
    }
    
    private func setupButton() {
        loginButton.backgroundColor = AppColors.background.color
        loginButton.customize(title: .login,
                              titleColor: .textSecond,
                              ofSize: .size_18,
                              font: .cairo ,fontStyle: .bold,
                              cornerRadius: 15 )
        
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)

        signupButton.applyGradient(startColor: .Start, endColor: .End , direction: .diagonalTopRightToBottomLeft , respectDarkMode: true)
        signupButton.customize(title: .signup,
                              titleColor: .onlyWhite,
                              ofSize: .size_18,
                               font: .cairo ,fontStyle: .bold,
                              cornerRadius: 15 )
        signupButton.addTarget(self, action: #selector(signupTapped), for: .touchUpInside)


    }
    
    @objc func loginTapped() {
        goToVC(storyboard: .Welcome, identifiers: .LoginVC)
    }
    
    @objc func signupTapped() {
        goToVC(storyboard: .Welcome, identifiers: .SignUpVC)
    }

}
