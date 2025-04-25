

import UIKit


extension UITextView {
    
        
    /// تخصيص النص في - TextView
    
    func customize(
    text: TextViews? = nil,
    textColor: AppColors , backgroundColor: AppColors? = nil,
    family: Fonts,
    style: FontStyle = .regular,
    size: Sizes,
    color: UIColor = .black,
    direction: Directions = .Normal
    ) {
        
        self.text = text?.textTV ?? self.text
        self.textColor = color
        
        if let backgroundColor = backgroundColor {
            self.backgroundColor = backgroundColor.color
        }
        
        self.font = FontManager.shared.font(family: family, style: style, size: size)
        self.textAlignment = direction.textAlignment
    }
    
    

    
}
