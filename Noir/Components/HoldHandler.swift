//
//  HoldHandler.swift
//  NoirBrowser
//
//  Created by Andre Mossi on 4/14/26.
//

import AppKit
import SwiftUI

@MainActor
struct LongPressKeyHandler: ViewModifier {
    let keys: Set<KeyEquivalent>
    let shortPressAction: () -> Void
    let longPressAction: () -> Void
    let duration: TimeInterval

    @State private var pressStartTime: Date?
    @State private var timer: Timer?

    func body(content: Content) -> some View {
        content
            .focusable()
            .onKeyPress(keys: keys, phases: [.down, .up]) { keyPress in
                switch keyPress.phase {
                case .down:
                    pressStartTime = Date()

                    timer?.invalidate()
                    timer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { _ in
                        Task { @MainActor in
                            longPressAction()
                            timer?.invalidate()
                            timer = nil
                            pressStartTime = nil
                        }
                    }

                    return .handled

                case .up:
                    timer?.invalidate()
                    timer = nil

                    if let startTime = pressStartTime {
                        let held = Date().timeIntervalSince(startTime)
                        if held < duration {
                            shortPressAction()
                        }
                    }

                    pressStartTime = nil
                    return .handled

                default:
                    return .ignored
                }
            }
    }
}
