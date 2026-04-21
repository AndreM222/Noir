//
//  CloseWindow.swift
//  NoirBrowser
//
//  Created by Andre Mossi on 4/10/26.
//

import AppKit
import SwiftUI

struct CloseView: View {
    @Binding var isPresented: Bool

    var body: some View {
        ZStack {
            Color.black.opacity(0.45)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                VStack(spacing: 14) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        .white.opacity(0.10),
                                        .white.opacity(0.04)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .stroke(.white.opacity(0.08), lineWidth: 1)
                            )

                        Image(systemName: "power")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                    .frame(width: 40, height: 40)

                    VStack(spacing: 6) {
                        Text("Quit Noir Browser?")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)

                        Text("Your windows and tabs will stay where you left them.")
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundStyle(.white.opacity(0.62))
                            .frame(maxWidth: 280)
                    }
                }

                HStack(spacing: 50) {
                    Button {
                        NSApp.keyWindow?.close()
                    } label: {
                        Text("Always Quit")
                            .font(.system(.subheadline, design: .rounded, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .frame(height: 41)
                            .contentShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }
                    .buttonStyle(.plain)
                    .frame(width: 100)
                    .foregroundStyle(.white.opacity(0.92))
                    .background(.white.opacity(0.06))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(.white.opacity(0.08), lineWidth: 1)
                    )

                    HStack(spacing: 12) {
                        Button {
                            NSApplication.shared.terminate(nil)
                        } label: {
                            HStack(spacing: 8) {
                                Text("Quit")
                                Image(systemName: "return")
                            }
                            .font(.system(.subheadline, design: .rounded, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .frame(height: 41)
                            .contentShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        }
                        .keyboardShortcut(.defaultAction)
                        .buttonStyle(.plain)
                        .frame(width: 100)
                        .foregroundStyle(.white)
                        .background(
                            LinearGradient(
                                colors: [.red.opacity(0.95), .red.opacity(0.75)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .shadow(color: .red.opacity(0.22), radius: 7, y: 10)

                        Button {
                            isPresented = false
                        } label: {
                            HStack(spacing: 8) {
                                Text("Cancel")
                                Image(systemName: "escape")
                            }
                            .font(.system(.subheadline, design: .rounded, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .frame(height: 41)
                            .contentShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        }
                        .keyboardShortcut(.cancelAction)
                        .buttonStyle(.plain)
                        .frame(width: 100)
                        .foregroundStyle(.white.opacity(0.92))
                        .background(.white.opacity(0.06))
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(.white.opacity(0.08), lineWidth: 1)
                        )
                    }
                }
            }
            .padding(22)
            .background(
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .stroke(.white.opacity(0.10), lineWidth: 1)
                    )
            )
            .shadow(color: .black.opacity(0.45), radius: 40, y: 20)
        }
    }
}

#Preview {
    @Previewable @State var presentMockup = true
    CloseView(isPresented: $presentMockup)
}
