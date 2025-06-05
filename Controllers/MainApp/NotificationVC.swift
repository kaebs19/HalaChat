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
        
        // تطبيق السمة العامة
        enableInstantTheme(transitionStyle: .snapshot)
    }
    
    override func applyInstantThemeUpdate() {
        super.applyInstantThemeUpdate()
        updateViewConstraints()
    }
    
}

// MARK: - UI Setup

extension NotificationVC {
    
    private func setupUI() {
        self.title = TitleBar.Notifications.titleName
    }
}
