//
//  TextViews.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 13/04/2025.
//

import Foundation

enum TextViews: String  {
    
    case test = "testTV"
    
    var textTV: String {
        return self.rawValue.localized
    }

    
}

