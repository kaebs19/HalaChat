
import UIKit

extension UIButton {
    
    // تطبيق لون النص والخلفية المتوافق مع السمة
    func setThemeTitleColor(_ colorSet: ColorSet , for state: UIControl.State = .normal) {
        
        // إلغاء المراقب السابق إذا وجد
        removeThemeObserver(forKey: &AssociatedKeys.themeObserver)
        
        // تعيين اللون الحالي
        setTitleColor(ThemeManager.shared.color(colorSet), for: state)

        // إضافة مراقب جديد
        let observer = ThemeManager.shared.addThemeObserver { [weak self] in
            self?.setTitleColor(ThemeManager.shared.color(colorSet), for: state)
        }
        
        // تخزين المعرف مع العنصر
        setThemeObserver(id: observer, forKey: &AssociatedKeys.themeObserver)
        
    }
    
  
    
    /// تخصيص النص في Button
    func customize(title: Buttons? = nil,
                   titleColorSet:ColorSet, backgroundColorSet:ColorSet? = nil,
                   ofSize: Sizes,
                   font: Fonts , fontStyle: FontStyle = .regular,
                   state: UIControl.State = .normal
    
    ) {
        if let title = title {
            self.setTitle(title.textBtn, for: state)
        }
        self.setThemeTitleColor(titleColorSet, for: state)
        
        if let backgroundColorSet = backgroundColorSet {
            self.setThemeBackgroundColor(backgroundColorSet)
        }

        
        self.titleLabel?.font = FontManager.shared.font(family: font, style: fontStyle , size: ofSize)
    }
    
    // إضافة تأثير ضغط للزر

    func addPressAnimation() {
        addTarget(self, action: #selector(buttonPressed), for: .touchDown)
        addTarget(self, action: #selector(buttonReleased), for: [.touchUpInside , .touchUpOutside , .touchCancel])
    }
    
    @objc func buttonPressed() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.alpha = 0.9
        }
    }
    
    @objc func buttonReleased() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform.identity
            self.alpha = 1.0
        }
    }
   
}
