//
//  TextFields.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 13/04/2025.
//

import Foundation

enum TextFields: String , LocalizableEnim {
    
    case test = "testTF"
    
   
    var textTF: String {
        return self.localized
    }

}

