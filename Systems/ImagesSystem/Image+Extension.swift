import UIKit

// MARK: - UIImage Theme Extensions

extension UIImage {
    
    // MARK: - Theme-aware Image Creation
    
    /// Creates an image with theme tint color applied
    static func themeImage(named name: String, tintColor: AppColors) -> UIImage? {
        let image = UIImage(named: name)?.withRenderingMode(.alwaysTemplate)
        return image?.withTintColor(ThemeManager.shared.color(tintColor))
    }
    
    /// Creates a system symbol image with theme tint color
    static func themeImage(systemName: String, tintColor: AppColors, pointSize: CGFloat = 17.0) -> UIImage? {
        let config = UIImage.SymbolConfiguration(pointSize: pointSize)
        let image = UIImage(systemName: systemName, withConfiguration: config)?
            .withRenderingMode(.alwaysTemplate)
        return image?.withTintColor(ThemeManager.shared.color(tintColor))
    }
    
    // MARK: - Color Application
    
    /// Returns the image with theme tint color applied
    func withThemeTintColor(_ colorSet: AppColors) -> UIImage {
        return self.withTintColor(ThemeManager.shared.color(colorSet))
    }
    
    /// Applies a gradient overlay to the image using theme colors
    func withThemeGradient(startColor: GradientColors, endColor: GradientColors, direction: GradientDirection = .vertical) -> UIImage? {
        let size = self.size
        let bounds = CGRect(origin: .zero, size: size)
        
        UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        let isDarkMode = ThemeManager.shared.isDarkModeActive
        let colors = [
            startColor.colorWithAppearance(alpha: 1.0, darkMode: isDarkMode).cgColor,
            endColor.colorWithAppearance(alpha: 1.0, darkMode: isDarkMode).cgColor
        ]
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: nil) else {
            UIGraphicsEndImageContext()
            return nil
        }
        
        let startPoint: CGPoint
        let endPoint: CGPoint
        
