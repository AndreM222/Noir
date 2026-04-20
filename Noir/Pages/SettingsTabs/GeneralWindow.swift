//
//  GeneralWindow.swift
//  NoirBrowser
//
//  Created by Andre Mossi on 4/11/26.
//

import SwiftUI


enum BrowserThemeMode: String, CaseIterable, Identifiable {
    case light = "light"
    case dark  = "dark"
    case auto  = "auto"

    var id: Self { self }
    
    var tabInfo: TabBarSection {
        switch self {
        case .light:
            return TabBarSection(
                id: "light",
                title: "Light",
                icon: "sun.max"
            )
        case .dark:
            return TabBarSection(
                id: "dark",
                title: "Dark",
                icon: "moon.stars"
            )
        case .auto:
            return TabBarSection(
                id: "auto",
                title: "Auto",
                icon: "slider.horizontal.3"
            )
        }
    }
}

struct BrowserTheme {
    var accentColor: AvatarColor = .neon
    var density: Double = 0.5
}

struct GeneralSection: View {
    @Binding var browserTheme: BrowserTheme
    @State private var selection: BrowserThemeMode = .dark
    private var tabSelection: Binding<TabBarSection> {
        Binding<TabBarSection>(
            get: { selection.tabInfo },
            set: { newValue in
                if let newSection = BrowserThemeMode.allCases.first(where: { $0.tabInfo.id == newValue.id }) {
                    selection = newSection
                }
            }
        )
    }
    private let tabs: [TabBarSection] = BrowserThemeMode.allCases.map(\.tabInfo)


    var body: some View {
        SectionCard(title: "Appearance", icon: "paintbrush") {
            
            VStack(alignment: .leading, spacing: 20) {
                SettingsTabBar(selection: tabSelection, tabs: tabs)
                    .frame(maxWidth: .infinity)

                Divider().overlay(.white.opacity(0.07))

                // Accent
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Accent color")
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundStyle(.white)
                        Text("Used across the interface")
                            .font(.system(size: 11))
                            .foregroundStyle(.white.opacity(0.4))
                    }
                    Spacer()
                    AccentColorPicker(selected: $browserTheme.accentColor)
                }

                Divider().overlay(.white.opacity(0.07))

                // Density
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Density")
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundStyle(.white)
                        Spacer()
                        Text(browserTheme.density < 0.4 ? "Compact" : browserTheme.density > 0.65 ? "Spacious" : "Default")
                            .font(.system(size: 11))
                            .foregroundStyle(.white.opacity(0.4))
                    }
                    Slider(value: $browserTheme.density, in: 0...1)
                        .tint(.white.opacity(0.6))
                }
            }
        }
    }
}

#Preview {
    GeneralPreview()
}

private struct GeneralPreview: View {
    @State private var browserTheme = BrowserTheme()
    
    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .fill(.black.opacity(0.5))
                .overlay(Color.white.opacity(0.03))
                .ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    GeneralSection(browserTheme: $browserTheme)
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

