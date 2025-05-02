//
//  MainBars.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 02/05/2025.
//

import UIKit

class MainBars: UITabBarController {
    
    // MARK: - Properties
    private var selectedIndexs: Int = 0
    private var themeObserver: UUID?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
}

extension MainBars {
    
    // MARK: - UI Setup
    func setupUI() {
        
    }
    
    /// custom Icons and Texts
    private func customizeIconsAndTexts() {
        let appearance = UITabBarAppearance()

        // costom background

        
        // custom Texts

    }
}

struct TabBarItemConfig {
    let title: TitleBar
    let selectedImage: UIImage
    let unselectedImage: UIImage
}


enum TitleBar: String, CaseIterable {
    case Home = "HomeTitle"
    case Categories = "MassageTitle"
    case Featured = "ExploreTitle"
    case Account = "AccountTitle"
}
