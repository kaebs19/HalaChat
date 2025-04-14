//
//  ThemeImage.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 14/04/2025.
//

import UIKit

/// فئة للتعامل مع الصور مع مراعاة السمة الحالية
class ThemeImage {
    
    static func image( name imageName: String ) -> UIImage? {
        return UIImage(named: imageName)
    }
    
    static func image(for appImage: AppImage) -> UIImage? {
        return appImage.image
    }
    
    static func tintedImage(for appImage: AppImage, with colorSet: ColorSet) -> UIImage? {
        return appImage.tintedImage(with: colorSet)
    }
    
}

