//
//  GradientDirection.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 18/04/2025.
//

import Foundation


/// تعريف اتجاهات التدرج
enum GradientDirection {
    case horizontal // من اليسار إلى اليمين
    case vertical // من الأعلى إلى الأسفل
    case diagonalTopLeftToBottomRight // من أعلى اليسار إلى أسفل اليمين
    case diagonalTopRightToBottomLeft // من أعلى اليمين إلى أسفل اليسار
    case custom(startPoint: CGPoint, endPoint: CGPoint) // اتجاه مخصص
}
