//
//  Personalization.swift
//  NoirBrowser
//
//  Created by Andre Mossi on 4/1/26.
//

import SwiftUI

enum AvatarColor: String, CaseIterable {
    case zen, fire, ocean, cosmic, neon, slate, gold

    var gradient: Gradient {
        switch self {
        case .zen: Gradient(colors: [.blue, .purple.opacity(0.7)])
        case .fire: Gradient(colors: [.red, .orange.opacity(0.8)])
        case .ocean: Gradient(colors: [.cyan, .blue.opacity(0.8)])
        case .cosmic: Gradient(colors: [.purple, .blue.opacity(0.5)])
        case .neon: Gradient(colors: [.pink, .purple.opacity(0.9)])
        case .slate: Gradient(colors: [
                Color(red: 0.55, green: 0.58, blue: 0.63),
                Color(red: 0.35, green: 0.37, blue: 0.42)
            ])
        case .gold: Gradient(colors: [
                Color(red: 1.0, green: 0.84, blue: 0.41),
                Color(red: 0.83, green: 0.60, blue: 0.18)
            ])
        }
    }
}

struct AvatarIconPicker: View {
    @Binding var selected: AvatarIcon
    private let columns = Array(repeating: GridItem(.fixed(51), spacing: 6), count: 5)

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 6) {
                ForEach(AvatarIcon.allCases, id: \.self) { icon in
                    let isSelected = selected == icon

                    Button {
                        withAnimation(.spring(response: 0.28, dampingFraction: 0.75)) {
                            selected = icon
                        }
                    } label: {
                        Rectangle()
                            .fill(isSelected ? .white.opacity(0.15) : .white.opacity(0.04))
                            .clipShape(
                                .rect(
                                    topLeadingRadius: 4,
                                    bottomLeadingRadius: 20,
                                    bottomTrailingRadius: 4,
                                    topTrailingRadius: 20
                                )
                            )
                            .overlay(
                                Image(systemName: icon.systemName)
                                    .font(.system(
                                        size: 14,
                                        weight: isSelected ? .semibold : .regular
                                    ))
                                    .foregroundStyle(isSelected ? .white : .white.opacity(0.45))
                            )
                    }
                    .buttonStyle(.plain)
                    .contentShape(Rectangle())
                    .frame(width: 51, height: 35)
                }
            }
        }
        .padding(10)
        .frame(maxWidth: 300, maxHeight: 250)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(.white.opacity(0.09), lineWidth: 0.5)
                )
        )
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: .black.opacity(0.3), radius: 12, y: 4)
    }
}

/// Accent picker
struct AccentColorPicker: View {
    @Binding var selected: AvatarColor

