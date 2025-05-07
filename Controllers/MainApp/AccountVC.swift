//
//  AccountVC.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 03/05/2025.
//

import UIKit

class AccountVC: UIViewController {

    // MARK: - Outlets

    
    // MARK: - Variables - Arry

    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()

    }
    
    
}

// MARK: - UI Setup

extension AccountVC {
    
    func setup() {
        // تطبيق السمة العامة
        applyTheme()
        
        self.title = TitleBar.Account.titleName

    }
}
