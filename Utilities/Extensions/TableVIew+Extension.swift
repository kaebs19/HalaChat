//
//  TableVIew+Extension.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 10/05/2025.
//

import Foundation
import UIKit

extension UITableView {
    
    
    // MARK: - Properties
      /// التحقق من وجود الجدول فارغ
      var isEmpty: Bool {
          guard let dataSource = dataSource else { return true }
          
          var totalRows = 0
          for section in 0..<numberOfSections {
              totalRows += dataSource.tableView(self, numberOfRowsInSection: section)
          }
          return totalRows == 0
      }
      
      // MARK: - Registration Methods
      /// تسجيل خلية في الجدول باستخدام النوع العام
      func register<T: UITableViewCell>(_ cellType: T.Type) {
          let identifier = String(describing: cellType)
          register(cellType, forCellReuseIdentifier: identifier)
      }
      
      /// تسجيل خلية باستخدام XIB
      func registerNib<T: UITableViewCell>(_ cellType: T.Type) {
          let identifier = String(describing: cellType)
          let nib = UINib(nibName: identifier, bundle: nil)
          register(nib, forCellReuseIdentifier: identifier)
      }
      
      /// تسجيل خلية باستخدام Enum مع تعيين delegate و dataSource
      func registerNib(cellType: TVCells,
                      delegate: UITableViewDelegate? = nil,
                      dataSource: UITableViewDataSource? = nil) {
          let identifier = cellType.rawValue
          
          // تعيين delegate و dataSource
          self.delegate = delegate
          self.dataSource = dataSource
          
          // تسجيل الخلية
          let nib = UINib(nibName: identifier, bundle: nil)
          register(nib, forCellReuseIdentifier: identifier)
      }
    
    
    /// تهيئة الفواصل بين الخلايا
    func configureSeparator(
        style: UITableViewCell.SeparatorStyle = .singleLine,
        inset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16),
        color: UIColor? = nil
    ) {
        self.separatorStyle = style
        self.separatorInset = inset
        
        if let color = color {
            self.separatorColor = color
        }
    }

    
    /// إخفاء أو إظهار مؤشر التمرير العمودي.
    func hideVerticalScrollIndicator(isHidden: Bool = true) {
        self.showsVerticalScrollIndicator = !isHidden
        self.showsHorizontalScrollIndicator = !isHidden
    }
    
    /// إيقاف التمرير تمامًا

    func disableScroll() {
        isScrollEnabled = false
    }

    
    // MARK: - Configuration Methods
    /// تهيئة الجدول بالإعدادات الافتراضية
    func configureDefault(backgroundColor: UIColor = .systemBackground,
                          separatorStyle: UITableViewCell.SeparatorStyle = .none,
                          showScrollIndicator: Bool = false,
                          estimatedRowHeight: CGFloat = UITableView.automaticDimension
    ) {
        self.backgroundColor = backgroundColor
        self.separatorStyle = separatorStyle
        self.showsVerticalScrollIndicator = showScrollIndicator
        self.showsHorizontalScrollIndicator = showScrollIndicator
        self.estimatedRowHeight = estimatedRowHeight
        self.rowHeight = UITableView.automaticDimension
        self.tableFooterView = UIView()
    }
    
    /// تهيئة الجدول مع تسجيل الخلية وتعيين المنتدبين
    func configureTableView(cellName: TVCells,
                            delegate: UITableViewDelegate? = nil,
                            dataSource: UITableViewDataSource? = nil,
                            applyDefaults: Bool = true
    ) {
        // تطبيق الإعدادات الافتراضية
        if applyDefaults {
            configureDefault()
        }
        
        // تسجيل الخلية
        registerNib(cellType: cellName , delegate: delegate , dataSource: dataSource)
    }
    
    // MARK: - Dequeue Methods
    /// الحصول على خلية مع النوع العام
    func dequeueCell<T: UITableViewCell>(
        for indexPath: IndexPath,
        cellType: T.Type = T.self
    ) -> T {
        let identifier = String(describing: cellType)
        
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Unable to dequeue cell with identifier: \(identifier)")
        }
        
        return cell
    }
    
    /// الحصول على خلية باستخدام Enum
    func dequeueCell<T: UITableViewCell>(
        for indexPath: IndexPath,
        cellType: TVCells
    ) -> T {
        let identifier = cellType.rawValue
        
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Unable to dequeue cell with identifier: \(identifier)")
        }
        
        return cell
    }

    
    // MARK: - Header/Footer Registration
    /// تسجيل عنوان أو تذييل مخصص
    func registerHeaderFooter<T: UITableViewHeaderFooterView>(_ viewType: T.Type) {
        let identifier = String(describing: viewType)
        register(viewType, forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    /// تسجيل عنوان أو تذييل باستخدام XIB
    func registerHeaderFooterNib<T: UITableViewHeaderFooterView>(_ viewType: T.Type) {
        let identifier = String(describing: viewType)
        let nib = UINib(nibName: identifier, bundle: nil)
        register(nib, forHeaderFooterViewReuseIdentifier: identifier)
    }

    
    // MARK: - Scrolling Methods
    /// التمرير إلى الأعلى
    func scrollToTop(animated: Bool = true) {
        guard numberOfSections > 0, numberOfRows(inSection: 0) > 0 else { return }
        scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: animated)
    }
    
    /// التمرير إلى الأسفل
    func scrollToBottom(animated: Bool = true) {
        guard numberOfSections > 0 else { return }
        
        let lastSection = numberOfSections - 1
        let lastRow = numberOfRows(inSection: lastSection) - 1
        
        guard lastRow >= 0 else { return }
        
        let indexPath = IndexPath(row: lastRow, section: lastSection)
        scrollToRow(at: indexPath, at: .bottom, animated: animated)
    }
    
    
    // MARK: - Empty State
    /// عرض رسالة عندما يكون الجدول فارغاً
    func setEmptyMessage(_ message: String, font: UIFont? = nil, textColor: UIColor? = nil) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = textColor ?? .secondaryLabel
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = font ?? .systemFont(ofSize: 16, weight: .medium)
        messageLabel.sizeToFit()
        
        backgroundView = messageLabel
    }
    
    /// إزالة رسالة الجدول الفارغ
    func removeEmptyMessage() {
        backgroundView = nil
    }

    
    // MARK: - Refresh Control
    /// إضافة عنصر تحديث
    func addRefreshControl(
        target: Any?,
        action: Selector,
        tintColor: UIColor? = nil
    ) {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(target, action: action, for: .valueChanged)
        
        if let tintColor = tintColor {
            refreshControl.tintColor = tintColor
        }
        
        self.refreshControl = refreshControl
    }
    
    /// إنهاء التحديث
    func endRefreshing() {
        refreshControl?.endRefreshing()
    }
    
    // MARK: - Loading Indicator
    /// عرض مؤشر التحميل
    func showLoadingIndicator() {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.startAnimating()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 44)
        
        tableFooterView = activityIndicator
    }
    
    /// إخفاء مؤشر التحميل
    func hideLoadingIndicator() {
        tableFooterView = UIView()
    }


}



