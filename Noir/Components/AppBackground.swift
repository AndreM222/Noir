//
//  AppBackground.swift
//  NoirBrowser
//
//  Created by Andre Mossi on 4/13/26.
//

import SwiftUI

struct GrainView: View {
    var intensity: Double

    var body: some View {
        Canvas { context, size in
            for _ in 0 ..< Int(size.width * size.height / 3) {
                let x = CGFloat.random(in: 0 ..< size.width)
                let y = CGFloat.random(in: 0 ..< size.height)
                let opacity = Double.random(in: 0.03 ... 0.12) * intensity
                context.fill(
                    Path(CGRect(x: x, y: y, width: 1, height: 1)),
                    with: .color(.white.opacity(opacity))
                )
            }
        }
        .allowsHitTesting(false)
    }
}

struct SidebarBackground: View {
    var transparency: Double = 0.5
    var grain: Double = 0.0

    private var overlayOpacity: Double {
        0.55 - (transparency * 0.45)
    }

    var body: some View {
        ZStack {
            VisualEffectBackground(material: .sidebar, blendingMode: .behindWindow)
            Color.black.opacity(overlayOpacity)
            GrainView(intensity: grain)
        }
        .overlay(alignment: .trailing) {
            Rectangle()
                .fill(.white.opacity(0.07))
                .frame(width: 0.5)
        }
        .ignoresSafeArea()
    }
}

struct VisualEffectBackground: NSViewRepresentable {
    var material: NSVisualEffectView.Material = .hudWindow
    var blendingMode: NSVisualEffectView.BlendingMode = .behindWindow

    func makeNSView(context _: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = .active
        return view
    }

    func updateNSView(_ nsView: NSVisualEffectView, context _: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
    }
}

struct CustomBackground: View {
    var transparency: Double = 0.0
    var grain: Double = 0.0

    private var overlayOpacity: Double {
        0.7 - (transparency * 0.65)
    }

    var body: some View {
        ZStack {
            VisualEffectBackground()
            Color.black.opacity(overlayOpacity)
            GrainView(intensity: grain)
        }
        .ignoresSafeArea()
    }
}
