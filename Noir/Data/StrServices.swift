//
//  StrServices.swift
//  NoirBrowser
//
//  Created by Andre Mossi on 3/27/26.
//

import Foundation

struct Service: Identifiable, Hashable {
    let id: String
    var title: String
    var description: String
    var websiteUrl: URL
    var paymentUrl: URL?
    var isActive: Bool
    var iconName: String
    var brandColor: String
    var deepLinkScheme: String?
    var supportsProfiles: Bool
    var supportsDeepLinking: Bool

    static func examples() -> [Service] {
        [
            Service(
                id: "netflix",
                title: "Netflix",
                description: "Watch movies and TV shows online.",
                websiteUrl: URL(string: "https://www.netflix.com")!,
                paymentUrl: URL(string: "https://www.netflix.com/signup")!,
                isActive: true,
                iconName: "netflix",
                brandColor: "#E50914",
                deepLinkScheme: "nflx://",
                supportsProfiles: true,
                supportsDeepLinking: true
            ),
            Service(
                id: "prime",
                title: "Prime Video",
                description: "Stream movies and TV shows with Amazon Prime.",
                websiteUrl: URL(string: "https://www.primevideo.com")!,
                paymentUrl: URL(string: "https://www.amazon.com/amazonprime")!,
                isActive: true,
                iconName: "primevideo",
                brandColor: "#00A8E1",
                deepLinkScheme: "primevideo://",
                supportsProfiles: true,
                supportsDeepLinking: true
            ),
            Service(
                id: "hbo",
                title: "HBO Max",
                description: "Stream HBO originals and blockbuster movies.",
                websiteUrl: URL(string: "https://www.max.com")!,
                paymentUrl: URL(string: "https://www.max.com/subscribe")!,
                isActive: false,
                iconName: "hbomax",
                brandColor: "#5B2EFF",
                deepLinkScheme: nil,
                supportsProfiles: true,
                supportsDeepLinking: false
            ),
            Service(
                id: "apple",
                title: "Apple TV+",
                description: "Apple's original movies and series.",
                websiteUrl: URL(string: "https://tv.apple.com")!,
                paymentUrl: URL(string: "https://tv.apple.com")!,
                isActive: true,
                iconName: "appletv",
                brandColor: "#FFFFFF",
                deepLinkScheme: "videos://",
                supportsProfiles: true,
                supportsDeepLinking: true
            ),
            Service(
                id: "youtube",
                title: "YouTube",
                description: "Watch and discover videos.",
                websiteUrl: URL(string: "https://www.youtube.com")!,
                paymentUrl: nil,
                isActive: true,
                iconName: "youtube",
                brandColor: "#FF0000",
                deepLinkScheme: "youtube://",
                supportsProfiles: true,
                supportsDeepLinking: true
            )
        ]
    }
}
