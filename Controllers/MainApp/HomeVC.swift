//
//  ViewController.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 08/04/2025.
//

import UIKit

class HomeVC: UIViewController {
    

    // MARK: - Outlets

    @IBOutlet weak var showMessagesButton: UIButton!
    
    // MARK: - Variables - Arry
    // معرّف المراقب للسمة
    private var themeObserverId: UUID?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        print("HomeVC")
    }


}


extension HomeVC {
    
    private func setupUI() {
        // تطبيق السمة العامة
        applyTheme()
    
        self.title = TitleBar.Home.titleName
        
        if let button = showMessagesButton {
            button.applyGradient(startColor: .Start, endColor: .End, direction: .horizontal, respectDarkMode: true)
            button.addRadius(20)
        } else {
            print("Warning: showMessagesButton is nil!")
        }
    }
}
