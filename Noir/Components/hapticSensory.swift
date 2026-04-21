//
//  hapticSensory.swift
//  NoirBrowser
//
//  Created by Andre Mossi on 4/7/26.
//

import CoreHaptics
import SwiftUI
#if os(iOS)
    import UIKit
#endif

func haptic(_ type: HapticType) {
    #if os(iOS)
        switch type {
        case .impact:
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        case .selection:
            UISelectionFeedbackGenerator().selectionChanged()
        case .success:
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }
    #elseif os(macOS)
        let manager = NSHapticFeedbackManager.defaultPerformer

        switch type {
        case .impact:
            manager.perform(.generic, performanceTime: .default)
        case .selection:
            manager.perform(.alignment, performanceTime: .default)
        case .success:
            manager.perform(.levelChange, performanceTime: .default)
        }
    #endif
}

enum HapticType {
    case impact
    case selection
    case success
}
