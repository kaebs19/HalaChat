//
//  Images.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 13/04/2025.
//

import Foundation
import UIKit


enum AppImage: String , CaseIterable {
    
    case logo = "logo"
    case back = "back_icon"
    case search = "search_icon"
    case notification = "notification_icon"
    case more = "more_icon"
    case list = "list_icon"
    case close = "close_icon"

    
    /// الحصول على كائن UIImage مع مراعاة الوضع الحالي (فاتح/مظلم)
    var image: UIImage? {
        return UIImage(named: rawValue)
    }
    
    /// الحصول على كائن UIImage مع تخصيص وضع العرض
    func tintedImage(with color: UIColor) -> UIImage? {
        return image?.withRenderingMode(.alwaysTemplate).withTintColor(color)
    }
    
    /// الحصول على كائن UIImage مع لون من نظام الألوان في التطبيق
    
    func tintedImage(with colorSet: ColorSet) -> UIImage? {
        let color = ThemeManager.shared.color(colorSet)
        return tintedImage(with: color)
    }
    
    
}
