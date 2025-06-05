////
////  LoginVC.swift
////  HalaChat
////
////  Created by Mohammed Saleh on 19/04/2025.
////
//
//import UIKit
//
//class LoginVC: UIViewController {
//    
//    // MARK: - Outlets
//    @IBOutlet weak var titleLabel: UILabel!
//    @IBOutlet weak var subtitleLabel: UILabel!
//    @IBOutlet  var mainView: [UIView]!
//    @IBOutlet weak var emailTextField: UITextField!
//    @IBOutlet weak var passwordTextField: UITextField!
//    @IBOutlet weak var loginButton: UIButton!
//    @IBOutlet weak var forgotPasswordButton: UIButton!
//    @IBOutlet weak var showPasswordImageView: UIImageView!
//    
//    // MARK: - Variables - Arry
//    // متغير لتتبع حالة إظهار كلمة المرور
//
//    var isShowPassword: Bool = false {
//        didSet {
//            passwordTextField.togglePassword()
//            let imageName = isShowPassword ? "eye.slash" : "eye"
//            let newImage = UIImage(systemName: imageName)
//            // استخدام التأثير الانتقالي من امتداد UIImage
//
//            UIImage.applyThemeTransition(to: showPasswordImageView,
//                                         image: newImage,
//                                         colorSet: .text)
//          
//        }
//    }
//
//    
//    // MARK: - Lifecycle
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // تطبيق السمة العامة
//        enableInstantTheme(transitionStyle: .crossDissolve)
//        setup()
//     
//    }
//    
//
//    override func applyInstantThemeUpdate() {
//        super.applyInstantThemeUpdate()
//        setup()
//    }
//   
//    
//    @IBAction func showPasswordClickBut(_ sender: UIButton) {
//
//        // تحديد الصورة الجديدة قبل التبديل
//           let imageName = !isShowPassword ? "eye.slash" : "eye"
//           let newImage = UIImage(systemName: imageName)
//           
//           // تطبيق تأثير الدوران
//           UIImage.applyThemeFlipTransition(
//               to: showPasswordImageView,
//               image: newImage,
//               colorSet: .text,
//               direction: .vertical
//           )
//           
//           // تبديل حالة إظهار كلمة المرور
//           isShowPassword.toggle()
//           passwordTextField.togglePassword()
//    }
//}
//
//// MARK: - UI Setup
//
//extension LoginVC {
//    
//    private func setup() {
//        
//        view.backgroundColor = ThemeManager.shared.color(.mainBackground)
//        setupNavigationBar(items: [.BackButton])
//        
//        self.title = Titles.Login.textTitle
//        
//        // تحديث العناصر
//        setupLabels()
//        
//        // تحديث View
//        setupView()
//        
//        // تحديث TextField
//        setupTextFields()
//        
//        // تحديث الازرار
//        setupButtons()
//        
//    }
//
//    private func setupLabels() {
//        
//        titleLabel.setupForInstantTheme( text: Lables.welcome.textLib,
//                                         textColorSet: .text
//                                         , font: .cairo, fontStyle: .extraBold,
//                                         ofSize: .size_16)
//        
//                                
//        subtitleLabel.setupForInstantTheme(text: Lables.welcomeSubtitle.textLib,
//                                           textColorSet: .text,
//                                           font: .poppins, fontStyle: .bold,
//                                           ofSize: .size_16 ,lines: 3 )
//    }
//    
//    
//    
//    private func setupView() {
//        mainView.forEach { view in
//            view.addRadius(15)
//            view.backgroundColor = ThemeManager.shared.color(.secondBackground)
//        }
//    }
//    
//    private func setupTextFields() {
//        emailTextField.customizePlaeholder(plaeholder: .email ,
//                                       placeholderColor: .placeholderColor,
//                                       font: .poppins , fontStyle: .semiBold ,
//                                       direction: .auto)
//        emailTextField.customizeText()
//        
//        passwordTextField.customizePlaeholder(plaeholder: .password ,
//                                       placeholderColor: .placeholderColor,
//                                       font: .poppins , fontStyle: .semiBold ,
//                                       direction: .auto)
//        passwordTextField.customizeText()
//        
//    }
//    
//    private func setupButtons() {
//        loginButton.applyGradient(startColor: .Start, endColor: .End ,direction: .diagonalTopLeftToBottomRight ,respectDarkMode: true)
//        loginButton.setupForInstantTheme(title: .login,
//                                         titleColorSet: .onlyRed,
//                                         ofSize: .size_18,
//                                         font: .cairo ,fontStyle: .bold
//                                         ,cornerRadius: 15)
//        
//        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
//        
//        forgotPasswordButton.setupForInstantTheme(title: .forgotPassword,
//                                                  titleColorSet: .text, ofSize: .size_14, font: .poppins)
//        forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordTapped), for: .touchUpInside)
//        
//    }
//    
//    @objc func loginTapped() {
//        print(" loginTapped")
//    }
//    
//    @objc func forgotPasswordTapped() {
//        goToVC(storyboard: .Welcome, identifiers: .ForgetPasswordVC)
//    }
//}
//
//
//
