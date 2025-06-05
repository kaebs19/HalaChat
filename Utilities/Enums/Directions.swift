import UIKit
import MOLH
/// اتجاهات النص

enum Directions {
    
    case left
    case Right
    case Center
    case Normal
    case auto
    
    var textAlignment: NSTextAlignment {
        
        switch self {
                
            case .Right: return .right
            case .left: return .left
            case .Center: return .center
            case .Normal: return .natural
            case .auto:
                return MOLHLanguage.isRTLLanguage() ? .right : .left
        }
    }
}
