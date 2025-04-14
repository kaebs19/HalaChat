//
//  String+Extension.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 13/04/2025.
//

import Foundation


extension String {
    
    
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
    
    func localized(with arguments: CVarArg...) -> String {
        return String(format: self.localized, arguments: arguments)
    }

}


#if DEBUG
extension String {
    var debugLocalized: String {
        let localized = NSLocalizedString(self, comment: "")
        if localized == self {
            print("⚠️ Missing localization for key: \(self)")
        }
        return localized
    }
}
#endif

// LocalizationProtocol.swift

protocol LocalizableEnim {
    var localized: String { get }
}

extension LocalizableEnim where Self: RawRepresentable, Self.RawValue == String {
    
    var localized: String {
        return self.rawValue.localized
    }
}
