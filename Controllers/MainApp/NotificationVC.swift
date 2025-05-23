//
//  NotificationVC.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 03/05/2025.
//

import UIKit

class NotificationVC: UIViewController {
    
    // MARK: - Outlets
@IBOutlet weak var persentageView: UIImageView!
    
    // MARK: - Variables - Arry


    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
}

// MARK: - UI Setup

extension NotificationVC {
    
    private func setupUI() {
        // تطبيق السمة العامة
        applyTheme()
        
        self.title = TitleBar.Notifications.titleName
    }
}
