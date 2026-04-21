//
//  DeviceList.swift
//  NoirBrowser
//
//  Created by Andre Mossi on 4/1/26.
//

import AppKit
import Foundation
import SwiftUI

private func getDeviceID() -> String {
    if let id = UserDefaults.standard.string(forKey: "device_id") {
        return id
    } else {
        let newID = UUID().uuidString
        UserDefaults.standard.set(newID, forKey: "device_id")
        return newID
    }
}

private func getDeviceName() -> String {
    Host.current().localizedName ?? "Unknown"
}

func getMacDeviceTypeId() -> String {
    let model = Host.current().localizedName ?? ""

    if model.contains("MacBook") {
        return "macbook"
    } else {
        return "mac"
    }
}

func getDeviceTypeId() -> String {
    #if os(macOS)
        return getMacDeviceTypeId()

    #elseif os(iOS)
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return "iphone"
        case .pad:
            return "ipad"
        case .tv:
            return "appletv"
        case .carPlay:
            return "carplay"
        default:
            return "unknown"
        }

    #elseif os(tvOS)
        return "appletv"

    #elseif os(watchOS)
        return "watch"

    #else
        return "unknown"
    #endif
}

func currentDevice() -> StreamingDevice {
    StreamingDevice(
        id: UUID(uuidString: getDeviceID())?.uuidString ?? UUID().uuidString,
        name: getDeviceName(),
        subtitle: "This device",
        deviceId: getDeviceTypeId(),
        isOnline: true
    )
}

func getDeviceIcon(deviceId: String?) -> String {
    if deviceId == nil {
        return "questionmark"
    }

    let deviceTypes: [DeviceTypes] = DeviceTypes.list()

    let deviceType = deviceTypes.first(where: { $0.id == deviceId })

    return deviceType?.icon ?? "questionmark"
}

func registerDevice(devices: inout [StreamingDevice]) {
    let currentId = getDeviceID()

    if !devices.contains(where: { $0.id == currentId }) {
        let newDevice = StreamingDevice(
            id: currentDevice().id,
            name: currentDevice().name,
            subtitle: currentDevice().subtitle,
            deviceId: currentDevice().deviceId,
            isOnline: currentDevice().isOnline
        )

        devices.append(newDevice)
    }
}

struct DeviceList: View {
    @Binding var selectedDeviceID: StreamingDevice.ID?
    @Binding var devices: [StreamingDevice]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Devices")
                    .font(.system(.title3, design: .rounded, weight: .semibold))
                    .foregroundStyle(.primary)

                Spacer()

                Button("Refresh") {
                    // scan
                }
                .font(.system(.caption, design: .rounded, weight: .medium))
                .foregroundStyle(.secondary)
            }
            .padding(.bottom, 8)

            LazyVStack(spacing: 8) {
                ForEach(devices) { device in
                    DeviceRow(device: device, selectedDeviceID: $selectedDeviceID)
                        .padding(.vertical, 2)
                }
            }
        }
        .padding(24)
    }
}

struct DeviceRow: View {
    let device: StreamingDevice
    @Binding var selectedDeviceID: StreamingDevice.ID?
    @State private var isHovering = false

    var body: some View {
        let controlOnly = DeviceTypes.list().first(where: { $0.id == device.deviceId })?
            .controlOnly ?? false
        Button {
            withAnimation(.spring(response: 0.25)) {
                selectedDeviceID = device.id
            }
        } label: {
            HStack(spacing: 16) {
                Image(systemName: getDeviceIcon(deviceId: device.deviceId))
                    .font(.system(size: 16, weight: .medium))
                    .frame(width: 36, height: 36)
                    .background(.white.opacity(isHovering ? 0.12 : 0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text(device.name)
                            .font(.system(.body, design: .rounded, weight: .medium))

                        if device.id == currentDevice().id {
                            Text("Current")
                                .font(.caption2)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(.cyan.opacity(0.18))
                                .foregroundStyle(.cyan)
                                .clipShape(Capsule())
                        }
                    }

                    Text(device.subtitle)
                        .font(.system(.caption2, design: .rounded))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                if selectedDeviceID == device.id {
                    Image(systemName: "checkmark.circle")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(.blue)
                        .scaleEffect(isHovering ? 1.1 : 1.0)
                }
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 8)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.white.opacity(selectedDeviceID == device.id ? 0.15 : 0.01))
            )
        }
        .buttonStyle(.plain)
        .disabled(controlOnly)
        .onHover { isHovering = $0 }
        .scaleEffect(isHovering ? 1.01 : 1.0)
    }
}

#Preview {
    DeviceList(
        selectedDeviceID: .constant(nil),
        devices: .constant(StreamingDevice.devicesExample())
    )
}
