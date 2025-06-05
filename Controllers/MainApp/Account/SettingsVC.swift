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
    
    // MARK: - Variables
    
    private var settingsList: [[Settings]] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        // تطبيق السمات
        enableInstantTheme(transitionStyle: .snapshot)
    }
    
    override func applyInstantThemeUpdate() {
        super.applyInstantThemeUpdate()
        updateCustomUIElements()
    }
    
    
}

// MARK: - Setup Methods
extension SettingsVC {
    
    private func setup() {

        view.backgroundColor = ThemeManager.shared.color(.mainBackground)
        updateCustomUIElements()
    }
    
    private func updateCustomUIElements() {
        titleLabel.customize(text: Titles.Settings.textTitle,
                             color: .text, ofSize: .size_16, font: .poppins)
        
        setupViews()
        setupButtons()
        setupTableView(tv: settingsTableView)
    }
    
    private func setupViews() {
        containerView.setupContainerView(
            withColor: .titleViewBackground,
            radius: 16,
            corners: [.topLeft, .topRight])
    }
    
    private func setupButtons() {
        closeButton.addTarget(self,
                              action: #selector(closeButtonTapped),
                              for: .touchUpInside)
    }
    
    @objc private func closeButtonTapped() {
        dismissViewController()
    }
    
    private func setupTableView(tv: UITableView) {
        // تسجيل خلية الإعدادات
        tv.register(SettingTVCell.self, forCellReuseIdentifier: SettingTVCell.identifier)
        
        // إعداد مندوبي الجدول
        tv.delegate = self
        tv.dataSource = self
        
        // إعداد مظهر الجدول المُحسن
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.showsVerticalScrollIndicator = false
        tv.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 16, right: 0)
        tv.rowHeight = 60
        tv.estimatedRowHeight = 60
        
        // تهيئة بيانات الإعدادات
        setupSettingsData()
    }
    
    private func setupSettingsData() {
        // القسم الأول: إعدادات الحساب
        let accountSection = [
            Settings(icon: .AccountSettings,
                     title: .account,
                     subtitle: nil,
                     switchVisible: false,
                     switchOn: false,
                     actionType: .navigate,
                     tintColor: .text)
        ]
        
        // القسم الثاني: الإشعارات والرسائل والمظهر
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
                     switchVisible: false,
                     switchOn: false,
                     actionType: .navigate,
                     tintColor: .text),
            Settings(icon: .Appearance,
                     title: .appearance,
                     subtitle: getThemeSubtitle(),
                     switchVisible: false,
                     switchOn: false,
                     actionType: .navigate,
                     tintColor: .text)
        ]
        
        // القسم الثالث: عام
        let generalSection = [
            Settings(icon: .Annoucement,
                     title: .Announcements,
                     subtitle: nil,
                     switchVisible: false,
                     switchOn: false,
                     actionType: .navigate,
                     tintColor: .text),
            Settings(icon: .Helpcenter,
                     title: .HelpCenter,
                     subtitle: nil,
                     switchVisible: false,
                     switchOn: false,
                     actionType: .navigate,
                     tintColor: .text),
            Settings(icon: .Privacy,
                     title: .Privacy,
                     subtitle: nil,
                     switchVisible: false,
                     switchOn: false,
                     actionType: .navigate,
                     tintColor: .text),
            Settings(icon: .Info,
                     title: .AboutUs,
                     subtitle: nil,
                     switchVisible: false,
                     switchOn: false,
                     actionType: .navigate,
                     tintColor: .text),
            Settings(icon: .Language,
                     title: .language,
                     subtitle: getCurrentLanguageSubtitle(),
                     switchVisible: false,
                     switchOn: false,
                     actionType: .custom({ [weak self] settingsVC in
                         self?.presentLanguageOptions()
                     }),
                     tintColor: .text)
        ]
        
        // تجميع الأقسام
        settingsList = [accountSection, communicationSection, generalSection]
        
        // تحديث الجدول
        settingsTableView.reloadData()
    }
    
    // MARK: - Helper Methods
    private func getThemeSubtitle() -> String {
        let currentTheme = ThemeManager.shared.currentThemeMode
        
        switch currentTheme {
        case .auto: return isEnglish() ? "Automatic" : "تلقائي"
        case .light: return isEnglish() ? "Light" : "فاتح"
        case .dark: return isEnglish() ? "Dark" : "مظلم"
        }
    }
    
    private func getCurrentLanguageSubtitle() -> String {
        let currentLanguage = LanguageManager.shared.currentLanguage
        return currentLanguage.nativeName
    }
}

