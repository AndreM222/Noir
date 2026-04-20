//
//  NoirBrowserApp.swift
//  NoirBrowser
//
//  Created by Andre Mossi on 3/27/26.
//

import SwiftUI
import Combine

final class AppUIState: ObservableObject {
    @Published var showingQuitDialog = false
}

@main
struct NoirApp: App {
    @State private var account: Account?
    @State private var profiles: [Profile]
    @StateObject private var uiState = AppUIState()
    @Environment(\.openWindow) private var openWindow

    init() {
        let accountExample = Account.examples()
        let profilesExample = Profile.examples(account: accountExample)

        _account = State(initialValue: accountExample.first)
        _profiles = State(initialValue: profilesExample.filter { $0.account == accountExample.first?.id })
    }

    var body: some Scene {
        WindowGroup {
            ContentView(account: $account, )
                .environmentObject(uiState)
                .edgesIgnoringSafeArea(.vertical)
        }
        .windowStyle(.hiddenTitleBar)
        .commands {
            CommandGroup(replacing: .appSettings) {
                Button("Settings") {
                    openWindow(id: "settings")
                }
                .keyboardShortcut(",", modifiers: .command)
            }
            CommandGroup(replacing: .appTermination) {
                Button("Quit Noir Browser") {
                    uiState.showingQuitDialog = true
                }
                .keyboardShortcut("q", modifiers: [.command])
            }
        }

        Window("Settings", id: "settings") {
            SettingsView(account: $account, profiles: $profiles)
                .edgesIgnoringSafeArea(.vertical)
                .background(WindowAccessor { window in
                    window.isOpaque = false
                    window.backgroundColor = .clear
                })
        }
        .windowStyle(.hiddenTitleBar)
    }
}

