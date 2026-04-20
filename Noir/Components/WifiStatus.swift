//
//  WifiStatus.swift
//  NoirBrowser
//
//  Created by Andre Mossi on 4/2/26.
//

import Foundation
import Network

func isConnectedToNetwork() -> Bool {
    // Prefer Network framework over deprecated SystemConfiguration reachability APIs.
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "NetworkPathMonitor")
    let semaphore = DispatchSemaphore(value: 0)

    var isConnected: Bool = false

    monitor.pathUpdateHandler = { path in
        // Consider the network reachable if status is satisfied and it doesn't require an interface type that's unavailable.
        isConnected = (path.status == .satisfied)
        semaphore.signal()
        monitor.cancel()
    }

    monitor.start(queue: queue)

    // Wait briefly for the first path update. If none arrives, assume not connected.
    let timeoutResult = semaphore.wait(timeout: .now() + 0.5)
    if timeoutResult == .timedOut {
        monitor.cancel()
    }

    return isConnected
}
