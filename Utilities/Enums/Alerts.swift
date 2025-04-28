//
//  Alerts.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 13/04/2025.
//

import Foundation


enum Alerts: String  {
    
    case Yes = "yesAlert"
    case No = "noAlert"
 
    
    var alertText: String {
        return self.rawValue.localized
    }

}
