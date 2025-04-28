//
//  TextFields.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 13/04/2025.
//

import Foundation

enum TextFields: String  {
    
    case email = "emailTF"
    case password = "passwordTF"
    case confirmPassword = "confirmPasswordTF"
    case name = "nameTF"
    case phoneNumber = "phoneNumberTF"
    case dateOfBirth = "dateOfBirthTF"
   
    var textTF: String {
        return self.rawValue.localized
    }

}

