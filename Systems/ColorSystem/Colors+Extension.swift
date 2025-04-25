import UIKit

extension UIColor {
    /// إنشاء لون من كود هيكس
    static func color(fromHex hex: String, alpha: CGFloat = 1.0) -> UIColor {
        var hexFormatted = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexFormatted = hexFormatted.replacingOccurrences(of: "#", with: "")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /// دمج لونين بنسبة معينة
    func blend(with color: UIColor, ratio: CGFloat = 0.5) -> UIColor {
        let ratio = max(0, min(1, ratio))
        
        var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
        var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0
        
        self.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        return UIColor(
            red: r1 * (1 - ratio) + r2 * ratio,
            green: g1 * (1 - ratio) + g2 * ratio,
            blue: b1 * (1 - ratio) + b2 * ratio,
            alpha: a1 * (1 - ratio) + a2 * ratio
        )
    }
    
    convenience init?(hex: String) {
            var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
            
            if hexSanitized.hasPrefix("#") {
                hexSanitized.remove(at: hexSanitized.startIndex)
            }
            
            var rgb: UInt64 = 0
            guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
            
            let r = CGFloat((rgb & 0xFF0000) >> 16) / 255
            let g = CGFloat((rgb & 0x00FF00) >> 8) / 255
            let b = CGFloat(rgb & 0x0000FF) / 255
            
            self.init(red: r, green: g, blue: b, alpha: 1.0)
        }
}
