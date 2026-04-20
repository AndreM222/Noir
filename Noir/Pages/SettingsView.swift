//
//  SettingsView.swift
//  NoirBrowser
//
//  Created by Andre Mossi on 4/10/26.
//

import SwiftUI

struct SectionCard<Content: View>: View {
    let title: String
    let icon: String
    let content: () -> Content

    init(title: String, icon: String, @ViewBuilder content: @escaping () -> Content) {
        self.title   = title
        self.icon    = icon
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.5))
                Text(title)
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.7))
                Spacer()
            }

            content()
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(.white.opacity(0.08), lineWidth: 0.5)
                )
        )
    }
}

enum SettingsSection: String, CaseIterable, Identifiable {
    case account      = "account"
    case shortcuts    = "shortcuts"
    case services     = "services"
    case general      = "general"
    
    var id: Self { self }
    
    var tabInfo: TabBarSection {
        switch self {
        case .account:
            return TabBarSection(
                id: "account",
                title: "Account",
                icon: "person.text.rectangle"
            )
        case .shortcuts:
            return TabBarSection(
                id: "shortcuts",
                title: "Shortcuts",
                icon: "command"
            )
        case .services:
            return TabBarSection(
                id: "services",
                title: "Services",
                icon: "person.crop.circle"
            )
        case .general:
            return TabBarSection(
                id: "general",
                title: "General",
                icon: "gear"
            )
        }
    }

    var subtitle: String {
        switch self {
        case .account:       return "Account and app preferences."
        case .shortcuts:     return "Remap commands and speed up browsing."
        case .services:      return "Manage identity and account preferences."
        case .general:       return "Custom experience for browsing"
        }
    }
}

extension SettingsView {
    fileprivate func getProfile() -> Account {
        if let account {
            return Account(
                name: account.name,
                subscription: account.subscription,
                creationDate: account.creationDate,
                color: account.color,
                icon: account.icon
            )
        }
        
        return Account(
            name: "Unknown",
            subscription: "Trial",
            creationDate: Date(),
            color: .fire,
            icon: .flame
        )
    }
}

struct SettingsView: View {
    @State private var selection: SettingsSection = .account
    
    private var tabSelection: Binding<TabBarSection> {
        Binding<TabBarSection>(
            get: { selection.tabInfo },
            set: { newValue in
                if let newSection = SettingsSection.allCases.first(where: { $0.tabInfo.id == newValue.id }) {
                    selection = newSection
                }
            }
        )
    }
    
    @State private var browserTheme = BrowserTheme()
    @Binding var account: Account?
    @Binding var profiles: [Profile]
    
    private let tabs: [TabBarSection] = SettingsSection.allCases.map(\.tabInfo)

    var body: some View {
        ZStack(alignment: .top) {
            Rectangle()
                .fill(.black.opacity(0.5))
                .overlay(Color.white.opacity(0.03))
                .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    SettingsTabBar(selection: tabSelection, tabs: tabs)
                }
                .padding(.top, 20)
                .padding(.bottom, 18)
                .padding(.horizontal, 24)

                ScrollView {
                    VStack(alignment: .leading, spacing: 22) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(selection.tabInfo.title)
                                .font(.system(.title2, design: .rounded, weight: .bold))
                                .foregroundStyle(.white)

                            Text(selection.subtitle)
                                .font(.system(.subheadline, design: .rounded))
                                .foregroundStyle(.white.opacity(0.4))
                        }
                        .padding(.top, 4)

                        // Section content
                        switch selection {
                        case .account:
                            AccountSection(account: getProfile())
                        case .shortcuts:
                            ShortcutsSection()
                        case .services:
                            ServicesSection(account: account!, profiles: profiles)
                        case .general:
                            GeneralSection(browserTheme: $browserTheme)
                        }
                    }
                    .padding(24)
                    .frame(maxWidth: 680, alignment: .leading)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .background(.ultraThinMaterial)
        .frame(minWidth: 860, minHeight: 640)
    }
}

#Preview {
    SettingsPreview()
}

private struct SettingsPreview: View {
    @State private var account: Account?
    @State private var profiles: [Profile]

    init() {
        let accountExample = Account.examples()
        let profilesExample = Profile.examples(account: accountExample)
        
        _account = State(initialValue: accountExample[0])
        _profiles = State(initialValue: profilesExample.filter { $0.account == accountExample.first?.id })
    }

    var body: some View {
        SettingsView(account: $account, profiles: $profiles)
    }
}

