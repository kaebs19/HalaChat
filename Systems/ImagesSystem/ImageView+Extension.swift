
import UIKit
import ObjectiveC

// MARK: - UIImageView Theme Extensions

extension UIImageView {
    
    // MARK: - Instant Theme Setup
    
    func setupForInstantTheme(
        image: AppImage? = nil,
        tintColorSet: AppColors? = nil,
        backgroundColorSet: AppColors = .clear,
        contentMode: UIView.ContentMode = .scaleAspectFit,
        cornerRadius: CGFloat = 0,
        borderColorSet: AppColors? = nil,
        borderWidth: CGFloat = 0
    ) {
        if let appImage = image {
            self.image = appImage.image
        }
        
        if let tintColor = tintColorSet {
            self.tintColor = ThemeManager.shared.color(tintColor)
            self.image = self.image?.withRenderingMode(.alwaysTemplate)
        }
        
        self.backgroundColor = ThemeManager.shared.color(backgroundColorSet)
        self.contentMode = contentMode
        
        if cornerRadius > 0 {
            self.addRadius(cornerRadius)
        }
        
        if let borderColor = borderColorSet, borderWidth > 0 {
            self.layer.borderColor = ThemeManager.shared.color(borderColor).cgColor
            self.layer.borderWidth = borderWidth
        }
        
        saveImageViewParameters(
            image: image,
            tintColorSet: tintColorSet,
            backgroundColorSet: backgroundColorSet,
            borderColorSet: borderColorSet,
            borderWidth: borderWidth
        )
    }
    
    func updateInstantThemeColors() {
        guard let parameters = getImageViewParameters() else {
            return
        }
        
        if let tintColor = parameters.tintColorSet {
            self.tintColor = ThemeManager.shared.color(tintColor)
        }
        
        self.backgroundColor = ThemeManager.shared.color(parameters.backgroundColorSet)
        
        if parameters.borderWidth > 0, let borderColor = parameters.borderColorSet {
            self.layer.borderColor = ThemeManager.shared.color(borderColor).cgColor
        }
    }
    
    // MARK: - Theme Transitions
    
    func applyThemeTransition(
        to image: AppImage?,
        tintColorSet: AppColors? = nil,
        duration: TimeInterval = 0.3,
        options: UIView.AnimationOptions = .transitionCrossDissolve,
        completion: ((Bool) -> Void)? = nil
    ) {
        let tintColor = tintColorSet.map { ThemeManager.shared.color($0) }
        
        UIView.transition(with: self, duration: duration, options: options, animations: {
            self.image = image?.image
            if let color = tintColor {
                self.tintColor = color
                self.image = self.image?.withRenderingMode(.alwaysTemplate)
            }
        }, completion: completion)
        
        if let tintColorSet = tintColorSet {
            updateImageParameters(tintColorSet: tintColorSet)
        }
    }
    
    func applyThemeFlipTransition(
        to image: AppImage?,
        tintColorSet: AppColors? = nil,
        duration: TimeInterval = 0.5,
        direction: UIAxis = .vertical,
        completion: ((Bool) -> Void)? = nil
    ) {
        let flipDirection: CGFloat = (direction == .vertical) ? -1.0 : 1.0
        let tintColor = tintColorSet.map { ThemeManager.shared.color($0) }
        
        UIView.animate(withDuration: duration/2, animations: {
            if direction == .vertical {
                self.transform = CGAffineTransform(rotationAngle: .pi/2 * flipDirection)
            } else {
                self.transform = CGAffineTransform(scaleX: 0.1, y: 1.0)
            }
        }, completion: { _ in
            self.image = image?.image
            if let color = tintColor {
                self.tintColor = color
                self.image = self.image?.withRenderingMode(.alwaysTemplate)
            }
            
            UIView.animate(withDuration: duration/2, animations: {
                self.transform = CGAffineTransform.identity
            }, completion: completion)
        })
        
        if let tintColorSet = tintColorSet {
            updateImageParameters(tintColorSet: tintColorSet)
        }
    }
    
    func applyPulseEffect(
        scale: CGFloat = 1.2,
        duration: TimeInterval = 0.3,
        completion: ((Bool) -> Void)? = nil
    ) {
        let originalTransform = self.transform
        
        UIView.animate(withDuration: duration/2, animations: {
            self.transform = originalTransform.scaledBy(x: scale, y: scale)
        }, completion: { _ in
            UIView.animate(withDuration: duration/2, animations: {
                self.transform = originalTransform
            }, completion: completion)
        })
    }
    
    // MARK: - Specialized Setup Methods
    
