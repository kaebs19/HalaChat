//
//  ThemeProtocols.swift
//  HalaChat
//
//  Created by Mohammed Saleh on 01/06/2025.
//

import Foundation
import UIKit

// MARK: - Instant Theme Management Protocol
protocol InstantThemeUpdatable: AnyObject {
    /// 🔄 دالة التحديث التلقائي للألوان (يتم استدعاؤها تلقائياً عند تغيير السمة)
    func applyInstantThemeUpdate()
    func handleThemeTransition()
    func showThemeChangeNotification()
}

