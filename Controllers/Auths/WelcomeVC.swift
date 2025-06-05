//
//  Welcome.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 15/04/2025.
//

import UIKit

final class WelcomeVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    
    // MARK: - Properties
    
    /// حالة التحميل للأزرار
    private var isLoading = false {
        didSet {
            updateButtonState()
        }
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // تطبيق السمات
        enableInstantTheme(transitionStyle: .crossDissolve)
        setupUI()
        setupNavigationTitle()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signupButton.reapplyGradient()
        setupUI()
    }
    
    override func applyInstantThemeUpdate() {
        super.applyInstantThemeUpdate()
        // ✅ تحديث الألوان فقط عند تغيير السمة
        updateThemeColors()
        updateNavigationTitle()
    }
    
    
    // MARK: - Actions
    
    
}

extension WelcomeVC {
    
    private func setupUI() {
        setupBackground()
        setupLabels()
        setupButtons()
        
    }
    
    private func setupNavigationTitle() {
        setStyledTitle(title: .welcomeToHalaChat)
    }
    
    /// تحديث ألوان السمة فقط
    private func updateThemeColors() {
        // ✅ تحديث الخلفية
        view.backgroundColor = ThemeManager.shared.color(.mainBackground)
        
        // ✅ تحديث النصوص
        title = "Texst Title"
        titleLabel.updateInstantThemeColors()
        subtitleLabel.updateInstantThemeColors()
        
        // ✅ تحديث الأزرار
        loginButton.updateInstantThemeColors()
        signupButton.updateInstantThemeColors()
        signupButton.reapplyGradient()
    }
    
    /// إعداد خلفية الشاشة
    private func setupBackground() {
        view.backgroundColor = ThemeManager.shared.color(.mainBackground)
    }
    
    private func setupLabels() {
        titleLabel.setupForInstantTheme( text: Lables.findNew.textLib,
                                         textColorSet: .text,
                                         font: .poppins, fontStyle: .extraBold,
                                         ofSize: .size_18 ,
                                         direction: .Center)
        
        subtitleLabel.setupForInstantTheme( text: Lables.welcomeSubtitle.textLib,
                                            textColorSet: .text,
                                            font: .cairo, fontStyle: .extraBold,
                                            ofSize: .size_16 ,
                                            direction: .Center ,
                                            lines: 3)
    }
    
    private func setupViews() {
        
    }
    
    private func setupButtons() {
        setupLoginButton()
        setupSignupButton()
    }
    
    private func setupLoginButton() {
        loginButton.setupForInstantTheme(title: Buttons.login,
                                         titleColorSet: .invertText,
                                         backgroundColorSet: .invertBackground ,
                                         ofSize: .size_18,
                                         font: .cairo ,fontStyle: .bold,
                                         cornerRadius: 15 ,
                                         enablePressAnimation: true
    )
        
        loginButton.addTarget(self,
                              action: #selector(loginButtonTapped),
                              for: .touchUpInside)
        
    }
    
    private func setupSignupButton() {
        signupButton.applyGradient(startColor: .Start,
                                   endColor: .End ,
                                   direction: .diagonalTopRightToBottomLeft ,
                                   respectDarkMode: true)
        
        signupButton.setupForInstantTheme(title: Buttons.signup,
                                          titleColorSet: .onlyWhite,
                                          ofSize: .size_18,
                                          font: .cairo ,fontStyle: .bold,
                                          cornerRadius: 15 ,
                                          enablePressAnimation: false
        )
        
        signupButton.addTarget(self,
                               action: #selector(signupButtonTapped),
                               for: .touchUpInside)
        
    }
    
    private func updateButtonState() {
        loginButton.isEnabled = !isLoading
        signupButton.isEnabled = !isLoading
        
        // ✅ إظهار مؤشر التحميل عند الحاجة
        if isLoading {
            loginButton.showLoading()
            signupButton.showLoading()
        } else {
            loginButton.hideLoading()
            signupButton.hideLoading()
        }
    }
    
    
}

extension WelcomeVC {
    
    
    @objc func loginButtonTapped() {
        //    goToVC(storyboard: .Welcome, identifiers: .LoginVC)
        goToVC(storyboard: .Main, identifiers: .MainBars)
        
        guard !isLoading else { return }
        // ✅ تأثير اهتزاز خفيف
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
        // ✅ تحريك الانتقال
        animateTransition{
            self.navigateToLogin()
            
        }
    }
    
    
    @objc func signupButtonTapped() {
        // ✅ منع الضغط المتعدد
        guard !isLoading else { return }
        
        // ✅ تأثير اهتزاز متوسط
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        
        // ✅ تحريك الانتقال
        animateTransition {
            self.navigateToSignup()
        }
    }
    
    func animateTransition(completion: @escaping () -> Void) {
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                self.view.alpha = 0.8
                self.view.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            },
            completion: { _ in
                completion()
                // ✅ إعادة الشاشة لحالتها الطبيعية
                UIView.animate(withDuration: 0.2) {
                    self.view.alpha = 1.0
                    self.view.transform = .identity
                }
            }
        )
    }
    
}

// MARK: - Navigation

extension WelcomeVC {
    
    /// الانتقال لشاشة تسجيل الدخول
    func navigateToLogin() {
        
        // ✅ للتطوير: الانتقال المباشر للشاشة الرئيسية
                #if DEBUG
        goToVC(storyboard: .Main, identifiers: .MainBars)
                #else
        goToVC(storyboard: .Main, identifiers: .LoginVC)
                #endif
    }
    
    /// الانتقال لشاشة التسجيل الجديد
    func navigateToSignup() {
        goToVC(storyboard: .Welcome, identifiers: .SignUpVC)
    }
}

