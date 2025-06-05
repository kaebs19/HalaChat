//
//  Settinngs.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 20/05/2025.
//

import Foundation


struct Settings {
    
    let icon: AppImage  // أيقونة العنصر
    let title: SettingTitle // عنوان العنصر
    let subtitle: String?       // نص فرعي (اختياري)
    let switchVisible: Bool     // هل يظهر زر التبديل؟
    let switchOn: Bool           // حالة زر التبديل الأولية (إذا كان مرئيًا)
    let actionType: SettingsActionType // نوع الإجراء عند النقر
    let tintColor: AppColors  // لون الأيقونة
    
}



// أنواع إجراءات الإعدادات
enum SettingsActionType {
    
    case navigate           // الانتقال إلى شاشة أخرى
    case toggle             // تبديل إعداد
    case custom((SettingsVC) -> Void) // إجراء مخصص
}


enum SettingTitle: String {
    // settings
    case account = "AccountSettingsTV"
    case message = "MessageSettingsTV"
    case notification = "NotificationSettingsTV"
    case appearance = "AppearanceSettingsTV"
    case Announcements = "AnnouncementsSettingsTV"
    case HelpCenter = "HelpAndSupportSettingsTV"
    case Privacy = "PrivacySettingsTV"
    case AboutUs = "AboutUsSettingsTV"
    case language = "LanguageSettingsTV"
    
    var titleName: String {
        return self.rawValue.localized
    }
}
