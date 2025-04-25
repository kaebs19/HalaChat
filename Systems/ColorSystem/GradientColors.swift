//
//  GradientColors.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 25/04/2025.
//

import UIKit


enum GradientColors: String {
    
    case Start = "#F54B64"
    case End = "#F78361"
    
    case BlueStart = "#4158D0"
    case BlueEnd = "#2FB6FF"
    
    case GreenStart = "#00B09B"
    case GreenEnd = "#96C93D"
    
    case PurpleStart = "#8E2DE2"
    case PurpleEnd = "#4A00E0"

    
    
    var uiColor: UIColor {
        return UIColor(hex: rawValue) ?? UIColor.black
    }
    
    func colorWithAppearance(alpha: CGFloat = 1.0, darkMode: Bool = false) -> UIColor {
        var color = uiColor.withAlphaComponent(alpha)
        
        // في حالة الوضع الداكن، يمكننا تعديل اللون بناءً على مجموعة محددة من القواعد
        if darkMode {
            // تقليل السطوع للألوان الفاتحة، وزيادة سطوع الألوان الداكنة
            var hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0, alpha: CGFloat = 0
            color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
            
            // تعديل السطوع للوضع الداكن - قد تحتاج لضبط هذه القيم حسب حاجتك
            let adjustedBrightness = brightness < 0.5 ? brightness * 1.3 : brightness * 0.7
            
            color = UIColor(hue: hue, saturation: saturation, brightness: adjustedBrightness, alpha: alpha)
        }
        
        return color
    }

}
