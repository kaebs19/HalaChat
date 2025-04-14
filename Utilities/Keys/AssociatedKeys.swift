
import UIKit
import ObjectiveC


/// امتداد لكائنات النظام يوفر طرق لتخزين واسترجاع خصائص مخصصة
extension NSObject {
    
    
    // مفاتيح للخصائص المرتبطة
    /*
     هذا هيكل بسيط يحتوي على مفاتيح ثابتة (متغيرات ثابتة) تُستخدم كمعرفات فريدة
     4. نظام المراقبين themeObservers
     هذا نظام يسمح للعناصر بالاستجابة لتغييرات السمة. عندما تتغير السمة، نريد أن تتغير ألوان جميع العناصر تلقائيًا.

     */
     struct AssociatedKeys {
        static var themeObserver = "themeObserver"
        static var placeholderThemeObserver = "placeholderThemeObserver"
        static var backgroundThemeObserver = "backgroundThemeObserver"
        static var borderThemeObserver = "borderThemeObserver" 

    }

    
    /// تخزين مراقب سمة مع الكائن
    func  setThemeObserver(id: UUID , forKey key: UnsafeRawPointer) {
        objc_setAssociatedObject(self,
                                 key,
                                 id,
                                 .OBJC_ASSOCIATION_RETAIN_NONATOMIC
                                 )
    }
    
    /// استرجاع معرف مراقب السمة من الكائن

    func getThemeObserver(forKey key: UnsafeRawPointer) -> UUID? {
        return objc_getAssociatedObject(self, key ) as? UUID
    }
    
    /// إزالة مراقب السمة من الكائن وإلغاء التسجيل من مدير السمات
    
    func removeThemeObserver(forKey key: UnsafeRawPointer) {
        
        if let observerId = getThemeObserver(forKey: key) {
            ThemeManager.shared.removeThemeObserver(id: observerId)
            
            objc_setAssociatedObject(self,
                                     key,
                                     nil,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
