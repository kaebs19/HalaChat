//
//  Helper.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 13/04/2025.
//

import Foundation
import UIKit
import MOLH



public var screenWidth: CGFloat { get { return UIScreen.main.bounds.size.width } }
public var screenHeight:CGFloat { get { return UIScreen.main.bounds.size.height } }
public var iPhoneXFactor: CGFloat { get {return ((screenWidth * 1.00) / 360)} }

/// تحقق مما إذا كانت اللغة الحالية هي الإنجليزية.
/// - **Returns**: `true` إذا كانت اللغة الإنجليزية، `false` إذا كانت اللغة العربية.
public func isEnglish() -> Bool {
    
    if MOLHLanguage.isArabic() {
        return false
    } else {
        return true
    }
    
}
