//
//  SignUpVC.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 20/04/2025.
//

import UIKit

class SignUpVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet  var mainView: [UIView]!
    
    // MARK: - Variables - Arry
    private var themeObserverId: UUID?

    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
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

    // تنظيف وازالة العناصر اظافي
    deinit {
        clearThemeObserver(id: themeObserverId)
        themeObserverId = nil
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUI()
    }
}


extension SignUpVC {
    
    private func setupUI() {
        // تطبيق السمة العامة
        applyTheme()

        setStyledTitle(title: .SignUp)
       
        setupNavigationBar(items: [.BackButton])
        
        updateCustomUIElements()
    }
    
    func updateCustomUIElements() {
        titleLabel.customize(text: Lables.createAccount.textLib,
                             color: .text,
                            ofSize: .size_22,
                            font: .poppins , fontStyle: .extraBold)
        
        setupViews()
        setupTextFields()

    }
    
    func setupViews() {
        mainView.forEach { views in
            views.setThemeBackgroundColor(.secondBackground)
            views.addRadius(15)
        }
    }
    
    func setupTextFields() {
        
    }
}
