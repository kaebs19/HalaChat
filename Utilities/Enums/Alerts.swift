//
//  Alerts.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 13/04/2025.
//

import Foundation


enum Alerts: String , LocalizableEnim {
    
    case Yes = "yesAlert"
    case No = "noAlert"
 
    
    var alertText: String {
        return self.localized
    }

}
