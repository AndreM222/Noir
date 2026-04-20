//
//  SidebarView.swift
//  NoirBrowser
//
//  Created by Andre Mossi on 3/27/26.
//

import SwiftUI
import Kingfisher
internal import UniformTypeIdentifiers

struct TabsListView: View {
    @Binding var currWindow: WindowType
    @Binding var tabs: [MovieTabs]
    @Binding var session: [WatchSession]
    let movies: [Movie]
    let services: [Service]
    
    @State private var draggedTab: MovieTabs?
    @State private var hoveredTabIDs: Set<UUID> = []
    
    var body: some View {
        ScrollView {
            VStack {
                Button {
                    // Switch to search
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                        .background(.white.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(.white.opacity(0.12), lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)
                
                ForEach(tabs) { tab in
                    TabCard(
                        tabs: $tabs,
                        currWindow: $currWindow,
                        hoveredTabIDs: $hoveredTabIDs,
                        draggedItem: $draggedTab,
                        session: $session,
                        tab: tab,
                        movie: movies,
                        services: services,
                        onDelete: { deleteTab(tab: tab) }
                    )
                    .transition(.asymmetric(
                        insertion: .scale.combined(with: .opacity).combined(with: .move(edge: .top)),
                        removal: .scale.combined(with: .opacity).combined(with: .move(edge: .top))
                    ))
                    .animation(.spring(response: 0.35, dampingFraction: 0.82), value: tabs)
                    .onDrag{
                        draggedTab = tab
                        haptic(.impact)
                        return NSItemProvider(object: tab.id.uuidString as NSString)
                    }
                    .onDrop(of: [.text], delegate: TabDropDelegate(item: tab, tabs: $tabs, draggedItem: $draggedTab))
                }
            }
            .padding(.horizontal, 10)
        }
    }
}

func switchTab(
    tabId: UUID,
    movieId: String,
    currWindow: Binding<WindowType>
) {
    withAnimation(.spring(response: 0.28)) {
        currWindow.wrappedValue = WindowType(id: tabId, type: "tab", movieId: movieId)
    }
}

func addTab(
    tabs: Binding<[MovieTabs]>,
    session: Binding<[WatchSession]>,
    movieId: String,
    service: String
) -> UUID {
    // Find all tabs for this movie
    let filteredTabs = tabs.wrappedValue.filter { $0.movieId == movieId }
    
    // Find all sessions for those tabs
    let sessionsForMovie = session.wrappedValue.filter { tabSession in
        filteredTabs.contains(where: { $0.id == tabSession.id })
    }
    
    // Check if the service already exists for this movie
    if let tabFiltered = sessionsForMovie.first(where: { $0.serviceId == service }) {
        return tabFiltered.id
    }
    
    // Create new tab and session
    let newTab = MovieTabs(movieId: movieId)
    let newSession = WatchSession(
        id: newTab.id,
        serviceId: service,
        profile: "Andre",
        progress: 0,
        lastViewed: Date(),
        isBookmarked: true,
        url: URL(string: "https://www.netflix.com/watch/123")!
    )
    
    tabs.wrappedValue.insert(newTab, at: 0)
    session.wrappedValue.insert(newSession, at: 0)
    
    return newTab.id
}

private struct TabDropDelegate: DropDelegate {
    let item: MovieTabs
    @Binding var tabs: [MovieTabs]
    @Binding var draggedItem: MovieTabs?
    
    func dropEntered(info: DropInfo) {
        guard let draggedItem,
              draggedItem != item,
              let fromIndex = tabs.firstIndex(of: draggedItem),
              let toIndex = tabs.firstIndex(of: item)
        else { return }

        if tabs[toIndex].id != draggedItem.id {
            haptic(.selection)
        }

        withAnimation(.spring(response: 0.28, dampingFraction: 0.86)) {
            tabs.move(
                fromOffsets: IndexSet(integer: fromIndex),
                toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex
            )
        }
    }

    func performDrop(info: DropInfo) -> Bool {
        draggedItem = nil
        haptic(.success)
        return true
    }
}

extension TabsListView {
    fileprivate func deleteTab(tab: MovieTabs) {
        withAnimation(.spring(response: 0.35)) {
            session.removeAll { $0.id == tab.id }
            tabs.removeAll { $0.id == tab.id }
        }
    }
}

struct TabCard: View {
    @Binding var tabs: [MovieTabs]
    @Binding var currWindow: WindowType
    @Binding var hoveredTabIDs: Set<UUID>
    @Binding var draggedItem: MovieTabs?
    @Binding var session: [WatchSession]
    let tab: MovieTabs
    let movie: [Movie]
    let services: [Service]
    let onDelete: () -> Void
    
    private var isDragging: Bool { draggedItem?.id == tab.id }
    private var movieInfo: Movie? { movie.first { $0.id == tab.movieId } }
    private var sessionInfo: WatchSession? { session.first { $0.id == tab.id } }
    private var serviceInfo: Service? {
        guard let serviceId = sessionInfo?.serviceId else { return nil }
        return services.first { $0.id == serviceId }
    }
    private var isHovered: Bool { hoveredTabIDs.contains(tab.id) && draggedItem == nil }
    
    var body: some View {
        Button {
            switchTab(tabId: tab.id, movieId: tab.movieId, currWindow: $currWindow)
        } label: {
            HStack(spacing: 12) {
                if let url = movieInfo?.posterURL {
                    KFImage(url)
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
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text(movieInfo?.title ?? "undefined")
                        .font(.headline)
                        .foregroundColor(.white)

                    if let service = serviceInfo {
                        Text(service.title)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color(hex: service.brandColor).opacity(0.2))
                            .foregroundColor(Color(hex: service.brandColor))
                            .clipShape(Capsule())
                    }

                    if let progress = sessionInfo?.progress {
                        ProgressView(value: progress)
                            .progressViewStyle(.linear)
                            .tint(.white)
                            .frame(height: 4)
                    }
                }

                Spacer()

                if isHovered {
                    Button(action: onDelete) {
                        Image(systemName: "xmark")
                            .font(.system(size: 15))
                            .frame(width: 32, height: 32)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.borderless)
                    .background(.white.opacity(0.005))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .shadow(color: .black.opacity(isDragging ? 0.25 : 0.12), radius: isDragging ? 16 : 8, y: isDragging ? 8 : 4)
        .animation(.spring(response: 0.28, dampingFraction: 0.82), value: isDragging)
        .background(
            currWindow.id == tab.id
            ? Color.gray.opacity(0.05)
            : Color.black.opacity(0.2)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.05))
        )
        .onHover { hovering in
            if hovering {
                hoveredTabIDs.insert(tab.id)
            } else {
                hoveredTabIDs.remove(tab.id)
            }
        }
        .opacity(isDragging ? 0 : 1)
    }
}

#Preview {
    TabsListPreview()
}

struct TabsListPreview: View {
    @State private var tabs: [MovieTabs]
    @State private var session: [WatchSession]
    @State private var currWindow: WindowType

    private let movies = Movie.examplesMovie()
    private let services = Service.examples()

    init() {
        let tabsData = MovieTabs.examplesMovie()
        _tabs = State(initialValue: tabsData)
        _session = State(initialValue: WatchSession.examplesSession(tabs: tabsData))
        _currWindow = State(
            initialValue: WindowType(id: tabsData.first!.id, type: "tab")
        )
    }

    var body: some View {
        TabsListView(
            currWindow: $currWindow,
            tabs: $tabs,
            session: $session, movies: movies,
            services: services
        )
    }
}

