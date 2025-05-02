//
//  Buttons.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 13/04/2025.
//

import Foundation

enum Buttons: String  {
    
    case test = "testButton"
    case skip = "skipButton"
    case login = "loginButton"
    case signup = "registerButton"
    case forgotPassword = "forgotPasswordButton"
    case terms = "TermsButton"
    case conditions = "ConditionsButton"
    
    var textBtn: String {
        return self.rawValue.localized
    }

}

