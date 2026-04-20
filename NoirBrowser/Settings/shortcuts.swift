//
//  shortcuts.swift
//  NoirBrowser
//
//  Created by Andre Mossi on 4/2/26.
//

import Foundation
import SwiftUI
#if canImport(UIKit)
import UIKit
#endif
#if canImport(AppKit)
import AppKit
#endif

struct ShortcutItem: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var description: String
    var binding: String
    var group: String
    
    // MARK: - Static Global Access
    private static let all: [ShortcutItem] = [
        // MARK: - Tabs
        ShortcutItem(name: "New Tab", description: "Open a new tab", binding: "⌘T", group: "Tabs"),
        ShortcutItem(name: "Close Tab", description: "Close current tab", binding: "⌘W", group: "Tabs"),
        ShortcutItem(name: "Reopen Closed Tab", description: "Restore last closed tab", binding: "⌘⇧T", group: "Tabs"),
        ShortcutItem(name: "Next Tab", description: "Switch to next tab (right)", binding: "⌃⇥", group: "Tabs"),
        ShortcutItem(name: "Previous Tab", description: "Switch to previous tab (left)", binding: "⌃⇧⇥", group: "Tabs"),
        ShortcutItem(name: "New Window", description: "Open new browser window", binding: "⌘N", group: "Windows"),
        ShortcutItem(name: "Close Window", description: "Close current window", binding: "⌘⇧W", group: "Windows"),
        
        // MARK: - Navigation
        ShortcutItem(name: "Address Bar", description: "Focus address bar", binding: "⌘L", group: "Navigation"),
        ShortcutItem(name: "Back", description: "Go back in history", binding: "⌘[", group: "Navigation"),
        ShortcutItem(name: "Forward", description: "Go forward in history", binding: "⌘]", group: "Navigation"),
        ShortcutItem(name: "Reload", description: "Reload current page", binding: "⌘R", group: "Navigation"),
        ShortcutItem(name: "Reload Hard", description: "Hard reload (bypass cache)", binding: "⌘⇧R", group: "Navigation"),
        
        // MARK: - Search
        ShortcutItem(name: "Find on Page", description: "Search text on current page", binding: "⌘F", group: "Search"),
        ShortcutItem(name: "Quick Search", description: "Focus search in address bar", binding: "⌘K", group: "Search"),
        ShortcutItem(name: "Find Next", description: "Next search result", binding: "⌘G", group: "Search"),
        ShortcutItem(name: "Find Previous", description: "Previous search result", binding: "⌘⇧G", group: "Search"),
        
        // MARK: - Bookmarks
        ShortcutItem(name: "Bookmark Page", description: "Add current page to bookmarks", binding: "⌘D", group: "Bookmarks"),
        ShortcutItem(name: "Show Bookmarks", description: "Open bookmarks manager", binding: "⌘⇧O", group: "Bookmarks"),
        ShortcutItem(name: "Bookmarks Bar", description: "Toggle bookmarks bar", binding: "⌘⇧B", group: "Bookmarks"),
        
        // MARK: - History
        ShortcutItem(name: "Show History", description: "Open browsing history", binding: "⌘Y", group: "History"),
        ShortcutItem(name: "Downloads", description: "Open downloads page", binding: "⌘⇧J", group: "Downloads"),
        
        // MARK: - Developer Tools
        ShortcutItem(name: "Inspect Element", description: "Open DevTools Inspector", binding: "⌘⇧C", group: "Developer"),
        ShortcutItem(name: "DevTools", description: "Toggle Developer Tools", binding: "⌘⌥I", group: "Developer"),
        ShortcutItem(name: "Console", description: "Open DevTools Console", binding: "⌘⌥J", group: "Developer"),
        
        // MARK: - Windows & Tabs
        ShortcutItem(name: "Tab Overview", description: "Show all tabs overview", binding: "⌘⇧\\", group: "Tabs"),
        ShortcutItem(name: "New Private Window", description: "Open incognito/private window", binding: "⌘⇧N", group: "Windows"),
        
        // MARK: - Fullscreen & Zoom
        ShortcutItem(name: "Fullscreen", description: "Toggle fullscreen mode", binding: "⌃⌘F", group: "View"),
        ShortcutItem(name: "Zoom In", description: "Zoom page in", binding: "⌘+", group: "View"),
        ShortcutItem(name: "Zoom Out", description: "Zoom page out", binding: "⌘-", group: "View"),
        ShortcutItem(name: "Reset Zoom", description: "Reset page zoom to 100%", binding: "⌘0", group: "View"),
    ]
    
    // MARK: - Fast lookup by binding
    static let byBinding: [String: ShortcutItem] = {
        var dict: [String: ShortcutItem] = [:]
        for item in all {
            dict[item.binding] = item
        }
        return dict
    }()
    
    // MARK: - Fast lookup by name
    static let byName: [String: ShortcutItem] = {
        var dict: [String: ShortcutItem] = [:]
        for item in all {
            dict[item.name] = item
        }
        return dict
    }()
    
    // MARK: - Grouped for UI
    static let grouped: [String: [ShortcutItem]] = {
        var groups: [String: [ShortcutItem]] = [:]
        for item in all {
            groups[item.group, default: []].append(item)
        }
        return groups
    }()
    
    // MARK: - Quick access methods
    static func shortcut(named name: String) -> ShortcutItem? {
        byName[name]
    }
    
    static func shortcut(forBinding binding: String) -> ShortcutItem? {
        byBinding[binding]
    }
    
    static func shortcuts(in group: String) -> [ShortcutItem] {
        grouped[group] ?? []
    }
    
    static func allShortcuts() -> [ShortcutItem] {
        all
    }
}

