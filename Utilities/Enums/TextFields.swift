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
    case username = "usernameTF"
    case dateOfBirth = "dateOfBirthTF"
    case searech = "searechTF"
   
    var textTF: String {
        return self.rawValue.localized
    }

}

