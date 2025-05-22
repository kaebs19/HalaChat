//
//  Titles.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 13/04/2025.
//

import Foundation


enum Titles: String  {
    
    case welcomeToHalaChat = "Welcome to HalaChat"
    case Help = "HelpTitle"
    case Login = "LoginTitle"
    case SignUp = "SignUpTitle"
    case forgotPassword = "ForgotPasswordTitle"
    case Explore = "ExploreTitle"
    case Chat = "ChatTitle"
    case Notifications = "NotificationsTitle"
    case Acconts = "AccountsTitle"
    case MyQrCode = "MyQrCodeTitle"
    case Settings = "SettingsTitle"
    
    var textTitle: String {
        return self.rawValue.localized
    }
    
}
