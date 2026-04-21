//
//  ContentView.swift
//  Noir
//
//  Created by Andre Mossi on 4/20/26.
//

import SwiftUI

struct WindowType: Hashable {
    var id: UUID?
    var type: String
    var movieId: String?
}

struct ContentView: View {
    @State private var tabs: [MovieTabs] = MovieTabs.examplesMovie()
    @State private var currWindow: WindowType
    @State private var bookmarks: [Bookmarks] = []
    @State private var sessions: [WatchSession] = []

    @Binding var account: Account?
    @EnvironmentObject var uiState: AppUIState

    @Environment(\.openSettings) private var openSettings
    @Environment(\.openWindow) private var openWindow

    init(account: Binding<Account?>) {
        let initialTabs = MovieTabs.examplesMovie()
        _tabs = State(initialValue: initialTabs)
        if let firstTab = initialTabs.first {
            _currWindow = State(initialValue: WindowType(
                id: firstTab.id,
                type: "tab",
                movieId: firstTab.movieId
            ))
        } else {
            _currWindow = State(initialValue: WindowType(id: nil, type: "tab"))
        }
        _bookmarks = State(initialValue: Bookmarks.examplesBookmarks())

        _sessions = State(initialValue: WatchSession.examplesSession(tabs: initialTabs))

        _account = account
    }

    var body: some View {
        ZStack {
            Text("yay")
            NavigationSplitView {
                SidebarView(
                    currWindow: $currWindow,
                    bookmarks: $bookmarks,
                    tabs: $tabs,
                    sessions: $sessions
                )
                .navigationSplitViewColumnWidth(min: 220, ideal: 260, max: 320)
                .background(SidebarBackground())
            } detail: {
                HStack {
                    switch currWindow.type {
                    case "tab":
                        MovieSreamInfo(
                            currWindow: $currWindow,
                            tabs: $tabs,
                            bookmarks: $bookmarks,
                            movie: Movie.examplesMovie(),
                            sessions: $sessions,
                            services: Service.examples()
                        )
                    case "movie":
                        MovieSreamInfo(
                            currWindow: $currWindow,
                            tabs: $tabs,
                            bookmarks: $bookmarks,
                            movie: Movie.examplesMovie(),
                            sessions: $sessions,
                            services: Service.examples()
                        )
                    default:
                        HStack { Text("NOIR") }
                    }
                }
                .background(WindowAccessor { window in
                    window.isOpaque = false
                    window.backgroundColor = .clear
                })
                .background(
                    ZStack {
                        CustomBackground()
                    }
                    .ignoresSafeArea()
                )
                .overlay(alignment: .topTrailing) {
                    HStack {
                        SearchField()
                        Button {
                            openWindow(id: "settings")
                        } label: {
                            UserAvatar(
                                config: AvatarConfig(
                                    color: account?.color ?? .cosmic,
                                    icon: account?.icon ?? .person,
                                    name: account?.name ?? "Unknown",
                                    size: 30,
                                    radius: 4
                                )
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(10)
                }
                .overlay(alignment: .bottomTrailing) {
                    DeviceBar()
                        .padding(10)
                }
                .edgesIgnoringSafeArea(.vertical)
            }
            if uiState.showingQuitDialog {
                CloseView(isPresented: $uiState.showingQuitDialog)
                    .transition(.opacity.combined(with: .scale(scale: 0.98)))
                    .zIndex(1000)
            }
        }
        .animation(.spring(response: 0.28, dampingFraction: 0.86), value: uiState.showingQuitDialog)
        .navigationSplitViewStyle(.prominentDetail)
    }
}

#Preview {
    let uiState = AppUIState()
    uiState.showingQuitDialog = false
    return ContentView(account: .constant(Account.examples().first!))
        .environmentObject(uiState)
}
