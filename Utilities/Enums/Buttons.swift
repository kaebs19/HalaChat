//
//  Buttons.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 13/04/2025.
//

import Foundation

enum Buttons: String , LocalizableEnim {
    
    case test = "testButton"
    
    var textBtn: String {
        return self.localized
    }

}

