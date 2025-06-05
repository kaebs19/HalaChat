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
    

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        print("HomeVC")
        
        // ✅ إضافة: تفعيل نظام السمة الجديد
        enableInstantTheme(transitionStyle: .crossDissolve)
        
    }
    
    
    
}


extension HomeVC {
    
    // ✅ إضافة: تنفيذ بروتوكول السمة الجديد
    override func applyInstantThemeUpdate() {
        super.applyInstantThemeUpdate()
        
        // تحديثات خاصة بـ HomeVC
        updateCustomElements()
    }
    
    // ✅ إضافة: دالة لتحديث العناصر المخصصة
    private func updateCustomElements() {
        // تحديث خلفية الشاشة
        view.backgroundColor = ThemeManager.shared.color(.mainBackground)
        
        // تحديث الأزرار المخصصة
        updateCustomButton()
        
        // تحديث العنوان
        updateTitle()
    }
    
    // ✅ إضافة: تحديث الزر المخصص
    private func updateCustomButton() {

    }
    
    // ✅ إضافة: تحديث العنوان
    private func updateTitle() {
        self.title = TitleBar.Home.titleName
    }
}

extension HomeVC {
    
    private func setupUI() {
        
        // ✅ تحديث: استخدام ThemeManager الجديد
        view.backgroundColor = ThemeManager.shared.color(.mainBackground)
        
        self.title = TitleBar.Home.titleName
        
        // إعداد الزر
        setupButton()
    }
    
    // ✅ إضافة: دالة منفصلة لإعداد الزر
    private func setupButton() {

    }
}
