//
//  AccountVC.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 03/05/2025.
//

import UIKit

class AccountVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var hedeerView: UIView!
    @IBOutlet weak var editProfileIMageView: UIImageView!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoutLabel : UILabel!
    @IBOutlet weak var logoutImageView : UIImageView!
    @IBOutlet weak var signouttButton : UIButton!
    
    
    // MARK: - Variables - Arry

    private var accountItems: [Accounts] = [
        Accounts(title: .myQrCode, icon: .QRCode),
        Accounts(title: .purchase, icon: .paymoney),
        Accounts(title: .settings, icon: .settings),
        Accounts(title: .version, icon: .version)
    ]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // تطبيق السمة العامة
        enableInstantTheme(transitionStyle: .snapshot)

        setup()
    
    }
    
    // 🔄 دالة التحديث التلقائي للألوان (يتم استدعاؤها تلقائياً عند تغيير السمة)
    override func applyInstantThemeUpdate() {
        super.applyInstantThemeUpdate()
        // ✅ تحديث ألوان العناصر عند تغيير السمة
        updateThemeColors()
        
    }
  
    
}

// MARK: - UI Setup

extension AccountVC {
    
    func setup() {

        self.title = TitleBar.Account.titleName
        // 🎨 إعداد خلفية الشاشة العامة
        view.backgroundColor = ThemeManager.shared.color(.mainBackground)
        
        // 📝 إعداد العناوين والنصوص

        
        // 📝 إعداد العناوين والنصوص
        setupLabels()
        
        // 🖼️ إعداد الصور
        setupImageViews()
        
        //  إعداد المناظر (Views)
        setupViews()
        
        // 🔘 إعداد الأزرار
        setupButtons()
        
        // 📋 إعداد الجدول
        setupTV(tv: tableView)

        
        
    }
    
//    private func updateCustomUIElements() {
//        setupImageViews()
//        
//        
//        setupViews()
//
//    }
    
    private func setupLabels() {
        nameLabel.setupForInstantTheme(text: "الاسم", textColorSet: .text,
                                       font: .poppins, fontStyle: .extraBold,
                                       ofSize: .size_20 ,
                                       direction: .auto)
        
        roleLabel.setupForInstantTheme(text: "عضو نشط", textColorSet: .text,
                                       font: .poppins, ofSize: .size_12 ,
                                       direction: .auto)
        
        logoutLabel.setupForInstantTheme(text: Lables.signup.textLib, textColorSet: .onlyRed,
                                         font: .cairo, fontStyle: .semiBold,
                                         ofSize: .size_14 ,
                                         direction: .auto)

    }
    
    /// إعداد الصور والأيقونات
    private func setupImageViews() {
        profileImageView.image = UIImage(systemName: "person.circle.fill")
        logoutImageView.image = ThemeImage.image(named: AppImage.signout.rawValue)
        
    }
    
    private func setupViews() {
        hedeerView.addCorner(corners: [.topLeft , .topRight], radius: 16)
        hedeerView.setupForInstantTheme(backgroundColorSet: .headerBackground)
    }
    
    private func setupButtons() {
        // 🔗 ربط الإجراءات
        editProfileButton.addTarget(self, action: #selector(editProfileTapped), for: .touchUpInside)
        signouttButton.addTarget(self, action: #selector(signoutTapped), for: .touchUpInside)
    }
    
    @objc func editProfileTapped() {
        print("edit profile")
    }
    
    @objc func signoutTapped() {
        print("signout")
    }
    
    
    /// تحديث ألوان العناصر عند تغيير السمة
   
}

// MARK: - ✅ Theme Updates (التحديث التلقائي للألوان)

extension AccountVC {
    
    /// تحديث ألوان العناصر عند تغيير السمة
    private func updateThemeColors() {
        // 🎨 تحديث خلفية الشاشة
        view.backgroundColor = ThemeManager.shared.color(.mainBackground)
        
        // 📝 تحديث ألوان العناوين (تلقائي)
        updateLabelsTheme()
        
        // 🖼️ تحديث ألوان الصور (تلقائي)
        updateImageViewsTheme()
        
        // 🏗️ تحديث ألوان المناظر (تلقائي)
        updateViewsTheme()
        
        // 🔘 تحديث ألوان الأزرار (تلقائي)
        updateButtonsTheme()
        
        // 📋 تحديث ألوان الجدول (تلقائي)
        updateTableViewTheme()
        
        // 🎯 ملاحظة: هذه الدالة تستدعى تلقائياً عند تغيير السمة

    }
    
    /// تحديث ألوان العناوين
    private func updateLabelsTheme() {
        
        // ✅ تحديث تلقائي باستخدام المعاملات المحفوظة
        [nameLabel, roleLabel , logoutLabel].forEach { lables in
            lables?.updateInstantThemeColors()
        }
        
    }
    
    /// تحديث ألوان الصور
    private func updateImageViewsTheme() {
        [profileImageView , logoutImageView].forEach { images in
            images.updateInstantThemeColors()
        }
        
    }
    
    private func updateViewsTheme() {
        hedeerView.updateInstantThemeColors()
        tableView.updateInstantThemeColors()
    }
    
    /// تحديث ألوان الأزرار
    private func updateButtonsTheme() {
        [editProfileButton , signouttButton].forEach { buttons in
                //   buttons?.updateInstantThemeColors(titleColorSet: <#T##AppColors#>)
        }
    }
    
    /// تحديث ألوان الجدول
    private func updateTableViewTheme() {
        tableView.reloadData()
    }
}


extension AccountVC {
    
    private func setupTV(tv: UITableView) {
        tv.registerNib(cellType: .AcountTVCell ,
                              delegate: self , dataSource: self)
        tv.separatorStyle = .singleLine
        tv.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        tv.hideVerticalScrollIndicator()
        tv.disableScroll()
    }
}


extension AccountVC: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
                case 0:
                print("qu code")
                goToVC(storyboard: .Main ,  identifiers: .MyQRCodeVC , navigationStyle: .present(animated: true, completion: {
                }))
                case 1:
                print("payment")
                case 2:
                print("sttings")
                goToVC(storyboard: .Main, identifiers: .SettingsVC , navigationStyle: .present(animated: true, completion: nil))
            default:
                print("Version")

        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}

extension AccountVC: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(for: indexPath, cellType: AcountTVCell.self)
        let items = accountItems[indexPath.row]
        cell.configure(with: items)
        return cell
    }
    
    
}
