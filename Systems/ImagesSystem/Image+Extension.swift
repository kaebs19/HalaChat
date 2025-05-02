//
//  Image+Extension.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 01/05/2025.
//

import UIKit

extension UIImage {
    
    /// تطبيق تأثير انتقالي تدريجي (cross dissolve) على صورة في UIImageView
    static func applyTransition(
        to imageView: UIImageView,
        image: UIImage?,
        duration: TimeInterval = 0.4,
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
    

    /// تطبيق تأثير انتقالي على صورة باستخدام نظام السمات
    static func applyThemeTransition(
        to imageView: UIImageView,
        image: UIImage?,
        colorSet: AppColors,
        duration: TimeInterval = 0.4,
        options: UIView.AnimationOptions = .transitionCrossDissolve,
        completion: ((Bool) -> Void)? = nil
    ) {
        let color = ThemeManager.shared.color(colorSet)
        applyTransition(to: imageView, image: image, duration: duration, options: options, tintColor: color, completion: completion)
    }

    
    /// تطبيق تأثير انتقالي بين صورتين مع تأثير الدوران
    static func applyFlipTransition(
        to imageView: UIImageView,
        image: UIImage?,
        duration: TimeInterval = 0.5,
        direction: UIAxis = .vertical,
        tintColor: UIColor? = nil,
        completion: ((Bool) -> Void)? = nil
    ) {
        // الاتجاه المناسب للدوران
        let flipDirection: CGFloat = (direction == .vertical) ? -1.0 : 1.0
        
        // الدوران إلى النصف الأول
        UIView.animate(withDuration: duration/2, animations: {
            if direction == .vertical {
                imageView.transform = CGAffineTransform(rotationAngle: .pi/2 * flipDirection)
            } else {
                imageView.transform = CGAffineTransform(scaleX: 0.1, y: 1.0)
            }
        }, completion: { _ in
            // تغيير الصورة في منتصف التأثير
            imageView.image = image
            if let color = tintColor {
                imageView.tintColor = color
            }
            
            // إكمال النصف الثاني من الدوران
            UIView.animate(withDuration: duration/2, animations: {
                if direction == .vertical {
                    imageView.transform = CGAffineTransform.identity
                } else {
                    imageView.transform = CGAffineTransform.identity
                }
            }, completion: completion)
        })
    }

    
    /// تطبيق تأثير انتقالي دوراني مع نظام السمات

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

    
    /// تطبيق تأثير نبض على UIImageView
    static func applyPulseEffect(
        to imageView: UIImageView,
        scale: CGFloat = 1.2,
        duration: TimeInterval = 0.3,
        completion: ((Bool) -> Void)? = nil
    ) {
        // حفظ التحويل الأصلي
        let originalTransform = imageView.transform
        
        // تكبير
        UIView.animate(withDuration: duration/2, animations: {
            imageView.transform = originalTransform.scaledBy(x: scale, y: scale)
        }, completion: { _ in
            // تصغير للحجم الأصلي
            UIView.animate(withDuration: duration/2, animations: {
                imageView.transform = originalTransform
            }, completion: completion)
        })
    }

}
