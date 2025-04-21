//
//  Titles.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 13/04/2025.
//

import Foundation


enum Titles: String , LocalizableEnim {
    
    case welcomeToHalaChat = "Welcome to HalaChat"
    case Help = "HelpTitle"
    case Login = "LoginTitle"
    case SignUp = "SignUpTitle"
    
    var textTitle: String {
        return self.rawValue.localized
    }
    
}
