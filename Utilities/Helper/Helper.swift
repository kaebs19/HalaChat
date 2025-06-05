//
//  Helper.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 13/04/2025.
//

import UIKit
import MOLH



public var screenWidth: CGFloat { get { return UIScreen.main.bounds.size.width } }
public var screenHeight:CGFloat { get { return UIScreen.main.bounds.size.height } }
public var iPhoneXFactor: CGFloat { get {return ((screenWidth * 1.00) / 360)} }

/// تحقق مما إذا كانت اللغة الحالية هي الإنجليزية.
/// - **Returns**: `true` إذا كانت اللغة الإنجليزية، `false` إذا كانت اللغة العربية.

public func isEnglish() -> Bool {
    return LanguageManager.shared.isEnglish
}


/// تحقق مما إذا كانت اللغة الحالية هي العربية
public func isArabic() -> Bool {
    return LanguageManager.shared.isArabic
}

/// تحقق مما إذا كانت اللغة الحالية من اليمين إلى اليسار
public func isRTL() -> Bool {
    return LanguageManager.shared.isRTL
}


/// الحصول على اللغة الحالية
public func currentLanguage() -> Language {
    return LanguageManager.shared.currentLanguage
}
