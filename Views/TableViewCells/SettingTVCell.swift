//
//  SettingTVCell.swift (إصدار مُصحح بدون تضارب constraints)
//  HalaChat
//
//  Created by Mohammed Saleh on 20/05/2025.
//

import UIKit

class SettingTVCell: UITableViewCell {
    
    static let identifier = "SettingTVCell"
    
    // MARK: - UI Elements
    private let iconContainer = UIView()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let statusLabel = UILabel()
    private let toggleSwitch = UISwitch()
    private let disclosureImageView = UIImageView()
    
    // MARK: - Constraints للتحكم الديناميكي
    private var titleCenterYConstraint: NSLayoutConstraint!
    private var titleTopConstraint: NSLayoutConstraint!
    
    // MARK: - خاصية للتعامل مع تبديل الزر
    var switchToggleHandler: ((Bool) -> Void)?
    
    // MARK: - التهيئة
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension SettingTVCell {
    
    private func setupViews() {
        // تهيئة الخلية
        selectionStyle = .default
        backgroundColor = ThemeManager.shared.color(.mainBackground)
        contentView.backgroundColor = ThemeManager.shared.color(.mainBackground)
        
        // إعداد containerView الأيقونة
        contentView.addSubview(iconContainer)
        iconContainer.translatesAutoresizingMaskIntoConstraints = false
        iconContainer.backgroundColor = ThemeManager.shared.color(.secondBackground)
        iconContainer.layer.cornerRadius = 20
        iconContainer.layer.masksToBounds = true
        
        // إعداد الأيقونة
        iconContainer.addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.contentMode = .scaleAspectFit
        
        // إعداد العنوان
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: Sizes.size_16.rawValue, weight: .medium)
        titleLabel.textColor = ThemeManager.shared.color(.text)
        
        // إعداد النص الفرعي
        contentView.addSubview(subtitleLabel)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = UIFont.systemFont(ofSize: Sizes.size_14.rawValue, weight: .regular)
        subtitleLabel.textColor = ThemeManager.shared.color(.textSecond)
        subtitleLabel.isHidden = true
        
        // إعداد نص الحالة (للنصوص الفرعية على اليمين)
        contentView.addSubview(statusLabel)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.font = UIFont.systemFont(ofSize: Sizes.size_14.rawValue, weight: .regular)
        statusLabel.textColor = ThemeManager.shared.color(.textSecond)
        statusLabel.textAlignment = .right
        statusLabel.isHidden = true
        
        // إعداد زر التبديل
        contentView.addSubview(toggleSwitch)
        toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
        toggleSwitch.onTintColor = ThemeManager.shared.color(.accent)
        toggleSwitch.isHidden = true
        toggleSwitch.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)

        // إعداد أيقونة السهم
        contentView.addSubview(disclosureImageView)
        disclosureImageView.translatesAutoresizingMaskIntoConstraints = false
        disclosureImageView.contentMode = .scaleAspectFit
        disclosureImageView.image = AppImage.Forward.image
        disclosureImageView.tintColor = ThemeManager.shared.color(.textSecond)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        // إنشاء constraints للعنوان بدون تفعيلها
        titleCenterYConstraint = titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        titleTopConstraint = titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12)
        
        NSLayoutConstraint.activate([
            
            // iconContainer
            iconContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconContainer.widthAnchor.constraint(equalToConstant: 40),
            iconContainer.heightAnchor.constraint(equalToConstant: 40),
            
            // iconImageView
            iconImageView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            // titleLabel - فقط الـ leading، وسنتحكم في الـ Y ديناميكياً
            titleLabel.leadingAnchor.constraint(equalTo: iconContainer.trailingAnchor, constant: 16),
            
            // تفعيل constraint افتراضي للعنوان (وسط الخلية)
            titleCenterYConstraint,
            
            // subtitleLabel
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            
            // statusLabel (نص فرعي على اليمين)
            statusLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: disclosureImageView.leadingAnchor, constant: -12),
            statusLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 16),
            
            // toggleSwitch
            toggleSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            toggleSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // disclosureImageView
            disclosureImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            disclosureImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            disclosureImageView.widthAnchor.constraint(equalToConstant: 8),
            disclosureImageView.heightAnchor.constraint(equalToConstant: 14)
        ])
    }
    
    // MARK: - تحديث الخلية
    func configure(with item: Settings) {
        
        // تعيين الأيقونة
        iconImageView.image = item.icon.image?.withRenderingMode(.alwaysTemplate)
        iconImageView.tintColor = ThemeManager.shared.color(item.tintColor)
        
        // تعيين العنوان
        titleLabel.text = item.title.titleName
        titleLabel.textColor = ThemeManager.shared.color(.text)
        
        // تعيين النص الفرعي إذا وجد
        var hasSubtitleBelow = false
        
        if let subtitle = item.subtitle, !subtitle.isEmpty {
            if item.switchVisible {
                // إذا كان هناك switch، النص الفرعي يظهر تحت العنوان
                subtitleLabel.text = subtitle
                subtitleLabel.isHidden = false
                statusLabel.isHidden = true
                hasSubtitleBelow = true
            } else {
                // إذا لم يكن هناك switch، النص الفرعي يظهر على اليمين
                statusLabel.text = subtitle
                statusLabel.isHidden = false
                subtitleLabel.isHidden = true
                hasSubtitleBelow = false
            }
        } else {
            subtitleLabel.isHidden = true
            statusLabel.isHidden = true
            hasSubtitleBelow = false
        }
        
        // تعيين زر التبديل أو سهم التنقل
        toggleSwitch.isHidden = !item.switchVisible
        disclosureImageView.isHidden = item.switchVisible
        
        // تعيين حالة زر التبديل
        if item.switchVisible {
            toggleSwitch.isOn = item.switchOn
        }
        
        // تحديث constraints للعنوان بناءً على وجود النص الفرعي
        updateTitleConstraints(hasSubtitle: hasSubtitleBelow)
    }
    
    private func updateTitleConstraints(hasSubtitle: Bool) {
        
        // إزالة تفعيل جميع constraints الخاصة بالموضع العمودي للعنوان
        titleCenterYConstraint.isActive = false
        titleTopConstraint.isActive = false
        
        // تفعيل الـ constraint المناسب
        if hasSubtitle {
            titleTopConstraint.isActive = true
        } else {
            titleCenterYConstraint.isActive = true
        }
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
        
        // إعادة تعيين constraints للعنوان للحالة الافتراضية
        titleCenterYConstraint.isActive = false
        titleTopConstraint.isActive = false
        titleCenterYConstraint.isActive = true
    }
    
    // MARK: - معالجة حدث التبديل
    @objc private func switchValueChanged(_ sender: UISwitch) {
        switchToggleHandler?(sender.isOn)
    }
    
    // MARK: - تحديث السمة
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        // تحديث الألوان عند تغيير السمة
        backgroundColor = ThemeManager.shared.color(.mainBackground)
        contentView.backgroundColor = ThemeManager.shared.color(.mainBackground)
        iconContainer.backgroundColor = ThemeManager.shared.color(.secondBackground)
        titleLabel.textColor = ThemeManager.shared.color(.text)
        subtitleLabel.textColor = ThemeManager.shared.color(.textSecond)
        statusLabel.textColor = ThemeManager.shared.color(.textSecond)
        disclosureImageView.tintColor = ThemeManager.shared.color(.textSecond)
        toggleSwitch.onTintColor = ThemeManager.shared.color(.accent)
    }
}

    