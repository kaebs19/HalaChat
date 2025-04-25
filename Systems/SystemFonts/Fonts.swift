import UIKit

/// تعريف أنواع الخطوط المتوفرة

enum Fonts: String {
    
    case cairo = "Cairo"
    case poppins = "Poppins"
    case arbFONTS_Hacen = "ArbFONTS-Hacen-Tunisia"
    case arbFONTS_Monadi = "ArbFONTS-Monadi"

    var name: String {
        return self.rawValue
    }
}

/// أنماط الخطوط المتوفرة
enum FontStyle: String {
    
    case regular = "Regular"
    case light = "Light"
    case medium = "Medium"
    case semiBold = "SemiBold"
    case bold = "Bold"
    case extraBold = "ExtraBold"
    case black = "Black"

    
    
    var uiFontWeight: UIFont.Weight {
        
        switch self {
            case .light: return .light
            case .regular: return .regular
            case .medium: return .medium
            case .semiBold: return .semibold
            case .bold: return .bold
            case .extraBold: return .heavy
            case .black: return .black
        }
    }
}
