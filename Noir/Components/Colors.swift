//
//  Colors.swift
//  NoirBrowser
//
//  Created by Andre Mossi on 3/28/26.
//

import SwiftUI

extension Color {
    /// - Parameter hex: hex string to convert to color.
    /// - Parameter darkenBy: 0.0 is original, 1.0 is pure black.
    init(hex: String, darkenBy: Double = 0.0) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let r, g, b: UInt64

        switch hex.count {
        case 6:
            (r, g, b) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (255, 255, 255)
        }

        let multiplier = 1.0 - max(0, min(darkenBy, 1.0))

        self.init(
            .sRGB,
            red: (Double(r) / 255) * multiplier,
            green: (Double(g) / 255) * multiplier,
            blue: (Double(b) / 255) * multiplier,
            opacity: 1
        )
    }
}
