//
//  User.swift
//  NoirBrowser
//
//  Created by Andre Mossi on 4/1/26.
//

import SwiftUI

enum Personality: String, CaseIterable {
    case zen, fire, ocean, cosmic, neon
    
    var gradient: Gradient {
        switch self {
        case .zen: Gradient(colors: [.blue, .purple.opacity(0.7)])
        case .fire: Gradient(colors: [.red, .orange.opacity(0.8)])
        case .ocean: Gradient(colors: [.cyan, .blue.opacity(0.8)])
        case .cosmic: Gradient(colors: [.purple, .pink.opacity(0.9)])
        case .neon: Gradient(colors: [.pink, .purple.opacity(0.9)])
        }
    }
    
    var icon: String {
        switch self {
        case .zen: "leaf.fill" ; case .fire: "flame.fill"
        case .ocean: "drop.fill" ; case .cosmic: "sparkles"
        case .neon: "bolt.fill"
        }
    }
}

struct AvatarConfig {
    let personality: Personality
    let name: String
    let size: CGFloat
    let radius: CGFloat

    var gradient: Gradient { personality.gradient }
    var iconName: String { personality.icon }
}

struct UserAvatar: View {
    let config: AvatarConfig
    @State private var isHovering = false
    
    private var size: CGFloat { config.size }
    
    var body: some View {
        Image(systemName: config.iconName.isEmpty ? "person.fill" : config.iconName)
            .font(.system(size: size * 0.55))
            .foregroundStyle(.linearGradient(config.gradient, startPoint: .topLeading, endPoint: .bottomTrailing))
            .frame(width: size, height: size)
            .background(
                Circle()
                    .fill(.ultraThinMaterial)
                    .overlay(
                        Circle()
                            .stroke(.linearGradient(config.gradient, startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1.2)
                    )
            )
            .scaleEffect(isHovering ? 1.08 : 1.0)
            .shadow(color: .black.opacity(isHovering ? 0.75 : 0.6), radius: isHovering ? 10 : 4)
            .animation(.spring(response: 0.3), value: isHovering)
            .onHover { isHovering = $0 }
            .accessibilityLabel("\(config.name) (\(config.personality.rawValue))")
    }
}

struct UserCard: View {
    let config: AvatarConfig
    let subtitle: String
    @State private var isHovering = false
    
    private var size: CGFloat { config.size }
    private var radius: CGFloat { config.radius }

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 0) {
                Text("NOIR")
                    .padding(.vertical, 2)
                    .padding(.horizontal, 5)
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .background(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: radius, style: .continuous)
                            .stroke(.linearGradient(config.gradient, startPoint: .topLeading, endPoint: .bottomTrailing).opacity(isHovering ? 0.75 : 0.55), lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
            }
            .padding(.bottom, -10)
            .frame(maxWidth: .infinity, alignment: .trailing)

            UserAvatar(config: AvatarConfig(
                personality: config.personality,
                name: config.name,
                size: size * 0.7,
                radius: radius
            ))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(config.name)
                    .font(.system(.headline, design: .rounded, weight: .semibold))
                    .foregroundStyle(.primary)
                
                HStack(spacing: 4) {
                    Text("Status")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text(subtitle)
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }
                
            }
            
            Spacer()
            HStack(spacing: 4) {
                Image(systemName: "calendar")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text("March 27, 2024")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 12)
        .frame(width: size * 2, height: size * 3)
        .background(
            RoundedRectangle(cornerRadius: radius, style: .continuous)
                .fill(LinearGradient(
                    gradient: Gradient(colors: [Color.gray.opacity(0.1), Color.gray.opacity(0.01)]), startPoint: .topLeading, endPoint: .bottomTrailing
                ))
                .overlay(
                    RoundedRectangle(cornerRadius: radius, style: .continuous)
                        .stroke(.linearGradient(config.gradient, startPoint: .topLeading, endPoint: .bottomTrailing).opacity(isHovering ? 0.75 : 0.55), lineWidth: 1)
                )
        )
        .scaleEffect(isHovering ? 1.02 : 1.0)
        .shadow(color: .black.opacity(isHovering ? 0.25 : 0.15), radius: isHovering ? 12 : 6)
        .animation(.spring(response: 0.4), value: isHovering)
        .onHover { isHovering = $0 }
    }
}

#Preview {
    UserAvatar(
        config: AvatarConfig(
            personality: .neon,
            name: "Andre Mossi",
            size: 48,
            radius: 4
        )
    )
    .padding()
    ForEach(Personality.allCases.prefix(4), id: \.self) { personality in
        UserCard(
            config: AvatarConfig(
                personality: personality,
                name: "Andre Mossi",
                size: 64,
                radius: 9
            ),
            subtitle: "Premium User"
        )
    }
    .padding()
}