    var body: some View {
        HStack(spacing: 8) {
            ForEach(AvatarColor.allCases, id: \.self) { color in
                let isSelected = selected == color

                Button {
                    withAnimation(.spring(response: 0.28, dampingFraction: 0.75)) {
                        selected = color
                    }
                } label: {
                    Rectangle()
                        .fill(
                            isSelected ?
                                LinearGradient(
                                    gradient: color.gradient,
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ) :
                                LinearGradient(
                                    gradient: Gradient(colors: [.gray.opacity(0.2)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                        )
                        .clipShape(
                            .rect(
                                topLeadingRadius: 4,
                                bottomLeadingRadius: 20,
                                bottomTrailingRadius: 4,
                                topTrailingRadius: 20
                            )
                        )
                        .overlay(
                            Circle()
                                .fill(LinearGradient(
                                    gradient: color.gradient,
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .opacity(isSelected ? 0 : 1)
                                .frame(width: 24, height: 24)
                        )
                }
                .buttonStyle(.plain)
                .frame(maxWidth: 51, maxHeight: 35)
            }
        }
    }
}

enum AvatarIcon: String, CaseIterable {
    /// Nature
    case leaf, flame, drop, snowflake, sun, moon, cloud, wind, tornado, tree
    /// Space
    case sparkles, star, moon2, planet, telescope, infinity
    /// Energy
    case bolt, bolt2, waveform, antenna, cpu, atom
    /// Animals
    case bird, fish, tortoise, hare, ant, pawprint
    /// Symbols
    case person, heart, crown, shield, diamond, seal, tag, flag
    /// Objects
    case camera, music, headphones, gamecontroller, paintpalette, books, eye, glasses

    var systemName: String {
        switch self {
        // Nature
        case .leaf: "leaf.fill"
        case .flame: "flame.fill"
        case .drop: "drop.fill"
        case .snowflake: "snowflake"
        case .sun: "sun.max.fill"
        case .moon: "moon.fill"
        case .cloud: "cloud.fill"
        case .wind: "wind"
        case .tornado: "tornado"
        case .tree: "tree.fill"
        // Space
        case .sparkles: "sparkles"
        case .star: "star.fill"
        case .moon2: "moon.stars.fill"
        case .planet: "globe.americas.fill"
        case .telescope: "teletype"
        case .infinity: "infinity"
        // Energy
        case .bolt: "bolt.fill"
        case .bolt2: "bolt.circle.fill"
        case .waveform: "waveform"
        case .antenna: "antenna.radiowaves.left.and.right"
        case .cpu: "cpu.fill"
        case .atom: "atom"
        // Animals
        case .bird: "bird.fill"
        case .fish: "fish.fill"
        case .tortoise: "tortoise.fill"
        case .hare: "hare.fill"
        case .ant: "ant.fill"
        case .pawprint: "pawprint.fill"
        // Symbols
        case .person: "person.fill"
        case .heart: "heart.fill"
        case .crown: "crown.fill"
        case .shield: "shield.fill"
        case .diamond: "diamond.fill"
        case .seal: "seal.fill"
        case .tag: "tag.fill"
        case .flag: "flag.fill"
        // Objects
        case .camera: "camera.fill"
        case .music: "music.note"
        case .headphones: "headphones"
        case .gamecontroller: "gamecontroller.fill"
        case .paintpalette: "paintpalette.fill"
        case .books: "books.vertical.fill"
        case .eye: "eye.fill"
        case .glasses: "glasses"
        }
    }
}

struct AvatarConfig {
    let color: AvatarColor
    let icon: AvatarIcon
    let name: String
    let size: CGFloat
    let radius: CGFloat

    var gradient: Gradient {
        color.gradient
    }

    var iconName: String {
        icon.systemName
    }
}

struct UserAvatar: View {
    let config: AvatarConfig
    @State private var isHovering = false

    private var size: CGFloat {
        config.size
    }

    var body: some View {
        Image(systemName: config.iconName.isEmpty ? "person.fill" : config.iconName)
            .font(.system(size: size * 0.55))
            .foregroundStyle(.linearGradient(
                config.gradient,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ))
            .frame(width: size, height: size)
            .background(
                Circle()
                    .fill(.ultraThinMaterial)
                    .overlay(
                        Circle()
                            .stroke(
                                .linearGradient(
                                    config.gradient,
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.2
                            )
                    )
            )
            .scaleEffect(isHovering ? 1.08 : 1.0)
            .shadow(color: .black.opacity(isHovering ? 0.75 : 0.6), radius: isHovering ? 10 : 4)
            .animation(.spring(response: 0.3), value: isHovering)
            .onHover { isHovering = $0 }
    }
}

struct ProfileCard: View {
    let config: AvatarConfig
    @State private var isHovering = false

    private var size: CGFloat {
        config.size
    }

    private var radius: CGFloat {
        config.radius
    }

    var body: some View {
        VStack(spacing: 12) {
            UserAvatar(config: AvatarConfig(
                color: config.color,
                icon: config.icon,
                name: config.name,
                size: size * 0.7,
                radius: radius
            ))

            VStack(spacing: 4) {
                Text(config.name)
                    .font(.system(.headline, design: .rounded, weight: .semibold))
                    .foregroundStyle(.primary)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 12)
        .frame(width: size * 2, height: size * 3)
        .background(
            RoundedRectangle(cornerRadius: radius, style: .continuous)
                .fill(LinearGradient(
                    gradient: Gradient(colors: [Color.gray.opacity(0.1), Color.black.opacity(0.3)]),
                    startPoint: .topLeading, endPoint: .bottomTrailing
                ))
                .overlay(
                    RoundedRectangle(cornerRadius: radius, style: .continuous)
                        .stroke(
                            .linearGradient(
                                config.gradient,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ).opacity(isHovering ? 0.75 : 0.55),
                            lineWidth: 1
                        )
                )
        )
        .scaleEffect(isHovering ? 1.02 : 1.0)
        .shadow(color: .black.opacity(isHovering ? 0.25 : 0.15), radius: isHovering ? 12 : 6)
        .animation(.spring(response: 0.4), value: isHovering)
        .onHover { isHovering = $0 }
    }
}

struct UserCard: View {
    let config: AvatarConfig
    let subtitle: String
    @State private var isHovering = false

    private var size: CGFloat {
        config.size
    }

    private var radius: CGFloat {
        config.radius
    }

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
                            .stroke(
                                .linearGradient(
                                    config.gradient,
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ).opacity(isHovering ? 0.75 : 0.55),
                                lineWidth: 1
                            )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
            }
            .padding(.bottom, -10)
            .frame(maxWidth: .infinity, alignment: .trailing)

            UserAvatar(config: AvatarConfig(
                color: config.color,
                icon: config.icon,
                name: config.name,
                size: size * 0.7,
                radius: radius
            ))

            VStack(spacing: 4) {
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
                    gradient: Gradient(colors: [Color.gray.opacity(0.1), Color.black.opacity(0.3)]),
                    startPoint: .topLeading, endPoint: .bottomTrailing
                ))
                .overlay(
                    RoundedRectangle(cornerRadius: radius, style: .continuous)
                        .stroke(
                            .linearGradient(
                                config.gradient,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ).opacity(isHovering ? 0.75 : 0.55),
                            lineWidth: 1
                        )
                )
        )
        .scaleEffect(isHovering ? 1.02 : 1.0)
        .shadow(color: .black.opacity(isHovering ? 0.25 : 0.15), radius: isHovering ? 12 : 6)
        .animation(.spring(response: 0.4), value: isHovering)
        .onHover { isHovering = $0 }
    }
}

#Preview {
    @Previewable @State var selectedColor: AvatarColor = .cosmic
    @Previewable @State var selectedIcon: AvatarIcon = .moon

    VStack(spacing: 16) {
        AccentColorPicker(selected: $selectedColor)

        HStack(spacing: 16) {
            UserAvatar(
                config: AvatarConfig(
                    color: .neon,
                    icon: .bolt,
                    name: "Andre",
                    size: 48,
                    radius: 4
                )
            )
            .padding()
            UserCard(
                config: AvatarConfig(
                    color: .neon,
                    icon: .bolt,
                    name: "Andre",
                    size: 64,
                    radius: 9
                ),
                subtitle: "Premium User"
            )

            ProfileCard(
                config: AvatarConfig(
                    color: .neon,
                    icon: .bolt,
                    name: "Andre",
                    size: 64,
                    radius: 9
                )
            )
        }

        AvatarIconPicker(selected: $selectedIcon)
    }
    .frame(height: 500)
    .padding(16)
}
