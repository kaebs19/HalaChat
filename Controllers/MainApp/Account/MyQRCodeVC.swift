//
//  MyQRCodeVC.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 13/05/2025.
//

import UIKit

class MyQRCodeVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var claseImageView: UIImageView!
    @IBOutlet weak var claseButton: UIButton!
   // @IBOutlet weak var qrCodeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var myQrCodeView: UIView!
    @IBOutlet  var iconsViews: [UIView]!
    @IBOutlet weak var sharImageView: UIImageView!
    @IBOutlet weak var saveImageView: UIImageView!
    @IBOutlet weak var refreshImageView: UIImageView!

    
    // MARK: - Variables - Arry

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // تطبيق السمة العامة
        enableInstantTheme(transitionStyle: .crossDissolve)
    }
    
    override func applyInstantThemeUpdate() {
        super.applyInstantThemeUpdate()
        updateCustomUIElements()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setup()
        updateCustomUIElements()
    }
    
}


// MARK: - UI Setup

extension MyQRCodeVC {
    
    private func setup() {

        self.view.setThemeBackgroundColor(.mainBackground)
        updateCustomUIElements()
    }
    
    private func updateCustomUIElements() {
        titleLabel.customize(text: Titles.MyQrCode.textTitle,
                             color: .text, ofSize: .size_16, font: .poppins)

        
        setupImageViews()
        setupViews()
        setupButtons()
    }
    
    private func setupImageViews() {
        sharImageView.image = ThemeImage.tintedImage(for: .Share, with: .iconTint)
        saveImageView.image = ThemeImage.tintedImage(for: .Save, with: .text)
        refreshImageView.image = ThemeImage.tintedImage(for: .Refresh, with: .text)
        
    }
    
    private func setupViews() {
        containerView.setThemeBackgroundColor(.titleViewBackground)
        
        myQrCodeView.addRadius(6)
        
        iconsViews.forEach { view in
            view.makeCircular()
            view.setThemeBackgroundColor(.secondBackground)
            
        }
    }
    
    private func setupButtons() {
        claseButton.addTarget(self,
                              action: #selector(claseButtonAction), for: .touchUpInside)
    }
    
    @objc func claseButtonAction() {
        print("Done Dismiss")
        dismissViewController()
    }
}
