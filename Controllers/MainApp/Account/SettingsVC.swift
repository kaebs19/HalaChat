//
//  SettingVC.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 18/05/2025.
//

import UIKit

class SettingsVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var settingsTableView: UITableView!
    
    
    // MARK: - Variables - Arry
   private var themeObserver: UUID?
    private var settingsList: [[Settings]] = []
    
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
        themeObserver  = nil
    }
}

extension SettingsVC {
    
    private func setup() {
        // تطبيق السمات
        applyTheme()
        view.backgroundColor = ThemeManager.shared.color(.mainBackground)
        updateCustomUIElements()
    }
    
    private func updateCustomUIElements() {
        titleLabel.customize(text: Titles.Settings.textTitle,
                             color: .text, ofSize: .size_16, font: .poppins)
        
        setupViews()
        
        setupButtons()

    }
    
    private func setupViews() {
        containerView.setupContainerView(
            withColor: .titleViewBackground,
            radius: 16,
            corners: [.topLeft, .topRight],)
        
    }
    
    private func setupButtons() {
        closeButton.addTarget(self,
                              action: #selector(closeButtonTapped),
                              for: .touchUpInside)
    }
    
    @objc private func closeButtonTapped() {
        print("Done Tapped !")
        dismissViewController()
    }
    
    private func setupTableView(tv: UITableView) {
        // تسجيل خلية الإعدادات
        tv.register(SettingTVCell.self, forCellReuseIdentifier: SettingTVCell.identifier)
        
        // إعداد مندوبي الجدول
        tv.delegate = self
        tv.dataSource = self
        
        // إعداد مظهر الجدول
        tv.backgroundColor = .clear
        tv.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        tv.configureSeparator()
        tv.hideVerticalScrollIndicator()
        
        // تهيئة بيانات الإعدادات
        setupSettingsData()

    }
    
    private func setupSettingsData() {
        
        // القسم الأول: إعدادات الحساب
        let acountSection = [
            Settings(icon: .AccountSettings,
                     title: .account,
                     subtitle: nil,
                     switchVisible: false,
                     switchOn: false,
                     actionType: .navigate,
                     tintColor: .text)
        ]
        // القسم الثاني: الإشعارات والرسائل والمكالمات والمظهر
        let communicationSection = [
            Settings(icon: .Notification,
                     title: .notification,
                     subtitle: nil,
                     switchVisible: true,
                     switchOn: true,
                     actionType: .toggle,
                     tintColor: .text),
            Settings(icon: .Message,
                     title: .message,
                     subtitle: nil,
                     switchVisible: false, switchOn: false,
                     actionType: .navigate,
                     tintColor: .text),
            Settings(icon: .Appearance,
                     title: .appearance,
                     subtitle: isEnglish() ? Lables.lightMode.textLib : Lables.darkMode.textLib,
                     switchVisible: false, switchOn: false,
                     actionType: .navigate, tintColor: .text)
        ]
        
        // القسم الثالث: عام
        let generalSection = [
            Settings(icon: .Annoucement,
                     title: .Announcements,
                     subtitle: nil,
                     switchVisible: false, switchOn: false,
                     actionType: .navigate,
                     tintColor: .text),
            
            Settings(icon: .Helpcenter,
                     title: .HelpCenter,
                     subtitle: nil,
                     switchVisible: false, switchOn: false,
                     actionType: .navigate,
                     tintColor: .text),
            
            Settings(icon: .Privacy,
                     title: .Privacy,
                     subtitle: nil,
                     switchVisible: false, switchOn: false,
                     actionType: .navigate,
                     tintColor: .text),
            
            Settings(icon: .Info,
                     title: .AboutUs ,
                     subtitle: nil,
                     switchVisible: false, switchOn: false,
                     actionType: .navigate,
                     tintColor: .text)
        ]
        
        // تجميع الأقسام
        settingsList = [acountSection, communicationSection, generalSection]
        // تحديث الجدول
        settingsTableView.reloadData()
        
    }
}


// MARK: - UITableViewDelegate

extension SettingsVC: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource

extension SettingsVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}
