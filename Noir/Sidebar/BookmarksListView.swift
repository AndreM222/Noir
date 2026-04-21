//
//  BookmarksListView.swift
//  NoirBrowser
//
//  Created by Andre Mossi on 3/31/26.
//

internal import UniformTypeIdentifiers
import Kingfisher
import SwiftUI

struct BookmarksListView: View {
    @Binding var currWindow: WindowType
    @Binding var bookmarks: [Bookmarks]
    let movies: [Movie]

    @State private var hoveredBookmarkIDs: Set<UUID> = []
    @State private var draggedBookmark: Bookmarks?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(bookmarks) { bookmark in
                    BookmarkCard(
                        bookmark: bookmark,
                        currWindow: $currWindow,
                        hoveredBookmarkIDs: $hoveredBookmarkIDs,
                        draggedItem: $draggedBookmark,
                        movies: movies,
                        onDelete: { deleteBookmark(bookmark: bookmark) }
                    )
                    .transition(.asymmetric(
                        insertion: AnyTransition.scale.combined(with: .opacity)
                            .combined(with: .move(edge: .leading)),
                        removal: AnyTransition.scale.combined(with: .opacity)
                            .combined(with: .move(edge: .leading))
                    ))
                    .onDrag {
                        draggedBookmark = bookmark
                        haptic(.impact)
                        return NSItemProvider(object: bookmark.id.uuidString as NSString)
                    }
                    .onDrop(
                        of: [.text],
                        delegate: BookmarkDropDelegate(
                            item: bookmark,
                            bookmarks: $bookmarks,
                            draggedItem: $draggedBookmark
                        )
                    )
                }

                // Add new bookmark button (leftmost)
                Button {
                    withAnimation(.spring(response: 0.35)) {
                        let newBookmark = Bookmarks(
                            movieId: movies.first?.id ?? "default",
                            profile: "Andre"
                        )
                        bookmarks.insert(newBookmark, at: 0)
                    }
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundStyle(.secondary)
                        .frame(width: 72, height: 104)
                        .background(.white.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(.white.opacity(0.12), lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 33)
        }
        .animation(.spring(response: 0.38, dampingFraction: 0.82), value: bookmarks)
    }
}

private struct BookmarkDropDelegate: DropDelegate {
    let item: Bookmarks
    @Binding var bookmarks: [Bookmarks]
    @Binding var draggedItem: Bookmarks?

    func dropEntered(info _: DropInfo) {
        guard let draggedItem,
              draggedItem != item,
              let fromIndex = bookmarks.firstIndex(of: draggedItem),
              let toIndex = bookmarks.firstIndex(of: item)
        else { return }

        if bookmarks[toIndex].id != draggedItem.id {
            haptic(.selection)
        }

        withAnimation(.spring(response: 0.28, dampingFraction: 0.86)) {
            bookmarks.move(
                fromOffsets: IndexSet(integer: fromIndex),
                toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex
            )
        }
    }

    func performDrop(info _: DropInfo) -> Bool {
        draggedItem = nil
        haptic(.success)
        return true
    }
}

private extension BookmarksListView {
    func deleteBookmark(bookmark: Bookmarks) {
        withAnimation(.spring(response: 0.35)) {
            bookmarks.removeAll { $0.id == bookmark.id }
        }
    }

    func addBookmark() {
        let newBookmark = Bookmarks(
            movieId: currWindow.movieId ?? "default",
            profile: "Andre"
        )
        withAnimation(.spring(response: 0.35)) {
            bookmarks.insert(newBookmark, at: 0)
        }
    }
}

struct BookmarkCard: View {
    let bookmark: Bookmarks
    @Binding var currWindow: WindowType
    @Binding var hoveredBookmarkIDs: Set<UUID>
    @Binding var draggedItem: Bookmarks?
    let movies: [Movie]
    let onDelete: () -> Void

    private var movieInfo: Movie? {
        movies.first { $0.id == bookmark.movieId }
    }

    private var isHovered: Bool {
        hoveredBookmarkIDs.contains(bookmark.id)
    }

    private var isActive: Bool {
        currWindow.id == bookmark.id && currWindow.type == "movie"
    }

    private var isDragging: Bool {
        draggedItem?.id == bookmark.id
    }

    var body: some View {
        ZStack {
            if isActive {
                KFImage(movieInfo?.posterURL)
                    .placeholder { Color.gray.opacity(0.2) }
                    .resizable()
                    .scaledToFill()
                    .frame(width: 72, height: 104)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .blur(radius: 12)
                    .brightness(-0.2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(.white.opacity(0.15), lineWidth: 1)
                    )
                    .zIndex(-1)
            }

            Button {
                withAnimation(.spring(response: 0.32)) {
                    currWindow = WindowType(
                        id: bookmark.id,
                        type: "movie",
                        movieId: bookmark.movieId
                    )
                }
            } label: {
                VStack(spacing: 0) {
                    KFImage(movieInfo?.posterURL)
                        .placeholder {
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.white.opacity(0.12))
                                ProgressView()
                                    .progressViewStyle(.circular)
                                    .tint(.white.opacity(0.6))
                            }
                            .frame(width: 72, height: 104)
                        }
                        .resizable()
                        .scaledToFill()
                        .frame(width: 72, height: 104)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(.white.opacity(isHovered ? 0.3 : 0.1), lineWidth: 1.5)
                        )
                }
                .frame(width: 72, height: 110)
            }
            .buttonStyle(.plain)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(.ultraThinMaterial.opacity(isHovered ? 1.0 : 0.8))
            )
            .scaleEffect(isHovered ? 1.06 : 1.0)
            .shadow(
                color: .black.opacity(isHovered ? 0.35 : 0.18),
                radius: isHovered ? 14 : 8
            )
        }
        .overlay(alignment: .topTrailing) {
            if isHovered {
                Button(action: onDelete) {
                    Image(systemName: "xmark")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.white.opacity(0.95))
                        .frame(width: 20, height: 20)
                        .background(Circle().fill(.black.opacity(0.7)))
                }
                .buttonStyle(.borderless)
                .offset(x: 6, y: -6)
                .scaleEffect(isHovered ? 1.0 : 0.9)
                .animation(.spring(response: 0.22), value: isHovered)
            }
        }
        .onHover { hovering in
            withAnimation(.spring(response: 0.25)) {
                if hovering {
                    hoveredBookmarkIDs.insert(bookmark.id)
                } else {
                    hoveredBookmarkIDs.remove(bookmark.id)
                }
            }
        }
        .opacity(isDragging ? 0 : 1)
    }
}

#Preview {
    BookmarksListPreview()
}

struct BookmarksListPreview: View {
    @State private var bookmarks: [Bookmarks]
    @State private var currWindow: WindowType

    private let movies = Movie.examplesMovie()

    init() {
        let bookmarksData = Bookmarks.examplesBookmarks()

        _bookmarks = State(initialValue: bookmarksData)

        _currWindow = State(
            initialValue: WindowType(
                id: bookmarksData.first!.id,
                type: "movie",
                movieId: bookmarksData.first!.movieId
            )
        )
    }

    var body: some View {
        BookmarksListView(
            currWindow: $currWindow,
            bookmarks: $bookmarks,
            movies: movies
        )
        .padding()
    }
}
