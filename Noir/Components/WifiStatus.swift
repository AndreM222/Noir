//
//  WifiStatus.swift
//  NoirBrowser
//
//  Created by Andre Mossi on 4/2/26.
//

import Foundation
import Network
import SwiftUI

@Sendable
func isConnectedToNetwork() async -> Bool {
    await withCheckedContinuation { continuation in
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetworkPathMonitor")

        monitor.pathUpdateHandler = { path in
            let connected = path.status == .satisfied
            continuation.resume(returning: connected)
            monitor.cancel()
        }

        monitor.start(queue: queue)
    }
}

struct WifiStatus: View {
    @State private var isConnected = false
    var size: CGFloat = 12

    var body: some View {
        Image(systemName: isConnected ? "wifi" : "wifi.slash")
            .font(.system(size: size, weight: .medium))
            .task {
                for await path in NWPathMonitor() {
                    await MainActor.run {
                        isConnected = path.status == .satisfied
                    }
                }
            }
    }
}

#Preview {
    WifiStatus()
}
