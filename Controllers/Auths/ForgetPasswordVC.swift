////
////  ForgetPasswordVC.swift
////  HalaChat
////
////  Created by Mohammed Saleh on 06/05/2025.
////
//
//import UIKit
//
//class ForgetPasswordVC: UIViewController {
//    
//    // MARK: - Outlets
//    @IBOutlet weak var passwordSutitleLbl: UILabel!
//    @IBOutlet weak var passwordTextField: UITextField!
//    @IBOutlet weak var passwordView: UIView!
//    @IBOutlet weak var sendButton: UIButton!
//    
//    // MARK: - Variables - Arry
//    
//    
//    // MARK: - Lifecycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//                
//        // تطبيق السمات
//        enableInstantTheme(transitionStyle: .crossDissolve)
//    }
//    
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        setupUI()
//        updateCustomUIElements()
//    }
//    
//}
//
//// MARK: - UI Setup
//
//extension ForgetPasswordVC {
//    
//    private func setupUI() {
//        
//        setupNavigationBar(items: [.BackButton])
//        setStyledTitle(title: .forgotPassword,
//                       fontStyle: .extraBold ,FontSize: .size_22  ,
//                       useLargeTitle: true)
//        updateCustomUIElements()
//    }
//    
//    private func updateCustomUIElements() {
//        passwordSutitleLbl.customize(text: Lables.forgotPasswordSubtitle.textLib,
//                                     color: .text,
//                                     ofSize: .size_16, font: .poppins , fontStyle: .bold ,
//                                     lines: 3)
//        setupViews()
//        
//        setupTextFields()
//        
//        setupButtons()
//    }
//    
//    private func setupViews() {
//        passwordView.backgroundColor = ThemeManager.shared.color(.secondBackground)
//        passwordView.addRadius(15)
//    }
//    
//    private func setupTextFields() {
//        passwordTextField.customizePlaeholder(plaeholder: .password)
//        passwordTextField.customizeText()
//    }
//    
//    private func setupButtons() {
//        sendButton.setupForInstantTheme( title: .send ,
//                                         titleColorSet: .onlyWhite,
//                                         ofSize: .size_18,
//                                         font: .poppins , fontStyle: .extraBold ,
//                                         enablePressAnimation: true)
//        
//        sendButton.addRadius(15)
//        sendButton.applyGradient(startColor: .Start, endColor: .End , direction: .diagonalTopRightToBottomLeft , respectDarkMode: true)
//
//    }
//    
//    
//}