// MARK: - UITableViewDelegate
extension SettingsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let item = settingsList[indexPath.section][indexPath.row]
        
        // إذا كان هناك نص فرعي تحت العنوان، زيادة الارتفاع
        if let subtitle = item.subtitle, !subtitle.isEmpty && item.switchVisible {
            return 70
        }
        return 60

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 8 : 12
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = settingsList[indexPath.section][indexPath.row]
        
        switch item.actionType {
        case .navigate:
            handleNavigation(for: item)
        case .toggle:
            // Switch يتعامل مع الحدث مباشرة
            break
        case .custom(let action):
            action(self)
        }
    }
    
    
    
    private func handleNavigation(for item: Settings) {
        switch item.title {
        case .account:
            // انتقال إلى شاشة إعدادات الحساب
            break
        case .appearance:
            presentAppearanceOptions()
            break
        case .message:
            // انتقال إلى إعدادات الرسائل
            break
        case .HelpCenter:
            // انتقال إلى مركز المساعدة
            break
        case .Privacy:
            // انتقال إلى إعدادات الخصوصية
            break
        case .AboutUs:
            // انتقال إلى صفحة عن التطبيق
            break
        case .Announcements:
            // انتقال إلى الإعلانات
            break
        case .language:
            // لا نحتاج هذا لأننا نستخدم custom action
            break
        default:
            break
        }
    }
    
    private func handleToggleSwitch(indexPath: IndexPath, isOn: Bool) {
        let item = settingsList[indexPath.section][indexPath.row]
        
        // إضافة haptic feedback للتبديل
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        switch item.title {
        case .notification:
            handleNotificationToggle(isOn: isOn)
            break
        default:
            break
        }
    }
    
    // MARK: - Navigation Helper Methods
    private func presentAppearanceOptions() {
        let alertController = UIAlertController(
            title: isEnglish() ? "Choose Theme" : "اختر المظهر",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let lightAction = UIAlertAction(
            title: isEnglish() ? "Light Mode" : "الوضع الفاتح",
            style: .default
        ) { _ in
            ThemeManager.shared.setTheme(ThemeManager.ThemeMode.light)
            self.setupSettingsData()
        }
        
        let darkAction = UIAlertAction(
            title: isEnglish() ? "Dark Mode" : "الوضع الداكن",
            style: .default
        ) { _ in
            ThemeManager.shared.setTheme(ThemeManager.ThemeMode.dark)
            self.setupSettingsData()
        }
        
        let autoAction = UIAlertAction(
            title: isEnglish() ? "Auto" : "تلقائي",
            style: .default
        ) { _ in
            ThemeManager.shared.setTheme(.auto)
            self.setupSettingsData()
        }
        
        let cancelAction = UIAlertAction(
            title: isEnglish() ? "Cancel" : "إلغاء",
            style: .cancel
        )
        
        alertController.addAction(lightAction)
        alertController.addAction(darkAction)
        alertController.addAction(autoAction)
        alertController.addAction(cancelAction)
        
        if let popover = alertController.popoverPresentationController {
            popover.sourceView = view
            popover.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }
        
        present(alertController, animated: true)
    }
    
    /// تغيير اللغة - النسخة المُصححة والنهائية
    private func presentLanguageOptions() {
        let alertController = UIAlertController(
            title: isEnglish() ? "Choose Language" : "اختر اللغة",
            message: isEnglish() ? "App will restart to apply changes" : "سيتم إعادة تشغيل التطبيق لتطبيق التغييرات",
            preferredStyle: .actionSheet
        )
        
        // إضافة خيارات اللغة
        for language in Language.all {
            let action = UIAlertAction(
                title: language.nativeName,
                style: .default
            ) { _ in
                
                // التحقق من تغيير اللغة
                if language.code != LanguageManager.shared.currentLanguage.code {
                    
                    // haptic feedback
                    let feedback = UINotificationFeedbackGenerator()
                    feedback.notificationOccurred(.success)
                    
                    // تغيير اللغة وإعادة التشغيل
                    LanguageManager.shared.changeLanguageAndRestart(language)
                    
                } else {
                    // اللغة نفسها
                    let feedback = UIImpactFeedbackGenerator(style: .light)
                    feedback.impactOccurred()
                }
            }
            
            // علامة الاختيار للغة الحالية
            if language.code == LanguageManager.shared.currentLanguage.code {
                action.setValue(true, forKey: "checked")
            }
            
            alertController.addAction(action)
        }
        
        // زر الإلغاء
        let cancelAction = UIAlertAction(
            title: isEnglish() ? "Cancel" : "إلغاء",
            style: .cancel
        )
        alertController.addAction(cancelAction)
        
        // إعداد popover للآيباد
        if let popover = alertController.popoverPresentationController {
            popover.sourceView = view
            popover.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }
        
        present(alertController, animated: true)
    }
    
    private func handleNotificationToggle(isOn: Bool) {
        UserDefault.shared.setValue(isOn, forKey: "notifications_enabled")
        print("Notifications \(isOn ? "enabled" : "disabled")")
    }
}

