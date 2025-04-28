//
//  String+Extension.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 13/04/2025.
//

import Foundation


extension String: Localizable

{
    var lolocalized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    
    
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
    
    func localized(with arguments: CVarArg...) -> String {
        return String(format: self.localized, arguments: arguments)
    }

}


