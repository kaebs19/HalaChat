//
//  TVTitles.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 10/05/2025.
//

import Foundation

enum TVTitles: String {
    
    case myQrCode = "MyQRCodeTV"
    case purchase = "PurchaseTV"
    case settings = "SettingsTV"
    case terms = "TermsTV"
    case conditions = "ConditionsTV"
    case logout = "LogoutTV"
    case version = "VersionTV"
    
    // settings
    case account = "AccountSettingsTV"
    case message = "MessageSettingsTV"
    case notification = "NotificationSettingsTV"
    case appearance = "AppearanceSettingsTV"
    case Announcements = "AnnouncementsSettingsTV"
    case HelpCenter = "HelpAndSupportSettingsTV"
    case Privacy = "PrivacySettingsTV"
    case AboutUs = "AboutUsSettingsTV"
    
    
    var textName: String {
        return self.rawValue.localized
    }

}
