//
//  MessageVC.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 03/05/2025.
//

import UIKit

class MessagesVC: UIViewController {
    
    // MARK: - Outlets

    
    // MARK: - Variables - Arry

    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        print("MessagesVC")
    }
    

    
}

// MARK: - UI Setup

extension MessagesVC {
    
    private func setupUI() {
        // تطبيق السمة العامة
        applyTheme()
        
        self.title = TitleBar.Messages.titleName

    }
}
