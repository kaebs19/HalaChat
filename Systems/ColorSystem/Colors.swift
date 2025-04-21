//
//  Colors.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 18/04/2025.
//

import UIKit

enum Colors: String {
   case CFF2D55 = "#CFF2D55"
    case CFFFFFF = "#FFFFFF"
    case CF54B64_Start = "#CF54B64"
    case CF78361_End = "#F78361"
    case C707070_textField = "#707070"
    case C505C69_textFieldPlaceholder = "#505C69"
    
    var uitColor: UIColor? {
        return UIColor(hex: self.rawValue)
    }
}
