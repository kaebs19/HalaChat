//
//  SettingTVCell.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 20/05/2025.
//

import UIKit

class SettingTVCell: UITableViewCell {
    
    static let identifier = "SettingTVCell"
    
    // MARK: - UI Elements
    private let containerView = UIView()
    private let iconContainer = UIView()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let statusLabel = UILabel()
    private let toggleSwitch = UISwitch()
    private let disclosureImageView = UIImageView()
    
    
    // MARK: - خاصية للتعامل مع تبديل الزر
    var switchToggleHandler: ((Bool) -> Void)?
    
    
    // MARK: - التهيئة
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        setupViews()
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


extension SettingTVCell {
    
    private func setupViews() {
        // تهيئة الخلية
        selectionStyle = .none
        backgroundColor = .clear
        containerView.backgroundColor = .clear
        
        // إعداد containerView
        // إعداد containerView
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.setupContainerView(withColor: .secondBackground)
        
        // إعداد containerView الأيقونة
        containerView.addSubview(iconContainer)
        iconContainer.translatesAutoresizingMaskIntoConstraints = false
        iconContainer.makeCircular()
        
        // إعداد الأيقونة
        iconContainer.addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.contentMode = .scaleAspectFit

        // إعداد العنوان
        containerView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: Sizes.size_16.rawValue, weight: .medium)
        
        // إعداد النص الفرعي
        containerView.addSubview(subtitleLabel)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = UIFont.systemFont(ofSize: Sizes.size_14.rawValue, weight: .regular)
        subtitleLabel.textColor = ThemeManager.shared.color(.textSecond)
        subtitleLabel.isHidden = true
        
        // إعداد نص الحالة
        containerView.addSubview(statusLabel)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.textColor = ThemeManager.shared.color(.textSecond)
        statusLabel.textAlignment = Directions.auto.textAlignment
        
        // إعداد زر التبديل
        containerView.addSubview(toggleSwitch)
        toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
        toggleSwitch.onTintColor = ThemeManager.shared.color(.accent)
        toggleSwitch.isHidden = true
        toggleSwitch.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        
        // إعداد أيقونة السهم
        containerView.addSubview(disclosureImageView)
        disclosureImageView.translatesAutoresizingMaskIntoConstraints = false
        disclosureImageView.contentMode = .scaleAspectFit
        disclosureImageView.image = AppImage.Forward.image
        
        // تطبيق القيود (Constraints)
        NSLayoutConstraint.activate([
            // containerView
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            // iconContainer
            iconContainer.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconContainer.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            iconContainer.widthAnchor.constraint(equalToConstant: 36),
            iconContainer.heightAnchor.constraint(equalToConstant: 36),
            
            // iconImageView
            iconImageView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            
            // titleLabel
            titleLabel.leadingAnchor.constraint(equalTo: iconContainer.trailingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            
            // subtitleLabel
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            subtitleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            
            // statusLabel
            statusLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: disclosureImageView.leadingAnchor, constant: -8),
            
            // toggleSwitch
            toggleSwitch.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            toggleSwitch.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            // disclosureImageView
            disclosureImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            disclosureImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            disclosureImageView.widthAnchor.constraint(equalToConstant: 8),
            disclosureImageView.heightAnchor.constraint(equalToConstant: 14)
        ])

        
    }
    
    // MARK: - تحديث الخلية
    func configure(with itme: Settings) {
        
        // تعيين الأيقونة
        iconImageView.image = itme.icon.image?.withRenderingMode(.alwaysTemplate)
        iconImageView.tintColor = ThemeManager.shared.color(itme.tintColor)
        
        // تلوين containerView الأيقونة حسب نوعها
        let iconBackgroundColor: AppColors = item.actionType == .signOut ? .error : .secondBackground
        iconContainer.setThemeBackgroundColor(iconBackgroundColor)
        
        // تعيين العنوان
        titleLabel.text = itme.title
        titleLabel.textColor = item.actionType == .signOut ? ThemeManager.shared.color(.error) : ThemeManager.shared.color(.text)
        
        // تعيين النص الفرعي إذا وجد
        if let subtitle = itme.subtitle {
            subtitleLabel.text = subtitle
            subtitleLabel.isHidden = false
        } else {
            subtitleLabel.isHidden = true
        }
        
        // تعيين زر التبديل أو سهم التنقل
        toggleSwitch.isHidden = !itme.switchVisible
        disclosureImageView.isHidden = itme.switchVisible
        
        // تعيين حالة زر التبديل
        toggleSwitch.isOn = itme.switchOn
        
        // تعيين نص الحالة
        if let subtitle = itme.subtitle , !itme.switchVisible {
            statusLabel.text = subtitle
            statusLabel.isHidden = false

        } else {
            statusLabel.isHidden = true
        }
    }
    
    // MARK: - معالجة حدث التبديل
    @objc private func switchValueChanged(_sender: UISwitch) {
        switchToggleHandler?(_sender.isOn)
    }
    
    // MARK: - إعادة تعيين الخلية
    override func prepareForReuse() {
        super.prepareForReuse()
        
        iconImageView.image = nil
        titleLabel.text = nil
        subtitleLabel.text = nil
        subtitleLabel.isHidden = true
        statusLabel.text = nil
        statusLabel.isHidden = true
        toggleSwitch.isHidden = true
        toggleSwitch.isOn = false
        disclosureImageView.isHidden = false
        switchToggleHandler = nil

    }
}