extension UITableViewCell {
 
    // MARK: - Configuration Methods
    /// تعيين نمط التحديد للخلية
    func setSelectionStyle(_ style: UITableViewCell.SelectionStyle = .none) {
        self.selectionStyle = style
    }
    
    /// إزالة هوامش الخلية وتعطيل التحديد
    func removeMarginsAndSelection() {
        layoutMargins = .zero
        preservesSuperviewLayoutMargins = false
        selectionStyle = .none
        
        // إزالة المساحة الإضافية للمحتوى
        contentView.layoutMargins = .zero
    }
    
    /// تطبيق ظل للخلية
    func applyShadow(color: UIColor = .black ,
                     opacity: Float = 0.2,
                     radius: CGFloat = 4,
                     offset: CGSize = CGSize(width: 0, height: 1)) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowOffset = offset
    }
    
    /// تطبيق حدود للخلية
    func applyBorder(
        width: CGFloat = 1,
        color: UIColor = .separator,
        cornerRadius: CGFloat = 8
    ) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
    }

    /// تحضير الخلية للعرض
    func prepareForDisplay() {
        backgroundColor = .clear
        selectionStyle = .none
        preservesSuperviewLayoutMargins = false
        contentView.preservesSuperviewLayoutMargins = false
    }
    
    // MARK: - Animation Methods
    /// تأثير نقر للخلية
    
    func animateTap(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        }) { _ in
            UIView.animate(withDuration: 0.1, animations: {
                self.transform = .identity
            }) { _ in
                completion?()
            }
        }
    }

    /// تأثير دخول للخلية
    
    func animateEntrance(delay: TimeInterval = 0) {
        alpha = 0
        transform = CGAffineTransform(translationX: 0, y: 20)
        
        UIView.animate(withDuration: 0.3, delay: delay, options: .curveEaseOut, animations: {
            self.alpha = 1
            self.transform = .identity
        })
    }
    
    
}
