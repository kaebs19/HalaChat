//
//  SignUpVC.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 20/04/2025.
//

import UIKit

class SignUpVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var usernameView: UIView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    
    // MARK: - Variables - Arry
    private var themeObserverId: UUID?

    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        // تطبيق السمة العامة
        applyTheme()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("تم تغيير السمة - تحديث العناصر")

        themeObserverId = setupThemeObserver { [weak self] in
            self?.updateCustomUIElements()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // تنظيف وازالة العناصر

        clearThemeObserver(id: themeObserverId)
        if let observer = themeObserverId {
            ThemeManager.shared.removeThemeObserver(id: observer)
        }
    }
    
    deinit {
        clearThemeObserver(id: themeObserverId)
        themeObserverId = nil
    }
}


extension SignUpVC {
    
    private func setupUI() {
        setStyledTitle(title: .SignUp)
       
        setupNavigationBar(items: [.BackButton])
        
        updateCustomUIElements()
        setupViews()
        setupTextFields()
    }
    
    func updateCustomUIElements() {
        
    }
    
    func setupViews() {
        
    }
    
    func setupTextFields() {
        
    }
}