extension ShortcutItem {
    // Parse a binding like "⌘⇧T" into a KeyEquivalent and modifiers
    private func keyEquivalentAndModifiers() -> (KeyEquivalent, EventModifiers) {
        var modifiers: EventModifiers = []
        var scalar: Character? = nil

        // Walk characters and collect modifiers; last non-modifier becomes key
        for ch in binding {
            switch ch {
            case "⌘": modifiers.insert(.command)
            case "⇧": modifiers.insert(.shift)
            case "⌥": modifiers.insert(.option)
            case "⌃": modifiers.insert(.control)
            default:
                // Use first non-modifier as the key; keep last if multiple
                if scalar == nil || ch.isLetter || ch.isNumber { scalar = ch }
            }
        }

        let key: KeyEquivalent
        if let s = scalar {
            // Map some common special keys, otherwise use the character
            switch s {
            case "[": key = "["
            case "]": key = "]"
            case "+": key = "+"
            case "-": key = "-"
            case "0": key = "0"
            case "\\": key = "\\"
            default:
                key = KeyEquivalent(s.lowercased().first!)
            }
        } else {
            // Fallback to return key if parsing failed
            key = .return
        }

        return (key, modifiers)
    }

    // SwiftUI Commands helper for use in a Commands builder
    @CommandsBuilder
    func swiftUICommand(perform: @escaping () -> Void) -> some Commands {
        let (key, mods) = keyEquivalentAndModifiers()
        CommandMenu(group) {
            Button(name, action: perform).keyboardShortcut(key, modifiers: mods)
        }
    }
}

#if canImport(UIKit)
extension ShortcutItem {
    // UIKit-specific key command for iPadOS/macOS Catalyst
    var uiKeyCommand: UIKeyCommand {
        // Derive input and modifier flags from the binding string safely
        let (input, flags) = uiKeyCommandComponents()
        let command = UIKeyCommand(input: input, modifierFlags: flags, action: #selector(ShortcutHandler.handleKeyCommand(_:)))
        command.discoverabilityTitle = name
        return command
    }

    private func uiKeyCommandComponents() -> (String, UIKeyModifierFlags) {
        var flags: UIKeyModifierFlags = []
        var input: String = ""
        for ch in binding {
            switch ch {
            case "⌘": flags.insert(.command)
            case "⇧": flags.insert(.shift)
            case "⌥": flags.insert(.alternate)
            case "⌃": flags.insert(.control)
            default:
                if input.isEmpty { input = String(ch) }
            }
        }
        if input.isEmpty { input = UIKeyCommand.inputReturn }
        return (input, flags)
    }
}
#endif
