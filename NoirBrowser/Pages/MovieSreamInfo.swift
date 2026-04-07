//
//  MovieSreamInfo.swift
//  NoirBrowser
//
//  Created by Andre Mossi on 3/28/26.
//

import SwiftUI
import Kingfisher
import AVKit

struct VideoBackgroundView: View {
    let url: URL?
    
    @State private var player: AVPlayer?
    
    var body: some View {
        ZStack {
            if let player {
                VideoPlayer(player: player)
                    .disabled(true) // no controls
                    .onAppear {
                        player.isMuted = true
                        player.play()
                        loopVideo(player)
                    }
            } else {
                Color.black
            }
        }
        .onAppear {
            if let url {
                player = AVPlayer(url: url)
            }
        }
    }
    
    private func loopVideo(_ player: AVPlayer) {
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: .main
        ) { _ in
            player.seek(to: .zero)
            player.play()
        }
    }
}

struct ServiceCard: View {
    @Binding var tabs: [MovieTabs]
    @Binding var session: [WatchSession]
    let movieId: String
    let service: Service?
    
    let sessionInfo: WatchSession?
    
    var body: some View {
        if let service {
            let color = Color(hex: service.brandColor)
            let hasProgress = sessionInfo?.serviceId == service.id
            
            Button {
                addTab(tabs: $tabs, session: $session, movieId: movieId, service: service.id)
            } label: {
                HStack {
                    VStack(spacing: 5) {
                        // Service name
                        Text(service.title)
                            .font(.caption2.weight(.medium))
                            .foregroundStyle(.white)
                            .lineLimit(1)
                        
                        // Progress indicator (if available)
                        if hasProgress, let progress = sessionInfo?.progress {
                            ProgressView(value: progress)
                                .progressViewStyle(.linear)
                                .tint(color.opacity(0.8))
                                .frame(height: 3)
                                .scaleEffect(x: 1, y: 0.8)
                        }
                    }
                    Image(systemName: "play")
                }
                .padding()
                .frame(width: 150, height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(color.opacity(0.3), lineWidth: 1)
                        )
                )
            }
            .buttonStyle(.plain)
        }
    }
}

struct MovieSreamInfo: View {
    @Binding var currWindow: WindowType
    @Binding var tabs: [MovieTabs]
    @Binding var bookmarks: [Bookmarks]
    let movie: [Movie]
    @Binding var sessions: [WatchSession]
    let services: [Service]
    private var filteredTabsBinding: Binding<[MovieTabs]> {
        Binding(
            get: { tabs.filter { $0.movieId == currWindow.movieId } },
            set: { newValue in
                // Replace filtered subset in the original array
                let filteredIds = tabs.filter { $0.movieId == currWindow.movieId }.map(\.id)
                // Remove old filtered items and add new ones
                self.tabs = tabs.filter { !filteredIds.contains($0.id) } + newValue
            }
        )
    }
    
