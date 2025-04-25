
import UIKit

/*
 أحجام النصوص المستخدمة
*/
enum Sizes: CGFloat {
    
    case size_10 = 10
    case size_12 = 12
    case size_14 = 14
    case size_16 = 16
    case size_18 = 18
    case size_20 = 20
    
    case size_32 = 32
    
    
    static func custom (_ size: CGFloat) -> CGFloat {
        return size
    }
}
