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
    @IBOutlet weak var editProfileBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoutLabel : UILabel!
    @IBOutlet weak var logoutImageView : UIImageView!
    @IBOutlet weak var logoutButton : UIButton!
    @IBOutlet weak var versionLabel: UILabel!
    
    
    // MARK: - Variables - Arry
    private var themeObserverID: UUID?
    private var accountItems: [Accounts] = [
        Accounts(title: .myQrCode, icon: .QRCode),
        Accounts(title: .purchase, icon: .paymoney),
        Accounts(title: .settings, icon: .settings),
        Accounts(title: .logout, icon: .signout)
    ]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // تحديث أي عناصر خاصة عند تغيير السمة
        themeObserverID = setupThemeObserver { [weak self] in
            self?.updateCustomUIElements()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // تنظيف وازالة العناصر
        clearThemeObserver(id: themeObserverID)
        themeObserverID = nil
    }
    
    deinit {
        // تأكيد إضافي على تنظيف الموارد
        clearThemeObserver(id: themeObserverID)
        themeObserverID = nil
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setup()
        updateCustomUIElements()
    }
    
}

// MARK: - UI Setup

extension AccountVC {
    
    func setup() {
        // تطبيق السمة العامة
        applyTheme()
        self.title = TitleBar.Account.titleName
        updateCustomUIElements()
        setupTV(tv: tableView)
        
    }
    
    private func updateCustomUIElements() {
        nameLabel.customize(text: "الاسم",
                            color: .text, ofSize: .size_20,
                            font: .poppins , fontStyle: .extraBold)
        roleLabel.customize(text: "عضو نشط",
                            color: .text, ofSize: .size_12, font: .poppins)
        setupViews()
        logoutLabel.customize(text: Lables.signup.textLib,
                              color: .onlyRed, ofSize: .size_14,
                              font: .cairo , fontStyle: .semiBold)
    }
    
    private func setupImageViews() {
        profileImageView.image = UIImage(systemName: "person.circle.fill")
        logoutImageView.image = ThemeImage.image(name: AppImage.signout.rawValue)
        
    }
    
    private func setupViews() {
        hedeerView.setThemeBackgroundColor(.headerBackground)
        hedeerView.addCorner(corners: [.topLeft , .topRight], radius: 16)
        
    }
}


extension AccountVC {
    
    private func setupTV(tv: UITableView) {
        tv.registerNib(cellType: .AcountTVCell ,
                              delegate: self , dataSource: self)
        tv.separatorStyle = .singleLine
        tv.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
    }
}


extension AccountVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
                case 0:
                print("qu code")
                case 1:
                print("payment")
                case 2:
                print("Version")
            default:
                print("sttings")
        }
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