        switch direction {
        case .horizontal:
            startPoint = CGPoint(x: 0, y: size.height / 2)
            endPoint = CGPoint(x: size.width, y: size.height / 2)
        case .vertical:
            startPoint = CGPoint(x: size.width / 2, y: 0)
            endPoint = CGPoint(x: size.width / 2, y: size.height)
        case .diagonalTopLeftToBottomRight:
            startPoint = CGPoint(x: 0, y: 0)
            endPoint = CGPoint(x: size.width, y: size.height)
        case .diagonalTopRightToBottomLeft:
            startPoint = CGPoint(x: size.width, y: 0)
            endPoint = CGPoint(x: 0, y: size.height)
        case .custom(let start, let end):
            startPoint = CGPoint(x: start.x * size.width, y: start.y * size.height)
            endPoint = CGPoint(x: end.x * size.width, y: end.y * size.height)
        }
        
        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])
        
        self.draw(in: bounds, blendMode: .destinationIn, alpha: 1.0)
        
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return gradientImage
    }
    
    // MARK: - Image Effects
    
    /// Returns the image with rounded corners
    func withRoundedCorners(radius: CGFloat) -> UIImage? {
        let size = self.size
        let bounds = CGRect(origin: .zero, size: size)
        
        UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: radius)
        path.addClip()
        self.draw(in: bounds)
        
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return roundedImage
    }
    
    /// Returns the image with circular mask applied
    func withCircularMask() -> UIImage? {
        let size = self.size
        let dimension = min(size.width, size.height)
        let bounds = CGRect(x: 0, y: 0, width: dimension, height: dimension)
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, self.scale)
        let path = UIBezierPath(ovalIn: bounds)
        path.addClip()
        
        let drawRect = CGRect(
            x: (dimension - size.width) / 2,
            y: (dimension - size.height) / 2,
            width: size.width,
            height: size.height
        )
        self.draw(in: drawRect)
        
        let circularImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return circularImage
    }
    
    /// Returns the image with specified alpha value
    func withAlpha(_ alpha: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        
        draw(at: .zero, blendMode: .normal, alpha: alpha)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    // MARK: - Size Adjustments
    
    /// Returns the image resized to specified size
    func resized(to newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        defer { UIGraphicsEndImageContext() }
        
        self.draw(in: CGRect(origin: .zero, size: newSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    /// Returns the image scaled to fit within specified size maintaining aspect ratio
    func scaledToFit(size: CGSize) -> UIImage? {
        let aspectRatio = self.size.width / self.size.height
        let targetAspectRatio = size.width / size.height
        
        var newSize = size
        if aspectRatio > targetAspectRatio {
            newSize.height = size.width / aspectRatio
        } else {
            newSize.width = size.height * aspectRatio
        }
        
        return resized(to: newSize)
    }
}


// MARK: - UIImage Transition Extensions

extension UIImage {
    
    /// Applies transition animation when changing image
    static func applyTransition(
        to imageView: UIImageView,
        image: UIImage?,
        duration: TimeInterval = 0.3,
        options: UIView.AnimationOptions = .transitionCrossDissolve,
        tintColor: UIColor? = nil,
        completion: ((Bool) -> Void)? = nil
    ) {
        UIView.transition(with: imageView, duration: duration, options: options, animations: {
            imageView.image = image
            if let color = tintColor {
                imageView.tintColor = color
            }
        }, completion: completion)
    }
    
    /// Applies transition with theme color
    static func applyThemeTransition(
        to imageView: UIImageView,
        image: UIImage?,
        colorSet: AppColors,
        duration: TimeInterval = 0.3,
        options: UIView.AnimationOptions = .transitionCrossDissolve,
        completion: ((Bool) -> Void)? = nil
    ) {
        let color = ThemeManager.shared.color(colorSet)
        applyTransition(to: imageView, image: image, duration: duration, options: options, tintColor: color, completion: completion)
    }
    
    /// Applies flip animation when changing image
    static func applyFlipTransition(
        to imageView: UIImageView,
        image: UIImage?,
        duration: TimeInterval = 0.5,
        direction: UIAxis = .vertical,
        tintColor: UIColor? = nil,
        completion: ((Bool) -> Void)? = nil
    ) {
        let flipDirection: CGFloat = (direction == .vertical) ? -1.0 : 1.0
        
        UIView.animate(withDuration: duration/2, animations: {
            if direction == .vertical {
                imageView.transform = CGAffineTransform(rotationAngle: .pi/2 * flipDirection)
            } else {
                imageView.transform = CGAffineTransform(scaleX: 0.1, y: 1.0)
            }
        }, completion: { _ in
            imageView.image = image
            if let color = tintColor {
                imageView.tintColor = color
            }
            
            UIView.animate(withDuration: duration/2, animations: {
                imageView.transform = CGAffineTransform.identity
            }, completion: completion)
        })
    }
    
    /// Applies flip transition with theme color
    static func applyThemeFlipTransition(
        to imageView: UIImageView,
        image: UIImage?,
        colorSet: AppColors,
        duration: TimeInterval = 0.5,
        direction: UIAxis = .vertical,
        completion: ((Bool) -> Void)? = nil
    ) {
        let color = ThemeManager.shared.color(colorSet)
        applyFlipTransition(to: imageView, image: image, duration: duration, direction: direction, tintColor: color, completion: completion)
    }
    
    /// Applies pulse effect animation to image view
    static func applyPulseEffect(
        to imageView: UIImageView,
        scale: CGFloat = 1.2,
        duration: TimeInterval = 0.3,
        completion: ((Bool) -> Void)? = nil
    ) {
        let originalTransform = imageView.transform
        
        UIView.animate(withDuration: duration/2, animations: {
            imageView.transform = originalTransform.scaledBy(x: scale, y: scale)
        }, completion: { _ in
            UIView.animate(withDuration: duration/2, animations: {
                imageView.transform = originalTransform
            }, completion: completion)
        })
    }
}
