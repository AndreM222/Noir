//
//  Tabs.swift
//  NoirBrowser
//
//  Created by Andre Mossi on 3/27/26.
//

import Foundation

struct MovieTabs: Identifiable, Hashable {
    let id = UUID()
    var movieId: String

    static func examplesMovie() -> [MovieTabs] {
        [
            MovieTabs(
                movieId: "inception"
            ),
            MovieTabs(
                movieId: "thedarkknight"
            ),
            MovieTabs(
                movieId: "interstellar"
            ),
            MovieTabs(
                movieId: "parasite"
            ),
            MovieTabs(
                movieId: "whiplash"
            )
        ]
    }
}

struct WatchSession: Identifiable, Hashable {
    var id: UUID
    var serviceId: String
    var profile: String
    var progress: Double
    var lastViewed: Date?
    var isBookmarked: Bool
    var url: URL

    static func examplesSession(tabs: [MovieTabs]) -> [WatchSession] {
        [
            WatchSession(
                id: tabs[0].id,
                serviceId: "netflix",
                profile: "Andre",
                progress: 0.65,
                lastViewed: Date().addingTimeInterval(-3600),
                isBookmarked: true,
                url: URL(string: "https://www.netflix.com/watch/123")!
            ),
            WatchSession(
                id: tabs[1].id,
                serviceId: "hbo",
                profile: "Andre",
                progress: 0.3,
                lastViewed: Date().addingTimeInterval(-86400),
                isBookmarked: false,
                url: URL(string: "https://play.hbomax.com/page/urn:hbo:page:123")!
            ),
            WatchSession(
                id: tabs[2].id,
                serviceId: "prime",
                profile: "Guest",
                progress: 0.9,
                lastViewed: Date().addingTimeInterval(-7200),
                isBookmarked: true,
                url: URL(string: "https://www.amazon.com/dp/B08")!
            ),
            WatchSession(
                id: tabs[3].id,
                serviceId: "netflix",
                profile: "Andre",
                progress: 0.1,
                lastViewed: Date().addingTimeInterval(-172_800),
                isBookmarked: false,
                url: URL(string: "https://www.netflix.com/watch/456")!
            ),
            WatchSession(
                id: tabs[4].id,
                serviceId: "apple",
                profile: "Andre",
                progress: 0.0,
                lastViewed: nil,
                isBookmarked: true,
                url: URL(string: "https://tv.apple.com/movie/whiplash")!
            )
        ]
    }
}
