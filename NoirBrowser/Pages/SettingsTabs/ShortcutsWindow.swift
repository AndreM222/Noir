//
//  ShortcutsWindow.swift
//  NoirBrowser
//
//  Created by Andre Mossi on 4/11/26.
//

import SwiftUI
import AppKit

struct ShortcutItem: Identifiable {
    let id = UUID()
    var name: String
    var description: String
    var binding: String
    var group: String
}

struct ShortcutRow: View {
    let item: ShortcutItem
    @State private var isHovering = false
    @Binding var selectedShortcut: ShortcutItem?

    var body: some View {
        Button {
            if selectedShortcut?.id == item.id {
                selectedShortcut = nil
            } else {
                selectedShortcut = item
            }
        } label: {
            HStack {
                Text(item.name)
                    .font(.system(size: 13, design: .rounded))
                    .foregroundStyle(.white.opacity(0.85))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                KeyBadge(binding: item.binding)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 9)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .background(selectedShortcut?.id == item.id ? .white.opacity(0.1) : isHovering ? .white.opacity(0.05) : .clear)
        .onHover { isHovering = $0 }
        .animation(.easeOut(duration: 0.12), value: isHovering)
    }
}

struct KeyBadge: View {
    let binding: String

    // Split e.g. "⌘⇧T" into ["⌘", "⇧", "T"]
    private var parts: [String] {
        let modifiers: [Character] = ["⌘", "⇧", "⌥", "⌃"]
        var result: [String] = []
        var remaining = binding

        for mod in modifiers {
            if remaining.contains(mod) {
                result.append(String(mod))
                remaining.removeAll { $0 == mod }
            }
        }

        let key = remaining.trimmingCharacters(in: .whitespaces)
        if !key.isEmpty { result.append(key) }
        return result
    }

    var body: some View {
        HStack(spacing: 4) {
            ForEach(parts, id: \.self) { part in
                Text(part)
                    .font(.system(size: 11, weight: .medium, design: .monospaced))
                    .foregroundStyle(.white.opacity(0.6))
                    .frame(minWidth: 22, minHeight: 22)
                    .padding(.horizontal, part.count > 1 ? 6 : 0)
                    .background(
                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                            .fill(.white.opacity(0.07))
                            .overlay(
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .stroke(.white.opacity(0.1), lineWidth: 0.5)
                            )
                    )
            }
        }
    }
}

private func iconForGroup(_ group: String) -> String {
    switch group.lowercased() {
    case "file":   return "doc"
    case "edit":   return "pencil"
    case "view":   return "eye"
    case "window": return "macwindow"
    case "help":   return "questionmark.circle"
    case "tab":    return "rectangle.split.2x1"
    default:       return "keyboard"
    }
}

struct KeyHeader: View {
    let binding: String
    @State private var pressed = false

    private var parts: [String] {
        let modifiers: [Character] = ["⌘", "⇧", "⌥", "⌃"]
        var result: [String] = []
        var remaining = binding

        for mod in modifiers {
            if remaining.contains(mod) {
                result.append(String(mod))
                remaining.removeAll { $0 == mod }
            }
        }

        let key = remaining.trimmingCharacters(in: .whitespaces)
        if !key.isEmpty { result.append(key) }
        return result
    }

    var body: some View {
        HStack(spacing: 5) {
            ForEach(Array(parts.enumerated()), id: \.offset) { index, part in
                Text(part)
                    .foregroundStyle(LinearGradient(
                        gradient: Gradient(colors: [.black.opacity(0.5), .black.opacity(0.3)]),
                        startPoint: .top, endPoint: .bottom
                    ))
                    .offset(y: pressed ? 0 : -2)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .padding(.horizontal, part.count > 1 ? 12 : 8)
                    .padding(.vertical, 10)
                    .frame(minWidth: 45, minHeight: 45)
                    .background(
                        GeometryReader { geo in
                            let w = geo.size.width
                            let h = geo.size.height
                            let innerW = w - 10
                            let innerH = h - 10

                            RoundedRectangle(cornerRadius: 14)
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: [.white.opacity(0.04), .white.opacity(0.08)]),
                                    startPoint: .top, endPoint: .bottom
                                ))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(.white.opacity(0.2))
                                )
                                .overlay(alignment: .top) {
                                    RoundedRectangle(cornerRadius: 9)
                                        .fill(LinearGradient(
                                            gradient: Gradient(colors: [
                                                .white.opacity(pressed ? 0.15 : 0.4),
                                                .white.opacity(pressed ? 0.08 : 0.2)
                                            ]),
                                            startPoint: .top, endPoint: .bottom
                                        ))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 9)
                                                .stroke(.white.opacity(0.2))
                                        )
                                        .frame(width: innerW, height: innerH)
                                        .offset(y: pressed ? 4 : 2)
                                }
                        }
                    )
                    .scaleEffect(pressed ? 0.95 : 1.0)
                    .transition(.scale(scale: 0.7).combined(with: .opacity))
                    .animation(
                        .spring(response: 0.28, dampingFraction: 0.6)
                        .delay(Double(index) * 0.06),
                        value: pressed
                    )
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: binding)
        .onAppear { triggerPress() }
        .onChange(of: binding) { triggerPress() }
    }

    private func triggerPress() {
        pressed = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            pressed = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                pressed = false
            }
        }
    }
}

