//
//  ViewController.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 08/04/2025.
//

import UIKit

class HomeVC: UIViewController {
    

    // MARK: - Outlets

    @IBOutlet weak var titleLabel: UILabel!
    
    
    // MARK: - Variables - Arry
    // معرّف المراقب للسمة
    private var themeObserverId: UUID?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }


}


extension HomeVC {
    
    private func setupUI() {
        
    }
}
