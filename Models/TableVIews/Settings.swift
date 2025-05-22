//
//  Settinngs.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 20/05/2025.
//

import Foundation


struct Settings {
    
    let icon: AppImage  // أيقونة العنصر
    let title: TVTitles // عنوان العنصر
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
    case signOut            // تسجيل الخروج
    case custom((SettingsVC) -> Void) // إجراء مخصص
}

