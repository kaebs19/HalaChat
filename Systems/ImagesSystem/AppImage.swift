import UIKit


enum AppImage: String , CaseIterable {
    
    case logo = "logo"
    case back = "back_icon"
    case search = "search_icon"
    case notification = "notification_icon"
    case more = "more_icon"
    case list = "list_icon"
    case close = "close_icon"
    case Eye_on = "eye"
    case Eye_off = "eye-off"
    
    // TabBars
    case homeSelected = "home_Select"
    case homeUnselected = "home_UnSelect"
    case messageSelected = "message_Select"
    case messageUnselected = "message_UnSelect"
    case notificationSelected = "notifications_Select"
    case notificationUnselected = "notifications_UnSelect"
    case accountSelected = "account_Select"
    case accountUnselected = "account_UnSelect"
    
    // Acount
    
    case paymoney = "paymoney"
    case QRCode = "QRCode"
    case settings = "settings"
    case signout = "logout"
    case version = "Version"
    /// الحصول على كائن UIImage مع مراعاة الوضع الحالي (فاتح/مظلم)
    var image: UIImage? {
        return UIImage(named: rawValue)
    }
    
    /// الحصول على كائن UIImage مع تخصيص وضع العرض
    func tintedImage(with color: UIColor) -> UIImage? {
        return image?.withRenderingMode(.alwaysTemplate).withTintColor(color)
    }
    
    /// الحصول على كائن UIImage مع لون من نظام الألوان في التطبيق
    
    func tintedImage(with colorSet: AppColors) -> UIImage? {
        let color = ThemeManager.shared.color(colorSet)
        return tintedImage(with: color)
    }
    
    
}
