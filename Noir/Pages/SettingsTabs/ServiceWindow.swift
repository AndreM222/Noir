//
//  ServiceWindow.swift
//  NoirBrowser
//
//  Created by Andre Mossi on 4/11/26.
//

import SwiftUI

private struct ServicesCard<Content: View>: View {
    let service: Service
    let content: () -> Content
    @State private var enabled = false

    init(service: Service, @ViewBuilder content: @escaping () -> Content) {
        self.service = service
        self.content = content
        _enabled = State(initialValue: service.isActive)
    }

    var body: some View {
        let accent = Color(hex: service.brandColor)
        
        VStack(alignment: .leading, spacing: 18) {

            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(accent.opacity(0.15))
                    
                    Image(systemName: "play.rectangle.fill")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(accent)
                }
                .frame(width: 32, height: 32)

                VStack(alignment: .leading, spacing: 2) {
                    Text(service.title)
                        .font(.system(.headline, design: .rounded, weight: .semibold))
                        .foregroundStyle(.white)

                    Text("Streaming Service")
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.white.opacity(0.4))
                }

                Spacer()
                
                Toggle("Service", isOn: $enabled)
                    .toggleStyle(SwitchToggleStyle())
                    .labelsHidden()
            }

            content()
                .opacity(enabled ? 1 : 0.6)
        }
        .padding(20)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(.ultraThinMaterial)

                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(accent.opacity(enabled ? 0.06 : 0.006))

                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(.white.opacity(0.08), lineWidth: 1)

                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(accent.opacity(0.18), lineWidth: 0.6)
            }
        )
    }
}

struct ServicesSection: View {
    let account: Account
    let profiles: [Profile]
    let services: [Service] = Service.examples()

    var body: some View {
        
        ForEach(services) { service in
            let filteredProfiles = profiles.filter { $0.service == service.id }
            
            ServicesCard(service: service) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        if filteredProfiles.isEmpty {
                            Text("No profiles yet added")
                                .font(.headline)
                                .foregroundStyle(.tertiary)
                        } else {
                            ForEach(filteredProfiles) { profile in
                                ProfileCard(
                                    config: AvatarConfig(
                                        color: profile.color,
                                        icon: profile.icon,
                                        name: profile.name,
                                        size: 60,
                                        radius: 18
                                    )
                                )
                                .padding(2)
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ServicePreview()
}

private struct ServicePreview: View {
    @State private var account: Account?
    @State private var profiles: [Profile]

    init() {
        let accountExample = Account.examples()
        let profilesExample = Profile.examples(account: accountExample)
        
        _account = State(initialValue: accountExample[0])
        _profiles = State(initialValue: profilesExample.filter { $0.account == accountExample.first?.id })
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .fill(.black.opacity(0.5))
                .overlay(Color.white.opacity(0.03))
                .ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    ServicesSection(account: account!, profiles: profiles)
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