    func setupAsIconView(
        icon: AppImage,
        tintColorSet: AppColors,
        size: CGSize? = nil,
        backgroundColorSet: AppColors = .clear,
        cornerRadius: CGFloat = 0
    ) {
        setupForInstantTheme(
            image: icon,
            tintColorSet: tintColorSet,
            backgroundColorSet: backgroundColorSet,
            contentMode: .center,
            cornerRadius: cornerRadius
        )
        
        if let size = size {
            self.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                self.widthAnchor.constraint(equalToConstant: size.width),
                self.heightAnchor.constraint(equalToConstant: size.height)
            ])
        }
    }
    
    func setupAsProfileImage(
        placeholder: AppImage? = nil,
        borderColorSet: AppColors = .border,
        borderWidth: CGFloat = 2
    ) {
        setupForInstantTheme(
            image: placeholder,
            backgroundColorSet: .secondBackground,
            contentMode: .scaleAspectFill,
            borderColorSet: borderColorSet,
            borderWidth: borderWidth
        )
        self.clipsToBounds = true
    }
    
    func setupAsThumbnailView(
        placeholder: AppImage? = nil,
        cornerRadius: CGFloat = 8,
        backgroundColorSet: AppColors = .secondBackground
    ) {
        setupForInstantTheme(
            image: placeholder,
            backgroundColorSet: backgroundColorSet,
            contentMode: .scaleAspectFill,
            cornerRadius: cornerRadius
        )
        self.clipsToBounds = true
    }
    
    // MARK: - Helper Methods
    
    func setThemeImage(_ appImage: AppImage, withTintColor colorSet: AppColors? = nil) {
        self.image = appImage.image
        
        if let tintColorSet = colorSet {
            self.tintColor = ThemeManager.shared.color(tintColorSet)
            self.image = self.image?.withRenderingMode(.alwaysTemplate)
            updateImageParameters(tintColorSet: tintColorSet)
        }
    }
    
    func updateThemeImage() {
        guard let parameters = getImageViewParameters() else {
            return
        }
        
        if let appImage = parameters.image {
            self.image = appImage.image
        }
        
        updateInstantThemeColors()
    }
}

// MARK: - Private Storage Methods

private extension UIImageView {
    
    func saveImageViewParameters(
        image: AppImage?,
        tintColorSet: AppColors?,
        backgroundColorSet: AppColors,
        borderColorSet: AppColors?,
        borderWidth: CGFloat
    ) {
        let parameters = ImageViewParameters(
            image: image,
            tintColorSet: tintColorSet,
            backgroundColorSet: backgroundColorSet,
            borderColorSet: borderColorSet,
            borderWidth: borderWidth
        )
        
        objc_setAssociatedObject(
            self,
            &AssociatedKeys.imageViewParameters,
            parameters,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
    }
    
    func getImageViewParameters() -> ImageViewParameters? {
        return objc_getAssociatedObject(self, &AssociatedKeys.imageViewParameters) as? ImageViewParameters
    }
    
    func updateImageParameters(tintColorSet: AppColors) {
        guard var parameters = getImageViewParameters() else {
            return
        }
        
        parameters.tintColorSet = tintColorSet
        
        objc_setAssociatedObject(
            self,
            &AssociatedKeys.imageViewParameters,
            parameters,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
    }
}

// MARK: - Parameter Structure

private struct ImageViewParameters {
    let image: AppImage?
    var tintColorSet: AppColors?
    let backgroundColorSet: AppColors
    let borderColorSet: AppColors?
    let borderWidth: CGFloat
}

// MARK: - Associated Keys

private extension AssociatedKeys {
    static var imageViewParameters: UInt8 = 40
}

// MARK: - Theme-aware Image Loading

extension UIImageView {
    
    func loadThemeImage(
        from url: URL?,
        placeholder: AppImage? = nil,
        tintColorSet: AppColors? = nil,
        completion: ((Bool) -> Void)? = nil
    ) {
        if let placeholder = placeholder {
            self.image = placeholder.image
        }
        
        if let tintColor = tintColorSet {
            self.tintColor = ThemeManager.shared.color(tintColor)
            self.image = self.image?.withRenderingMode(.alwaysTemplate)
        }
        
        guard let url = url else {
            completion?(false)
            return
        }
        
        // Simplified image loading - replace with actual implementation
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion?(false)
                }
                return
            }
            
            DispatchQueue.main.async {
                self?.applyThemeTransition(
                    to: nil,
                    tintColorSet: tintColorSet,
                    duration: 0.3
                ) { _ in
                    self?.image = image
                    completion?(true)
                }
            }
        }.resume()
    }
}
