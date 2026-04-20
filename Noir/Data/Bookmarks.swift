//
//  Tabs.swift
//  NoirBrowser
//
//  Created by Andre Mossi on 3/27/26.
//

import Foundation

struct Bookmarks: Identifiable, Hashable {
    let id = UUID()
    var movieId: String
    var profile: String

    static func examplesBookmarks() -> [Bookmarks] {
        [
            Bookmarks(
                movieId: "interstellar",
                profile: "Andre"
            ),
            Bookmarks(
                movieId: "inception",
                profile: "Andre"
            ),
            Bookmarks(
                movieId: "whiplash",
                profile: "Andre"
            ),
            Bookmarks(
                movieId: "thedarkknight",
                profile: "Guest"
            )
        ]
    }
}
