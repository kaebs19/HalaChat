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
    private var themeObserverID: UUID?
    private var accountItems: [Accounts] = [
        Accounts(title: .myQrCode, icon: .QRCode),
        Accounts(title: .purchase, icon: .paymoney),
        Accounts(title: .settings, icon: .settings),
        Accounts(title: .version, icon: .version)
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
    
    private func setupButtons() {
        editProfileButton.addTarget(self, action: #selector(editProfileTapped), for: .touchUpInside)
        signouttButton.addTarget(self, action: #selector(signoutTapped), for: .touchUpInside)
    }
    
    @objc func editProfileTapped() {
        print("edit profile")
    }
    
    @objc func signoutTapped() {
        print("signout")
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
                print("Version")
            default:
                print("sttings")
                goToVC(storyboard: .Main, identifiers: .SettingsVC , navigationStyle: .present(animated: true, completion: nil))
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
