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
 //   @IBOutlet weak var qrCodeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var myQrCodeView: UIView!
    @IBOutlet  var iconsViews: [UIView]!

    
    // MARK: - Variables - Arry
    private var themeObserver: UUID?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // تحديث أي عناصر خاصة عند تغيير السمة
        themeObserver = setupThemeObserver { [weak self] in
            self?.updateCustomUIElements()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // تنظيف وازالة العناصر
         clearThemeObserver(id: themeObserver)
        themeObserver = nil
    }
    
    deinit {
        // تأكيد إضافي على تنظيف الموارد
        clearThemeObserver(id: themeObserver)
        themeObserver = nil
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
        // تطبيق السمة العامة
        applyTheme()
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
