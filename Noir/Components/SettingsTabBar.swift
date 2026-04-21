//
//  SettingsTabBar.swift
//  NoirBrowser
//
//  Created by Andre Mossi on 4/11/26.
//

import SwiftUI

struct TabBarSection: Identifiable, Hashable {
    let id: String
    var title: String
    var icon: String?

    static func example() -> [TabBarSection] {
        [
            TabBarSection(
                id: "account",
                title: "Account",
                icon: "person.text.rectangle"
            ),
            TabBarSection(
                id: "shortcuts",
                title: "Shortcuts",
                icon: "command"
            ),
            TabBarSection(
                id: "services",
                title: "Services",
                icon: "person.crop.circle"
            ),
            TabBarSection(
                id: "general",
                title: "General",
                icon: "gear"
            )
        ]
    }
}

struct SettingsTabBar: View {
    @Binding var selection: TabBarSection
    let tabs: [TabBarSection]
    @Namespace private var tabNS

    var body: some View {
        HStack(spacing: 4) {
            ForEach(tabs) { section in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        selection = section
                    }
                } label: {
                    let isSelected = selection.id == section.id

                    HStack(spacing: 7) {
                        if let iconName = section.icon {
                            Image(systemName: iconName)
                                .font(.system(size: 13, weight: .medium))
                        }
                        Text(section.title)
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .foregroundStyle(isSelected ? Color.white : Color.white.opacity(0.5))
                    .contentShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .background(
                        ZStack {
                            if isSelected {
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(Color.white.opacity(0.12))
                                    .matchedGeometryEffect(id: "tab", in: tabNS)
                            }
                        }
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(5)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(.white.opacity(0.06))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(.white.opacity(0.09), lineWidth: 0.5)
                )
        )
    }
}

#Preview {
    BarPreview()
}

private struct BarPreview: View {
    @State private var selection: TabBarSection = .example().first!
    private let tabs: [TabBarSection] = TabBarSection.example()

    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .fill(.black.opacity(0.5))
                .overlay(Color.white.opacity(0.03))
                .ignoresSafeArea()
            SettingsTabBar(selection: $selection, tabs: tabs)
        }
        .frame(minWidth: 460, minHeight: 340)
        .background(.ultraThinMaterial)
    }
}
