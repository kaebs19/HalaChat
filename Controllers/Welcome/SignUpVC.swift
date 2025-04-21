//
//  SignUpVC.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 20/04/2025.
//

import UIKit

class SignUpVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    

    
}


extension SignUpVC {
    
    private func setupUI() {
        // تطبيق السمة العامة
        applyTheme()
        title = Titles.SignUp.textTitle
       
        setupNavigationBar(items: [.BackButton])
    }
}
