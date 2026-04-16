//
//  DeviceBar.swift
//  NoirBrowser
//
//  Created by Andre Mossi on 4/2/26.
//

import SwiftUI
import Combine

struct DeviceButton: View {
    @Binding var open: Bool
    var deviceInfo: StreamingDevice?
    var deviceIcon: String
    
    var body: some View {
        Button {
            withAnimation(.spring(response: 0.38, dampingFraction: 0.84)) {
                open.toggle()
            }
        } label: {
            HStack(spacing: 16) {
                Image(systemName: deviceIcon)
                    .font(.system(size: 16, weight: .medium))
                    .frame(width: 36, height: 36)
                    .background(.white.opacity(0.06))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.white.opacity(0.1), lineWidth: 0.5)
                    )
                
                VStack(alignment: .leading, spacing: 1) {
                    HStack(spacing: 6) {
                        Text(deviceInfo?.name ?? "No Device")
                            .font(.system(.body, design: .rounded, weight: .medium))
                            .foregroundStyle(.primary)
                        
                        if deviceInfo?.id == currentDevice().id {
                            Text("Current")
                                .font(.caption2)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(.cyan.opacity(0.18))
                                .foregroundStyle(.cyan)
                                .clipShape(Capsule())
                        }
                    }
                    
                    Text(deviceInfo?.subtitle ?? "")
                        .font(.system(.caption2, design: .rounded))
                        .foregroundStyle(.secondary.opacity(0.8))
                }
                
                Spacer()
                
                Image(systemName: "chevron.down")
                    .font(.system(size: 12, weight: .medium))
                    .rotationEffect(.degrees(open ? 180 : 0))
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, open ? 20 : 18)
            .contentShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        }
        .buttonStyle(.plain)
        .scaleEffect(open ? 1.02 : 1.0)
        .animation(.spring(response: 0.32, dampingFraction: 0.88), value: open)
    }
}

struct DeviceBar: View {
    @State private var devices: [StreamingDevice]
    @State private var selectedDeviceID: StreamingDevice.ID?
    @State private var openWindow = false
    @State private var dragOffset: CGFloat = 0
    
    init() {
        let initialDevices: [StreamingDevice] = StreamingDevice.devicesExample()
        _devices = State(initialValue: initialDevices)
    }
    
    var body: some View {
        VStack(spacing: openWindow ? 4 : 0) {
            if openWindow {
                DeviceList(selectedDeviceID: $selectedDeviceID, devices: $devices)
                    .offset(y: dragOffset)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                withAnimation(.spring(response: 0.3)) {
                                    dragOffset = value.translation.height
                                }
                            }
                            .onEnded { value in
                                if value.translation.height > 50 {
                                    withAnimation(.spring(response: 0.45)) {
                                        openWindow = false
                                    }
                                } else {
                                    withAnimation(.spring(response: 0.35)) {
                                        dragOffset = 0
                                    }
                                }
                            }
                    )
                    .transition(.move(edge: .top).combined(with: .opacity).combined(with: .scale(scale: 0.95, anchor: .top)))
            }
            
            DeviceButton(
                open: $openWindow,
                deviceInfo: devices.first(where: { $0.id == selectedDeviceID }),
                deviceIcon: "desktopcomputer"
            )
        }
        .frame(width: 380)
        .glassBackgroundEffect()
        .onAppear {
            registerDevice(devices: &devices)
            selectedDeviceID = devices.contains(where: { $0.id == currentDevice().id }) ? currentDevice().id : devices.first?.id
        }
    }
}

extension View {
    func glassBackgroundEffect() -> some View {
        background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .stroke(.white.opacity(0.08), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 8)
                .shadow(color: .white.opacity(0.05), radius: 8, x: 0, y: -2)
        )
    }
}
#Preview {
    DeviceBar()
}
