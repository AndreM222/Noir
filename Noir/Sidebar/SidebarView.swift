//
//  SidebarView.swift
//  NoirBrowser
//
//  Created by Andre Mossi on 3/27/26.
//

import SwiftUI

struct OptionButton: View {
    @Binding var currWindow: WindowType
    let type: String
    let icon: String

    var body: some View {
        Button {
            currWindow = WindowType(type: type)
        } label: {
            Image(systemName: icon)
                .frame(maxWidth: .infinity, minHeight: 20)
                .padding(5)
        }
        .background(
            currWindow == WindowType(type: type) ?
                Color.black.opacity(-2.8)
                :
                Color.black.opacity(0.8)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.05))
        )
    }
}

struct SidebarView: View {
    @Binding var currWindow: WindowType
    @Binding var bookmarks: [Bookmarks]
    @Binding var tabs: [MovieTabs]
    @Binding var sessions: [WatchSession]

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                OptionButton(currWindow: $currWindow, type: "home", icon: "house")

                OptionButton(currWindow: $currWindow, type: "cinema", icon: "ticket")

                OptionButton(currWindow: $currWindow, type: "likes", icon: "heart")
            }.padding(10)
            HStack {
                Image(systemName: "bookmark")
                Text("Bookmarks")
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 1)
            BookmarksListView(
                currWindow: $currWindow,
                bookmarks: $bookmarks,
                movies: Movie.examplesMovie()
            )
            .padding(.vertical, -33)

            HStack {
                Image(systemName: "list.bullet")
                Text("Queue")
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 1)
            TabsListView(
                currWindow: $currWindow,
                tabs: $tabs,
                session: $sessions,
                movies: Movie.examplesMovie(),
                services: Service.examples()
            )
        }
        .onAppear {
            sessions = WatchSession.examplesSession(tabs: tabs)
        }
    }
}

#Preview {
    SidebarPreview()
}

struct SidebarPreview: View {
    @State private var currWindow: WindowType
    @State private var bookmarks: [Bookmarks]
    @State private var tabs: [MovieTabs]
    @State private var sessions: [WatchSession]

    private let movies = Movie.examplesMovie()
    private let services = Service.examples()

    init() {
        let tabsData = MovieTabs.examplesMovie()
        let bookmarksData = Bookmarks.examplesBookmarks()

        _tabs = State(initialValue: tabsData)
        _bookmarks = State(initialValue: bookmarksData)
        _sessions = State(initialValue: WatchSession.examplesSession(tabs: tabsData))
        _currWindow = State(
            initialValue: WindowType(
                id: tabsData.first!.id,
                type: "tab",
                movieId: tabsData.first!.movieId
            )
        )
    }

    var body: some View {
        SidebarView(
            currWindow: $currWindow,
            bookmarks: $bookmarks,
            tabs: $tabs,
            sessions: $sessions
        )
        .frame(width: 400, height: 700)
    }
}
