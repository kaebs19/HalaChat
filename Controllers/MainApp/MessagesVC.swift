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
        enableInstantTheme(transitionStyle: .crossDissolve)
        
    }
    

    
}

// MARK: - UI Setup

extension MessagesVC {
    
    override func applyInstantThemeUpdate() {
        // تحديث العناصر
        updateCustomElements()
    }
    
    private func setupUI() {
        // تطبيق السمة العامة
        
        
        self.title = TitleBar.Messages.titleName

    }
    
    private func updateCustomElements() {
        
    }
}