// MARK: - Group Header

struct ShortcutGroupHeader: View {
    let title: String
    let icon: String

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(.white.opacity(0.3))
            Text(title.uppercased())
                .font(.system(size: 10, weight: .semibold, design: .rounded))
                .foregroundStyle(.white.opacity(0.3))
                .kerning(0.8)
        }
        .padding(.horizontal, 16)
        .padding(.top, 20)
        .padding(.bottom, 4)
    }
}

struct MenuShortcutScanner {
    static func scan() -> [String: [ShortcutItem]] {
        guard let mainMenu = NSApp.mainMenu else { return [:] }
        var grouped: [String: [ShortcutItem]] = [:]
        
        for topItem in mainMenu.items {
            let groupName = topItem.title.isEmpty ? "App" : topItem.title
            guard let submenu = topItem.submenu else { continue }
            let items = collectItems(from: submenu, group: groupName)
            if !items.isEmpty {
                grouped[groupName, default: []].append(contentsOf: items)
            }
        }
        
        return grouped
    }
    
    private static func collectItems(from menu: NSMenu, group: String) -> [ShortcutItem] {
        var result: [ShortcutItem] = []
        
        for item in menu.items {
            if let submenu = item.submenu {
                result += collectItems(from: submenu, group: group)
            }
            guard !item.keyEquivalent.isEmpty, !item.title.isEmpty else { continue }
            result.append(ShortcutItem(
                name: item.title,
                description: item.toolTip ?? "",
                binding: formatBinding(key: item.keyEquivalent, modifiers: item.keyEquivalentModifierMask),
                group: group
            ))
        }
        
        return result
    }
    
    private static func formatBinding(key: String, modifiers: NSEvent.ModifierFlags) -> String {
         var parts = ""
         if modifiers.contains(.control) { parts += "⌃" }
         if modifiers.contains(.option)  { parts += "⌥" }
         if modifiers.contains(.shift)   { parts += "⇧" }
         if modifiers.contains(.command) { parts += "⌘" }

         let specialKeys: [String: String] = [
             "\r": "↩", "\t": "⇥", " ": "Space",
             "\u{7F}": "⌫", "\u{F700}": "↑", "\u{F701}": "↓",
             "\u{F702}": "←", "\u{F703}": "→", "\u{F708}": "F5"
         ]

         parts += specialKeys[key] ?? key.uppercased()
         return parts
     }
}

struct ShortcutInfo: View {
    var item: ShortcutItem? = nil
    @State private var isHovering = false

    private var effectiveItem: ShortcutItem {
        if let item { return item }
        return ShortcutItem(
            name: "NOIR",
            description: "This section contains all the shortcuts available for NOIR and can be customized",
            binding: "⌘♺",
            group: "NOIR Shortcuts"
        )
    }

    var body: some View {
        VStack(spacing: 8) {
            // Key Preview
            GeometryReader { geo in
                ScrollView(.horizontal, showsIndicators: false) {
                    KeyHeader(binding: effectiveItem.binding)
                        .fixedSize()
                        .padding(8)
                        .frame(
                            minWidth: geo.size.width,
                            alignment: keysOverflow(in: geo.size.width) ? .leading : .center
                        )
                }
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            }
            .padding(.horizontal, 6)
            .frame(height: 58)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(.white.opacity(0.04))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(.white.opacity(0.08), lineWidth: 0.5)
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

            // Info
            VStack(alignment: .leading, spacing: 0) {
                // Group badge
                HStack(spacing: 5) {
                    Image(systemName: iconForGroup(effectiveItem.group))
                        .font(.system(size: 9, weight: .semibold))
                    Text(effectiveItem.group.uppercased())
                        .font(.system(size: 9, weight: .semibold, design: .rounded))
                        .kerning(0.6)
                }
                .foregroundStyle(.white.opacity(0.35))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(.white.opacity(0.06))
                        .overlay(Capsule().stroke(.white.opacity(0.1), lineWidth: 0.5))
                )
                .padding(.bottom, 12)

                // Name
                Text(effectiveItem.name)
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.bottom, 6)

                // Description
                if !effectiveItem.description.isEmpty {
                    Text(effectiveItem.description)
                        .font(.system(size: 12, design: .rounded))
                        .foregroundStyle(.white.opacity(0.4))
                        .lineSpacing(3)
                        .fixedSize(horizontal: false, vertical: true)
                } else {
                    Text("No description available.")
                        .font(.system(size: 12, design: .rounded))
                        .foregroundStyle(.white.opacity(0.2))
                        .italic()
                }

                Spacer()
            }
            .padding(16)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(.white.opacity(0.04))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(.white.opacity(0.08), lineWidth: 0.5)
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
        .frame(width: 200)
    }
    
    private func keysOverflow(in availableWidth: CGFloat) -> Bool {
        let modifiers: [Character] = ["⌘", "⇧", "⌥", "⌃"]
        var remaining = effectiveItem.binding
        var count = 0

        for mod in modifiers {
            if remaining.contains(mod) {
                count += 1
                remaining.removeAll { $0 == mod }
            }
        }
        if !remaining.trimmingCharacters(in: .whitespaces).isEmpty { count += 1 }

        let estimatedWidth = CGFloat(count) * 45 + CGFloat(max(count - 1, 0)) * 5 + 32
        return estimatedWidth > availableWidth
    }
}

