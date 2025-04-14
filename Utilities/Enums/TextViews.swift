//
//  TextViews.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 13/04/2025.
//

import Foundation

enum TextViews: String , LocalizableEnim {
    
    case test = "testTV"
    
    var textTV: String {
        return self.localized
    }

    
}

