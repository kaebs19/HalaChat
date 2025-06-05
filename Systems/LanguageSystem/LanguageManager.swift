//
//  LanguageManager.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 25/05/2025.
//

import UIKit
import MOLH


class LanguageManager {
    
    /// الحصول على برجية اللغة
    static let shared = LanguageManager()
    private init(){}
    
    private let userDefaults = UserDefaults.standard
    private let languageKey = "selected_app_language"
    
    
    // MARK: - Properties
    
    /// الحصول على اللغة الحالية
    
    var currentLanguage: Language {
        let savedCode = UserDefaults.standard.string(forKey: languageKey) ?? "ar"
        return Language.all.first { $0.code == savedCode } ?? Language.arabic
    }
    
    
    
    
    // تغيير اللغة
    func setLanguage(_ language: Language) {
        userDefaults.set(language.code, forKey: languageKey)
        userDefaults.synchronize()
        
        // تحديث MOLH
        MOLH.setLanguageTo(language.code)
        
        // تحديث
        UserDefault.shared.isLanguageEnglish = (language.code == "en" )
        
        // إشعار بتغيير اللغة
        NotificationCenter.default.post(name: .languageDidChange, object: language  )
    }
    
    // تحقق من نوع اللغة
    var isEnglish: Bool {
        return currentLanguage.code == "en"
    }
    
    var isArabic: Bool {
        return currentLanguage.code == "ar"
    }
    
    var isRTL: Bool {
        return currentLanguage.isRTL
    }
    
    /// تغيير اللغة مع إغلاق التطبيق (الحل الوحيد المستقر)
    func changeLanguageAndRestart(_ language: Language) {
        // حفظ اللغة
        setLanguage(language)
        
        // إغلاق التطبيق لتطبيق التغيير
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            exit(0)
        }
        
    }
    
}


