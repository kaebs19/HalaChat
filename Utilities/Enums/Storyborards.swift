//
//  Storyborards.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 13/04/2025.
//

import Foundation


enum Storyborards: String {
    case Main
    case Onboarding
    
    
    var stName: String {
        return self.rawValue.localized
    
    }
}
