//
//  ContentView.swift
//  NoirBrowser
//
//  Created by Andre Mossi on 3/27/26.
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
    
    init() {
        let initialTabs = MovieTabs.examplesMovie()
        _tabs = State(initialValue: initialTabs)
        if let firstTab = initialTabs.first {
            _currWindow = State(initialValue: WindowType(id: firstTab.id, type: "tab", movieId: firstTab.movieId))
        } else {
            _currWindow = State(initialValue: WindowType(id: nil, type: "tab"))
        }
        _bookmarks = State(initialValue: Bookmarks.examplesBookmarks())
        
        _sessions = State(initialValue: WatchSession.examplesSession(tabs: initialTabs))
    }
    
    var body: some View {
        
        NavigationSplitView {
            SidebarView(currWindow: $currWindow, bookmarks: $bookmarks, tabs: $tabs, sessions: $sessions)
        } detail: {
            HStack {
                switch currWindow.type {
                case "tab":
                    MovieSreamInfo(currWindow: $currWindow, tabs: $tabs, bookmarks: $bookmarks, movie: Movie.examplesMovie(), sessions: $sessions, services: Service.examples())
                case "movie":
                    MovieSreamInfo(currWindow: $currWindow, tabs: $tabs, bookmarks: $bookmarks, movie: Movie.examplesMovie(), sessions: $sessions, services: Service.examples())
                default:
                    HStack {
                        Text("NOIR")
                    }
                }
            }
            .overlay(alignment: .topTrailing) {
                HStack {
                    SearchField()
                    UserAvatar(
                        config: AvatarConfig(
                            personality: .neon,
                            name: "Andre Mossi",
                            size: 30,
                            radius: 4
                        )
                    )
                }
                .padding(10)
            }
            .overlay(alignment: .bottomTrailing) {
                DeviceBar()
                    .padding(10)
            }
            .edgesIgnoringSafeArea(.vertical)
        }
        .edgesIgnoringSafeArea(.vertical)
    }
}

#Preview {
    ContentView()
}
