//
//  AccountWindow.swift
//  NoirBrowser
//
//  Created by Andre Mossi on 4/11/26.
//

import SwiftUI

struct AccountSection: View {
    var account: Account

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            UserCard(
                config: AvatarConfig(
                    color: account.color,
                    icon: account.icon,
                    name: account.name,
                    size: 90,
                    radius: 18
                ), subtitle: account.subscription
            )
            VStack(spacing: 14) {
                // Profile
                HStack(alignment: .top, spacing: 14) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(account.name)
                            .font(.system(.title3, design: .rounded, weight: .semibold))
                            .foregroundStyle(.white)
                        Text(account.subscription + " · Signed in")
                            .font(.system(size: 12))
                            .foregroundStyle(.white.opacity(0.45))
                    }

                    Spacer()

                    Button("Sign out") {}
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.white.opacity(0.5))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.white.opacity(0.07))
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .stroke(.white.opacity(0.08), lineWidth: 0.5)
                        )
                        .buttonStyle(.plain)
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

                // Version card
                SectionCard(title: "Version", icon: "number") {
                    HStack {
                        Text("Noir Browser")
                            .font(.system(.subheadline, design: .rounded, weight: .medium))
                            .foregroundStyle(.white)
                        Spacer()
                        Text("1.0.0")
                            .font(.system(.caption, design: .monospaced))
                            .foregroundStyle(.white.opacity(0.4))
                    }
                }
            }
        }
    }
}

#Preview {
    AccountPreview()
}

private struct AccountPreview: View {
    @State var account: Account?

    init() {
        let accountExample = Account.examples()

        _account = State(initialValue: accountExample[0])
    }

    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .fill(.black.opacity(0.5))
                .overlay(Color.white.opacity(0.03))
                .ignoresSafeArea()
            AccountSection(account: account!)
                .padding(24)
                .frame(maxWidth: 680, alignment: .leading)
        }
        .frame(minWidth: 860, minHeight: 640)
        .background(.ultraThinMaterial)
    }
}
