//
//  NoirBrowserApp.swift
//  NoirBrowser
//
//  Created by Andre Mossi on 3/27/26.
//

import SwiftUI

@main
struct NoirBrowserApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unifiedCompact)
        
        Settings {
            SettingsView()
        }
    }
}
