//
//  SettingsView.swift
//  NoirBrowser
//
//  Created by Andre Mossi on 4/7/26.
//

import SwiftUI

enum SettingsSection: String, CaseIterable, Identifiable {
    case general = "general"
    case shortcuts = "shortcuts"
    case profile = "profile"
    case browserDesign = "browserDesign"
    
    var id: Self { self }
    
    var title: String {
        switch self {
        case .general: return "General"
        case .shortcuts: return "Shortcuts"
        case .profile: return "Profile"
        case .browserDesign: return "Theme"
        }
    }
    
    var subtitle: String {
        switch self {
        case .general: return "Account and app preferences."
        case .shortcuts: return "Remap commands and speed up browsing."
        case .profile: return "Manage identity and account preferences."
        case .browserDesign: return "Tune density, accent, and visual feel."
        }
    }
    
    var icon: String {
        switch self {
        case .general: return "gear"
        case .shortcuts: return "command"
        case .profile: return "person.crop.circle"
        case .browserDesign: return "paintbrush"
        }
    }
}

struct ShortcutRow: View {
    @Binding var item: ShortcutItem

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .foregroundStyle(.white)
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                Text(item.description)
                    .foregroundStyle(.white.opacity(0.55))
                    .font(.caption)
            }

            Spacer()

            Text(item.binding)
                .font(.system(.caption, design: .monospaced, weight: .semibold))
                .foregroundStyle(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(.white.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
        .padding(12)
        .background(.white.opacity(0.04))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}


struct ShortcutsSection: View {
    @Binding var shortcutItems: [ShortcutItem]

    var body: some View {
        SectionCard(title: "Keyboard Shortcuts", icon: "keyboard") {
            VStack(spacing: 10) {
                ForEach($shortcutItems) { $item in
                    ShortcutRow(item: $item)
                }
            }
        }
    }
}

struct ShortcutItem: Identifiable {
    let id = UUID()
    var name: String
    var description: String
    var binding: String
}

enum BrowserThemeMode: String, CaseIterable, Identifiable {
    case light = "light"
    case dark = "dark"
    case auto = "auto"
    
    var id: Self { self }
    
    var title: String {
        self.rawValue.capitalized
    }
}

struct BrowserTheme {
    var mode: BrowserThemeMode = .dark
    var accent: Color = .purple
    var density: Double = 0.5
}

struct SettingsView: View {
    @State private var selection: SettingsSection = .general
    @State private var profileName: String = "Andre Mossi"
    @State private var browserTheme = BrowserTheme()
    
    @State private var shortcutItems: [ShortcutItem] = [
        ShortcutItem(name: "New Tab", description: "Create new tab", binding: "⌘ T"),
        ShortcutItem(name: "Close Tab", description: "Close current tab", binding: "⌘ W"),
        ShortcutItem(name: "Switch Tabs", description: "Navigate tabs", binding: "⌘ [1-9]"),
        ShortcutItem(name: "Search", description: "Quick search", binding: "⌘ K")
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Horizontal tabs
            tabBar
            
            // Content
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(minWidth: 900, minHeight: 700)
    }
    
    private var tabBar: some View {
            HStack() {
                ForEach(SettingsSection.allCases) { section in
                    Button {
                        withAnimation(.spring(response: 0.28, dampingFraction: 0.86)) {
                            selection = section
                        }
                    } label: {
                        VStack(spacing: 6) {
                            Image(systemName: section.icon)
                                .font(.system(size: 17, weight: .semibold))
                                .frame(width: 44, height: 44)
                                .background(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .fill(selection == section ? .white.opacity(0.12) : .white.opacity(0.06))
                                )
                            
                            Text(section.title)
                                .font(.system(.caption, design: .rounded, weight: .semibold))
                                .foregroundStyle(selection == section ? .white : .white.opacity(0.65))
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 24)
    }
    
    struct ProfileSection: View {
        @Binding var profileName: String

        var body: some View {
            SectionCard(title: "Profile", icon: "person.crop.circle") {
                VStack(alignment: .leading, spacing: 14) {
                    HStack(spacing: 14) {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [.purple, .blue],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 56, height: 56)
                            .overlay(
                                Text(profileName.prefix(1).uppercased())
                                    .foregroundStyle(.white)
                                    .font(.system(.title3, design: .rounded, weight: .bold))
                            )

                        VStack(alignment: .leading, spacing: 4) {
                            Text(profileName)
                                .foregroundStyle(.white)
                                .font(.system(.headline, design: .rounded, weight: .semibold))
                            Text("Signed in profile")
                                .foregroundStyle(.white.opacity(0.55))
                                .font(.caption)
                        }
                    }

                    TextField("Profile name", text: $profileName)
                        .textFieldStyle(.plain)
                        .padding(12)
                        .background(.white.opacity(0.06))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .foregroundStyle(.white)
                }
            }
        }
    }
    
    struct BrowserDesignSection: View {
        @Binding var browserTheme: BrowserTheme

        var body: some View {
            SectionCard(title: "Theme", icon: "paintbrush") {
                VStack(alignment: .leading, spacing: 16) {
                    Picker("Theme", selection: $browserTheme.mode) {
                        ForEach(BrowserThemeMode.allCases) { mode in
                            Text(mode.title).tag(mode)
                        }
                    }
                    .pickerStyle(.segmented)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Accent")
                            .foregroundStyle(.white.opacity(0.75))
                            .font(.caption.weight(.semibold))

                        ColorPicker("", selection: Binding(
                            get: { browserTheme.accent },
                            set: { browserTheme.accent = $0 }
                        ))
                        .labelsHidden()
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Density")
                            .foregroundStyle(.white.opacity(0.75))
                            .font(.caption.weight(.semibold))

                        Slider(value: $browserTheme.density, in: 0...1)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header

                switch selection {
                case .general:
                    GeneralSection(profileName: profileName)
                case .shortcuts:
                    ShortcutsSection(shortcutItems: $shortcutItems)
                case .profile:
                    ProfileSection(profileName: $profileName)
                case .browserDesign:
                    BrowserDesignSection(browserTheme: $browserTheme)
                }
            }
            .padding(24)
            .frame(maxWidth: 760, alignment: .leading)
        }
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(selection.title)
                .font(.system(.largeTitle, design: .rounded, weight: .bold))
                .foregroundStyle(.white)

            Text(selection.subtitle)
                .font(.system(.subheadline, design: .rounded))
                .foregroundStyle(.white.opacity(0.58))
        }
    }
}

struct GeneralSection: View {
    let profileName: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            UserCard(
                config: AvatarConfig(
                    personality: .neon,
                    name: "Andre Mossi",
                    size: 90,
                    radius: 18
                ), subtitle: "premium"
            )
            VStack {
                SectionCard(title: "Account", icon: "person.circle") {
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 9) {
                            Text(profileName)
                                .font(.system(.title2, design: .rounded, weight: .bold))
                                .foregroundStyle(.white)

                            Button("Sign out") {
                                // Sign out action
                            }
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.white.opacity(0.7))
                        }
                    }
                }
                SectionCard(title: "Version", icon: "number") {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Noir Browser 1.0.0")
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.white)
                    }
                }
            }
        }
    }
}

// Keep all other structs (SectionCard, ShortcutsSection, etc.) exactly the same...

struct SectionCard<Content: View>: View {
    let title: String
    let icon: String
    let content: () -> Content

    init(title: String, icon: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.icon = icon
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                Text(title)
                    .font(.system(.headline, design: .rounded, weight: .semibold))
                Spacer()
            }
            .foregroundStyle(.white)

            content()
        }
        .padding(18)
        .background(.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(.white.opacity(0.08), lineWidth: 1)
        )
    }
}

#Preview {
    SettingsView()
}