extension MenuShortcutScanner {
    static func mockData() -> [String: [ShortcutItem]] {
        [
            "File": [
                ShortcutItem(name: "New Tab",       description: "", binding: "⌘T",  group: "File"),
                ShortcutItem(name: "New Window",    description: "", binding: "⌘N",  group: "File"),
                ShortcutItem(name: "Close Tab",     description: "", binding: "⌘W",  group: "File"),
                ShortcutItem(name: "Close Window",  description: "", binding: "⌘⇧W", group: "File"),
            ],
            "Edit": [
                ShortcutItem(name: "Copy",          description: "", binding: "⌘C",  group: "Edit"),
                ShortcutItem(name: "Paste",         description: "", binding: "⌘V",  group: "Edit"),
                ShortcutItem(name: "Find",          description: "", binding: "⌘F",  group: "Edit"),
            ],
            "View": [
                ShortcutItem(name: "Reload Page",   description: "", binding: "⌘R",  group: "View"),
                ShortcutItem(name: "Zoom In",       description: "", binding: "⌘+",  group: "View"),
                ShortcutItem(name: "Zoom Out",      description: "", binding: "⌘-",  group: "View"),
                ShortcutItem(name: "Actual Size",   description: "", binding: "⌘0",  group: "View"),
            ],
            "Window": [
                ShortcutItem(name: "Settings",      description: "", binding: "⌘,",  group: "Window"),
                ShortcutItem(name: "Minimize",      description: "", binding: "⌘M",  group: "Window"),
            ],
        ]
    }
}

// MARK: - Full Section

struct ShortcutsSection: View {
    @State private var grouped: [String: [ShortcutItem]] = [:]
    @State private var searchText = ""
    @State private var selectedShortcut: ShortcutItem? =  nil
    
    var previewData: [String: [ShortcutItem]]? = nil
    private var sortedGroups: [String] { grouped.keys.sorted() }
    private var filteredGroups: [String] {
        guard !searchText.isEmpty else { return sortedGroups }
        return sortedGroups.filter { group in
            (grouped[group] ?? []).contains {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.binding.contains(searchText)
            }
        }
    }

    func filteredItems(for group: String) -> [ShortcutItem] {
        let items = grouped[group] ?? []
        guard !searchText.isEmpty else { return items }
        return items.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.binding.contains(searchText)
        }
    }

    var body: some View {
        HStack {
            VStack(spacing: 0) {
                // Search bar
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.white.opacity(0.3))
                    TextField("Search shortcuts...", text: $searchText)
                        .textFieldStyle(.plain)
                        .font(.system(size: 13, design: .rounded))
                        .foregroundStyle(.white)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(.white.opacity(0.05))
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .fill(.white.opacity(0.07))
                        .frame(height: 0.5)
                }
                
                // List
                ScrollView(.vertical) {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(filteredGroups, id: \.self) { group in
                            let items = filteredItems(for: group)
                            if !items.isEmpty {
                                ShortcutGroupHeader(title: group, icon: iconForGroup(group))
                                
                                VStack(spacing: 0) {
                                    ForEach(items) { item in
                                        ShortcutRow(item: item, selectedShortcut: $selectedShortcut)
                                        
                                        if item.id != items.last?.id {
                                            Rectangle()
                                                .fill(.white.opacity(0.05))
                                                .frame(height: 0.5)
                                                .padding(.horizontal, 16)
                                        }
                                    }
                                }
                            }
                        }
                        
                        Spacer(minLength: 20)
                    }
                }
            }
            .frame(height: 400)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(.white.opacity(0.04))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(.white.opacity(0.08), lineWidth: 0.5)
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .onAppear {
                if let previewData {
                    grouped = previewData
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        grouped = MenuShortcutScanner.scan()
                    }
                }
            }
            
            ShortcutInfo(item: selectedShortcut)
        }
            
    }
}

#Preview {
    ShortcutsPreview()
}

private struct ShortcutsPreview: View {
    
    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .fill(.black.opacity(0.5))
                .overlay(Color.white.opacity(0.03))
                .ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    ShortcutsSection(previewData: MenuShortcutScanner.mockData())
                }
                .padding(24)
                .frame(maxWidth: 680, alignment: .leading)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(minWidth: 860, minHeight: 640)
        .background(.ultraThinMaterial)
    }
}

