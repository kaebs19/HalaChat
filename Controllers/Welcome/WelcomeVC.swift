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
    @IBOutlet var loginView: UIView!
    @IBOutlet weak var signupView: UIView!
    @IBOutlet weak var loginLaibel: UILabel!
    @IBOutlet weak var signupLaibel: UILabel!
    
    
    // MARK: - Variables - Arry
    private var themeObserverId: UUID?
    private var signupViewThemeObserver: UUID?

    
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
        if let observer = signupViewThemeObserver {
            ThemeManager.shared.removeThemeObserver(id: observer)
            signupViewThemeObserver = nil
        }

    }
    
    deinit {
        // تأكيد إضافي على تنظيف الموارد
        clearThemeObserver(id: themeObserverId)
        
        if let observer = signupViewThemeObserver {
            ThemeManager.shared.removeThemeObserver(id: observer)
            signupViewThemeObserver = nil
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    // MARK: - Actions
    
    
}

// MARK: - UI Setup
extension WelcomeVC {
    
    private func setupUI() {
        
        applyTheme()
        
        hideBackButton()  // إخفاء زر العودة
        updateCustomUIElements()
    
        // Action
        setupTapGestures()
    }
    
    private func updateCustomUIElements() {
        patternImageView.semanticContentAttribute = .forceLeftToRight
        // تنسيق العناوين
        titleLabel.customize(text: Lables.findNew.textLib,
                             colorSet: .text, ofSize: .size_32,
                             font: .poppins, fontStyle: .extraBold,
                             direction: .auto, lines: 2)
        titleLabel.backgroundColor = .clear
        subtitleLabel.customize(text: Lables.findNewSubtitle.textLib,
                                colorSet: .text, ofSize: .size_16,
                                font: .cairo,
                                direction: .auto, lines: 0)
        subtitleLabel.backgroundColor = .clear
        
        loginLaibel.customizeWithColor(text: Lables.login.textLib,
                                       color: .CFFFFFF, ofSize: .size_18, font: .poppins ,fontStyle: .extraBold)
        
        signupLaibel.customizeWithColor(text: Lables.signup.textLib,
                                        color: .CFF2D55, ofSize: .size_18, font: .poppins ,fontStyle: .extraBold)
        
        signupLaibel.backgroundColor = .clear
        loginLaibel.backgroundColor = .clear
        
        [loginView , signupView].forEach { view in
            view.layer.cornerRadius = 25
            view.clipsToBounds = true
        }
        loginView.applyGradient(colors: [.CF54B64_Start , .CF78361_End] , direction: .horizontal)
        signupView.backgroundColor = ThemeManager.shared.isDarkMode ?
            Colors.CFFFFFF.uitColor : // لون أبيض في الوضع الداكن
            UIColor.black            // لون أسود في الوضع الفاتح

    }
    
    
    private func setupButtonLabels() {
        // إزالة أي خلفية للنصوص
        [loginLaibel , signupView].forEach { lable in
            lable?.backgroundColor  = .clear
        }
    }
    
    private func setupTapGestures() {
        // إعداد مستمع النقر لزر تسجيل الدخول

        loginView.isUserInteractionEnabled = true
        let loginAction = UITapGestureRecognizer(target: self, action: #selector(handleLogin))
        loginView.addGestureRecognizer(loginAction)
        
        // إعداد مستمع النقر لزر إنشاء الحساب

        signupView.isUserInteractionEnabled = true
        let signupAction = UITapGestureRecognizer(target: self, action: #selector(handleSignup))
        signupView.addGestureRecognizer(signupAction)

    }

    
    
    @objc private func handleLogin() {
        print("handleLogin")
        goToVC(storyboard: .Welcome , identifiers: .LoginVC)
        UIImpactFeedbackGenerator(style: .light).impactOccurred()

    }
    
    @objc private func handleSignup() {
        print("handleSignup")
       // UIImpactFeedbackGenerator(style: .light).impactOccurred()
        goToVC(storyboard: .Welcome , identifiers: .SignUpVC)
    }
}