// MARK: - UITableViewDataSource
extension SettingsVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingsList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsList[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTVCell.identifier, for: indexPath) as? SettingTVCell else {
            return UITableViewCell()
        }
        
        let item = settingsList[indexPath.section][indexPath.row]
        cell.configure(with: item)
        
        // معالجة حدث تبديل الزر
        cell.switchToggleHandler = { [weak self] isOn in
            self?.handleToggleSwitch(indexPath: indexPath, isOn: isOn)
        }
        
        // إزالة separator للخلية الأخيرة في كل section
        let isLastCell = indexPath.row == settingsList[indexPath.section].count - 1
        cell.separatorInset = isLastCell ? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude) : UIEdgeInsets(top: 0, left: 72, bottom: 0, right: 0)
        
        // تأثير fade in محسن
        cell.alpha = 0
        cell.transform = CGAffineTransform(translationX: 0, y: 20)
        
        UIView.animate(
            withDuration: 0.4,
            delay: Double(indexPath.row) * 0.05,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.5,
            options: .curveEaseOut
        ) {
            cell.alpha = 1
            cell.transform = .identity
        }
        
        return cell
    }

    
    
    private func addCustomSeparator(to cell: UITableViewCell, at indexPath: IndexPath) {
        // إزالة أي separator سابق
        cell.subviews.forEach { subview in
            if subview.tag == 999 {
                subview.removeFromSuperview()
            }
        }
        
        // إضافة separator مخصص (ما عدا الخلية الأخيرة في كل قسم)
        let isLastCellInSection = indexPath.row == settingsList[indexPath.section].count - 1
        
        if !isLastCellInSection {
            let separator = UIView()
            separator.tag = 999
            separator.backgroundColor = ThemeManager.shared.color(.separator)
            separator.translatesAutoresizingMaskIntoConstraints = false
            
            cell.addSubview(separator)
            
            NSLayoutConstraint.activate([
                separator.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 60),
                separator.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -16),
                separator.bottomAnchor.constraint(equalTo: cell.bottomAnchor),
                separator.heightAnchor.constraint(equalToConstant: 0.5)
            ])
        }
    }
}