    var body: some View {
        let movieTab = tabs.first { $0.id == currWindow.id }
        let movieInfo = movie.first { $0.id == currWindow.movieId }
        let bookmarkInfo = bookmarks.first { $0.movieId == movieInfo?.id }
        let sessionInfo = sessions.first { $0.id == movieTab?.id }
        let serviceInfo = services.first { $0.id == sessionInfo?.serviceId }
        
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                // Poster + Gradient Overlay
                ZStack(alignment: .bottomLeading) {
                    ZStack {
                        if let trailer = movieInfo?.trailerURL {
                            VideoBackgroundView(url: trailer)
                        } else {
                            KFImage(movieInfo?.posterURL)
                                .resizable()
                                .scaledToFill()
                        }
                    }
                    .frame(height: 300)
                    .clipped()
                    
                    // Overlay (keep this)
                    LinearGradient(
                        colors: [.clear, .black.opacity(0.9)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    
                    VStack(alignment: .leading, spacing: 8) {
                        KFImage(movieInfo?.posterURL)
                            .placeholder {
                                ZStack {
                                    Color.gray.opacity(0.2)
                                    ProgressView()
                                }
                            }
                            .fade(duration: 0.3)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 90)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        Text(movieInfo?.title ?? "Unknown")
                            .font(.title)
                            .bold()
                            .foregroundColor(.white)
                        
                        if let year = movieInfo?.releaseYear,
                           let duration = movieInfo?.duration {
                            Text("\(year) • \(formatTime(duration))")
                                .foregroundColor(.gray)
                                .font(.subheadline)
                        }
                    }
                    .padding()
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    
                    // Resume Button
                    if let sessionInfo {
                        Button {
                            // open deep link here
                        } label: {
                            HStack {
                                Image(systemName: "play.fill")
                                Text("Resume")
                                    .bold()
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                        }
                        .background(Color.white)
                        .foregroundColor(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        // Progress
                        ProgressView(value: sessionInfo.progress)
                            .tint(.white)
                    }
                    
                    HStack {
                        // Bookmark
                        Button {
                            if bookmarkInfo?.id != nil {
                                bookmarks.removeAll(where: { $0.movieId == movieInfo?.id })
                            } else {
                                bookmarks.append(
                                    Bookmarks(
                                        movieId: movieInfo?.id ?? "undefined",
                                        profile: "Andre"
                                    ))
                            }
                            // Bookmark Change
                        } label: {
                            HStack {
                                if bookmarkInfo?.id != nil {
                                    Image(systemName: "checkmark")
                                }
                                else {
                                    Image(systemName: "plus")
                                }
                            }
                            .font(.system(size: 18))
                            .padding()
                            .frame(maxWidth: 20)
                        }
                        .background(Color.white)
                        .foregroundColor(.black)
                        .clipShape(Circle())
                        
                        // Like
                        Button {
                            // Bookmark Change
                        } label: {
                            HStack {
                                if (false) {
                                    Image(systemName: "heart.fill")
                                }
                                else {
                                    Image(systemName: "heart")
                                }
                            }
                            .font(.system(size: 18))
                            .padding()
                            .frame(maxWidth: 20)
                        }
                        .background(Color.white)
                        .foregroundColor(.black)
                        .clipShape(Circle())
                        
                        // Share
                        Button {
                            // Bookmark Change
                        } label: {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                            }
                            .font(.system(size: 18))
                            .padding()
                            .frame(maxWidth: 20)
                        }
                        .background(Color.white)
                        .foregroundColor(.black)
                        .clipShape(Circle())
                        
                        Button {
                            // Notification Button release
                        } label: {
                            HStack {
                                if (false) {
                                    Image(systemName: "bell.fill")
                                }
                                else {
                                    Image(systemName: "bell")
                                }
                            }
                            .font(.system(size: 18))
                            .padding()
                            .frame(maxWidth: 20)
                        }
                        .background(Color.white)
                        .foregroundColor(.black)
                        .clipShape(Circle())
                    }
                    
                    // Service
                    // **Service badge** (elevated)
                    
                    // **Key facts grid**
                    HStack(spacing: 24) {
                        if let serviceInfo {
                            HStack {
                                Image(systemName: "play.rectangle.fill")
                                Text(serviceInfo.title)
                            }
                            .font(.caption.weight(.medium))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color(hex: serviceInfo.brandColor).opacity(0.15))
                            .foregroundStyle(Color(hex: serviceInfo.brandColor))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                    }
                    
                    // Replace your single service badge with this:
                    if let serviceIds = movieInfo?.serviceIds {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Watch on")
                                    .font(.headline.weight(.semibold))
                                    .foregroundStyle(.white)
                            }
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHGrid(rows: [GridItem(.fixed(60))], spacing: 12) {
                                    ForEach(serviceIds, id: \.self) { serviceId in
                                        let service = services.first { $0.id == serviceId }
                                        ServiceCard(
                                            tabs: $tabs,
                                            session: $sessions,
                                            movieId: currWindow.movieId!,
                                            service: service,
                                            sessionInfo: sessions.first { $0.id == movieTab?.id }
                                        )
                                    }
                                }
                                .padding(3)
                            }
                        }
                    }
                    
                    // Description
                    if let desc = movieInfo?.description {
                        Text(desc)
                            .foregroundColor(.gray)
                            .font(.body)
                    }
                    
                    // Ratings
                    if let ratings = movieInfo?.ratings {
                        HStack(spacing: 12) {
                            ForEach(ratings, id: \.source) { rating in
                                VStack {
                                    Text(rating.source)
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                    
                                    Text("\(Int(rating.value))")
                                        .bold()
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    }
                    
                    // **Genres** (chips)
                    if let genres = movieInfo?.genres {
                        LazyHGrid(rows: [GridItem(.adaptive(minimum: 80))], spacing: 8) {
                            ForEach(genres, id: \.self) { genre in
                                Text(genre)
                                    .font(.caption2.weight(.medium))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(.ultraThinMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                            }
                        }
                    }
                    
                    // **Cast** (horizontal scroll)
                    HStack {
                        Text("Cast").font(.headline.weight(.semibold))
                        Spacer()
                        Text("See all →")
                            .font(.caption.weight(.medium))
                            .foregroundStyle(.secondary)
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: [GridItem(.fixed(120))], spacing: 12) {
                            if let cast = movieInfo?.starring {
                                ForEach(cast.prefix(6), id: \.self) { actor in
                                    VStack(spacing: 4) {
                                        Rectangle()
                                            .fill(.ultraThinMaterial)
                                            .frame(width: 80, height: 100)
                                            .clipShape(RoundedRectangle(cornerRadius: 20))
                                        Text(actor)
                                            .font(.caption2.weight(.medium))
                                            .multilineTextAlignment(.center)
                                    }
                                    .frame(width: 80)
                                }
                            }
                        }
                    }
                    
                    // **Cast** (horizontal scroll)
                    HStack {
                        Text("Directors").font(.headline.weight(.semibold))
                        Spacer()
                        Text("See all →")
                            .font(.caption.weight(.medium))
                            .foregroundStyle(.secondary)
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: [GridItem(.fixed(120))], spacing: 12) {
                            if let cast = movieInfo?.directors {
                                ForEach(cast.prefix(6), id: \.self) { director in
                                    VStack(spacing: 4) {
                                        Rectangle()
                                            .fill(.ultraThinMaterial)
                                            .frame(width: 80, height: 100)
                                            .clipShape(RoundedRectangle(cornerRadius: 20))
                                        Text(director)
                                            .font(.caption2.weight(.medium))
                                            .multilineTextAlignment(.center)
                                    }
                                    .frame(width: 80)
                                }
                            }
                        }
                    }
                    
                    // Tabs
                    if filteredTabsBinding.count > 0 {
                        HStack {
                            Image(systemName: "list.bullet")
                            Text("Queue")
                        }
                        VStack(alignment: .leading) {
                            TabsListView(currWindow: $currWindow, tabs: filteredTabsBinding, session: $sessions, movies: Movie.examplesMovie(), services: Service.examples())
                        }.frame(height: 300)
                    }
                }
                .padding()
            }
        }
        .background(
            
            LinearGradient(
                colors: [.clear, .black],
                startPoint: .top,
                endPoint: .bottom
            ).ignoresSafeArea()
        )
    }
}

#Preview {
    let movietabs = MovieTabs.examplesMovie()
    
    MovieSreamInfo(currWindow: .constant(WindowType(id: movietabs[0].id, type: "movie", movieId: movietabs[0].movieId)), tabs: .constant(movietabs), bookmarks: .constant(Bookmarks.examplesBookmarks()), movie: Movie.examplesMovie(), sessions: .constant(WatchSession.examplesSession(tabs: movietabs)), services: Service.examples())
}

