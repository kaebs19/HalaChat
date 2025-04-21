//
//  Buttons.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 13/04/2025.
//

import Foundation

enum Buttons: String , LocalizableEnim {
    
    case test = "testButton"
    case skip = "skipButton"
    case login = "loginButton"
    case signup = "registerButton"
    
    var textBtn: String {
        return self.localized
    }

}

