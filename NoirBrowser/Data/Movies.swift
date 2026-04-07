//
//  Tabs.swift
//  NoirBrowser
//
//  Created by Andre Mossi on 3/27/26.
//

import Foundation

struct Rating: Hashable {
    var source: String
    var value: Double
    var maxValue: Double
}

struct Movie: Identifiable, Hashable {
    let id: String
    var title: String
    var description: String?
    var posterURL: URL?
    var trailerURL: URL?
    var releaseYear: Int?
    var duration: Int // seconds
    var ageRating: String?
    var genres: [String]?
    var starring: [String]?
    var directors: [String]?
    var originCountry: String?
    var serviceIds: [String]? // available platforms
    var ratings: [Rating]?

    static func examplesMovie() -> [Movie] {
        [
            Movie(
                id: "inception",
                title: "Inception",
                description: "A thief who steals corporate secrets through dream-sharing technology is given the inverse task of planting an idea.",
                posterURL: URL(string: "https://image.tmdb.org/t/p/w1280/xlaY2zyzMfkhk0HSC5VUwzoZPU1.jpg"),
                trailerURL: URL(string: "https://www.youtube.com/watch?v=YoHD9XEInc0"),
                releaseYear: 2010,
                duration: 8880,
                ageRating: "PG-13",
                genres: ["Sci-Fi", "Thriller"],
                starring: ["Leonardo DiCaprio", "Joseph Gordon-Levitt"],
                directors: ["Christopher Nolan"],
                originCountry: "USA",
                serviceIds: ["netflix", "prime"],
                ratings: [
                    Rating(source: "IMDb", value: 8.8, maxValue: 10),
                    Rating(source: "Rotten Tomatoes", value: 87, maxValue: 100),
                    Rating(source: "Noir", value: 9.2, maxValue: 10)
                ]
            ),

            Movie(
                id: "thedarkknight",
                title: "The Dark Knight",
                description: "Batman faces the Joker, a criminal mastermind who plunges Gotham into chaos.",
                posterURL: URL(string: "https://image.tmdb.org/t/p/w500/qJ2tW6WMUDux911r6m7haRef0WH.jpg"),
                trailerURL: URL(string: "https://www.youtube.com/watch?v=EXeTwQWrcwY"),
                releaseYear: 2008,
                duration: 9120,
                ageRating: "PG-13",
                genres: ["Action", "Crime"],
                starring: ["Christian Bale", "Heath Ledger"],
                directors: ["Christopher Nolan"],
                originCountry: "USA",
                serviceIds: ["hbo"],
                ratings: [
                    Rating(source: "IMDb", value: 9.0, maxValue: 10),
                    Rating(source: "Rotten Tomatoes", value: 94, maxValue: 100),
                    Rating(source: "Noir", value: 9.5, maxValue: 10)
                ]
            ),

            Movie(
                id: "interstellar",
                title: "Interstellar",
                description: "A team of explorers travel through a wormhole in space in an attempt to ensure humanity's survival.",
                posterURL: URL(string: "https://image.tmdb.org/t/p/w500/rAiYTfKGqDCRIIqo664sY9XZIvQ.jpg"),
                trailerURL: URL(string: "https://www.youtube.com/watch?v=zSWdZVtXT7E"),
                releaseYear: 2014,
                duration: 10140,
                ageRating: "PG-13",
                genres: ["Sci-Fi", "Drama"],
                starring: ["Matthew McConaughey", "Anne Hathaway"],
                directors: ["Christopher Nolan"],
                originCountry: "USA",
                serviceIds: ["prime"],
                ratings: [
                    Rating(source: "IMDb", value: 8.6, maxValue: 10),
                    Rating(source: "Rotten Tomatoes", value: 73, maxValue: 100),
                    Rating(source: "Noir", value: 9.0, maxValue: 10)
                ]
            ),

            Movie(
                id: "parasite",
                title: "Parasite",
                description: "A poor family schemes to become employed by a wealthy family.",
                posterURL: URL(string: "https://image.tmdb.org/t/p/w500/7IiTTgloJzvGI1TAYymCfbfl3vT.jpg"),
                trailerURL: URL(string: "https://www.youtube.com/watch?v=5xH0HfJHsaY"),
                releaseYear: 2019,
                duration: 7920,
                ageRating: "R",
                genres: ["Thriller", "Drama"],
                starring: ["Song Kang-ho"],
                directors: ["Bong Joon-ho"],
                originCountry: "South Korea",
                serviceIds: ["netflix"],
                ratings: [
                    Rating(source: "IMDb", value: 8.5, maxValue: 10),
                    Rating(source: "Rotten Tomatoes", value: 99, maxValue: 100),
                    Rating(source: "Noir", value: 9.4, maxValue: 10)
                ]
            ),

            Movie(
                id: "whiplash",
                title: "Whiplash",
                description: "A promising young drummer enrolls at a cut-throat music conservatory.",
                posterURL: URL(string: "https://image.tmdb.org/t/p/w500/oPxnRhyAIzJKGUEdSiwTJQBa3NM.jpg"),
                trailerURL: URL(string: "https://www.youtube.com/watch?v=7d_jQycdQGo"),
                releaseYear: 2014,
                duration: 6420,
                ageRating: "R",
                genres: ["Drama", "Music"],
                starring: ["Miles Teller", "J.K. Simmons"],
                directors: ["Damien Chazelle"],
                originCountry: "USA",
                serviceIds: ["apple"],
                ratings: [
                    Rating(source: "IMDb", value: 8.5, maxValue: 10),
                    Rating(source: "Rotten Tomatoes", value: 94, maxValue: 100),
                    Rating(source: "Noir", value: 9.1, maxValue: 10)
                ]
            )
        ]
    }

}
