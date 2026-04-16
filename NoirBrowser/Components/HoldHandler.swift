//
//  HoldHandler.swift
//  NoirBrowser
//
//  Created by Andre Mossi on 4/14/26.
//

import AppKit
import Combine

class LongPressKeyHandler: ObservableObject {
    @Published var isActive = false
    
    let shortPressAction: () -> Void
    let longPressAction: () -> Void
    let duration: TimeInterval
    let keyCode: UInt16
    let modifiers: NSEvent.ModifierFlags
    
    private var timer: Timer?
    private var monitor: Any?
    private var keyDownCount = 0
    
    init(
        keyCode: UInt16,
        modifiers: NSEvent.ModifierFlags = [.command],
        duration: TimeInterval = 1.5,
        shortPress: @escaping () -> Void,
        longPress: @escaping () -> Void
    ) {
        self.keyCode = keyCode
        self.modifiers = modifiers
        self.duration = duration
        self.shortPressAction = shortPress
        self.longPressAction = longPress
    }
    
    func start() {
        monitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            self?.handleKeyDown(event)
            return event
        }
        
        NSEvent.addLocalMonitorForEvents(matching: .keyUp) { [weak self] event in
            self?.handleKeyUp(event)
            return event
        }
    }
    
    func stop() {
        timer?.invalidate()
        if let monitor = monitor {
            NSEvent.removeMonitor(monitor)
        }
    }
    
    private func handleKeyDown(_ event: NSEvent) {
        guard event.keyCode == keyCode,
              event.modifierFlags.intersection(modifiers) == modifiers else {
            reset()
            return
        }
        
        keyDownCount += 1
        
        if keyDownCount == 1 {
            startTimer()
        }
    }
    
    private func handleKeyUp(_ event: NSEvent) {
        guard event.keyCode == keyCode else { return }
        
        if keyDownCount == 1 {
            timer?.invalidate()
            shortPressAction()
            isActive = true
        }
        reset()
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { [weak self] _ in
            self?.longPressAction()
            self?.reset()
        }
    }
    
    private func reset() {
        timer?.invalidate()
        timer = nil
        keyDownCount = 0
        isActive = false
    }
}
