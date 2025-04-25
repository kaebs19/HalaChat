//
//  Welcome.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 15/04/2025.
//

import UIKit

class WelcomeVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var patternImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var signupView: UIView!
    @IBOutlet weak var loginLaibel: UILabel!
    @IBOutlet weak var signupLaibel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
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
        titleLabel.customize(text: Lables.welcome.textLib,
                             color: .text, ofSize: .size_20,
                             font: .poppins , fontStyle: .extraBold)
        subtitleLabel.customize(text: Lables.welcomeSubtitle.textLib,
                             color: .text, ofSize: .size_16,
                             font: .poppins , fontStyle: .bold)
        
        setupViews()
        
        setupButton()
    }
    
    private func setupViews() {
        loginView.applyGradient(startColor: .Start, endColor: .End ,direction: .diagonalTopRightToBottomLeft)
        loginView.addRadius(15)
        
        signupView.applyGradient(startColor: .BlueStart, endColor: .BlueEnd , direction: .diagonalTopLeftToBottomRight ,respectDarkMode: true)
        signupView.addRadius(15)
    }
    
    private func setupButton() {
        loginButton.backgroundColor = AppColors.background.color
    }
}
