//
//  Devices.swift
//  NoirBrowser
//
//  Created by Andre Mossi on 4/3/26.
//

import Foundation

struct DeviceTypes: Identifiable, Hashable {
    let id: String
    var name: String
    let controlOnly: Bool
    let icon: String

    static func list() -> [DeviceTypes] {
        [
            // Mobile
            DeviceTypes(
                id: "iphone",
                name: "iPhone",
                controlOnly: false,
                icon: "iphone"
            ),
            DeviceTypes(
                id: "ipad",
                name: "iPad",
                controlOnly: false,
                icon: "ipad"
            ),

            // Computers
            DeviceTypes(
                id: "macbook",
                name: "MacBook",
                controlOnly: false,
                icon: "laptopcomputer"
            ),
            DeviceTypes(
                id: "mac",
                name: "Mac",
                controlOnly: false,
                icon: "desktopcomputer"
            ),

            // Wearables
            DeviceTypes(
                id: "watch",
                name: "Apple Watch",
                controlOnly: true,
                icon: "applewatch"
            ),

            // TV / Media
            DeviceTypes(
                id: "appletv",
                name: "Apple TV",
                controlOnly: false,
                icon: "tv"
            ),
            DeviceTypes(
                id: "smarttv",
                name: "Smart TV",
                controlOnly: false,
                icon: "tv.fill"
            ),

            // Audio Devices
            DeviceTypes(
                id: "airpods",
                name: "AirPods",
                controlOnly: true,
                icon: "airpods"
            ),
            DeviceTypes(
                id: "headphones",
                name: "Headphones",
                controlOnly: true,
                icon: "headphones"
            ),
            DeviceTypes(
                id: "speaker",
                name: "Speaker",
                controlOnly: false,
                icon: "hifispeaker.fill"
            ),

            // Car
            DeviceTypes(
                id: "carplay",
                name: "CarPlay",
                controlOnly: false,
                icon: "car.fill"
            ),

            // Web / Browser
            DeviceTypes(
                id: "browser",
                name: "Web Browser",
                controlOnly: false,
                icon: "globe"
            ),

            // Consoles (future expansion)
            DeviceTypes(
                id: "console",
                name: "Game Console",
                controlOnly: false,
                icon: "gamecontroller.fill"
            ),

            // Unknown
            DeviceTypes(
                id: "unknown",
                name: "Unknown Device",
                controlOnly: false,
                icon: "questionmark"
            )
        ]
    }
}

struct StreamingDevice: Identifiable, Hashable {
    var id: String
    var name: String
    let subtitle: String
    let deviceId: String
    var isOnline: Bool

    static func devicesExample() -> [StreamingDevice] {
        [
            StreamingDevice(
                id: UUID().uuidString,
                name: "Living Room TV",
                subtitle: "Apple TV • 12 ms latency",
                deviceId: "appletv",
                isOnline: false
            ),
            StreamingDevice(
                id: UUID().uuidString,
                name: "John's IPhone",
                subtitle: "Connected",
                deviceId: "iphone",
                isOnline: false
            ),
            StreamingDevice(
                id: UUID().uuidString,
                name: "Andre's IPhone",
                subtitle: "Offline",
                deviceId: "iphone",
                isOnline: false
            )
        ]
    }
}
