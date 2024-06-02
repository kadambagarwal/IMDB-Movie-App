//
//  MyPlaylistsView.swift
//  MovieApp
//
//  Created by kadagarw on 02/06/24.
//
import SwiftUI
import Kingfisher

/// `MyPlaylistsView` is a SwiftUI view that displays a list of the user's playlists.
///
/// The view includes a navigation view with a list of playlists. Each playlist is a navigation link that leads to a `PlaylistDetailView`.
/// The `init` method initializes the view.
/// The `body` property defines the UI and the behavior of the view.
struct MyPlaylistsView: View {
    @ObservedObject var playlistManager = PlaylistManager()
    var body: some View {
        NavigationView {
            List {
                ForEach(playlistManager.playlists, id: \.id) { playlist in
                    NavigationLink(destination: PlaylistDetailView(playlist: playlist)) {
                        Text(playlist.name)
                            .font(.headline)
                    }
                }
            }
            .navigationBarTitle("My Playlists")
            .onAppear {
                playlistManager.fetchPlaylists()
            }
        }
    }
}

/// `PlaylistDetailView` is a SwiftUI view that displays the details of a playlist, including a list of movies.
///
/// The view includes a list of movies in the playlist. Each movie is displayed with its poster, title, and rating.
/// The `init` method initializes the view with a `Playlist` object.
/// The `body` property defines the UI and the behavior of the view.
struct PlaylistDetailView: View {
    private let imageBaseUrl = "https://image.tmdb.org/t/p/w500"
    @ObservedObject var playlist: Playlist
    @ObservedObject var playlistManager = PlaylistManager()
    @State private var updatedPlaylist: Playlist?
    
    var body: some View {
        List {
            ForEach(updatedPlaylist?.movies ?? playlist.movies, id: \.id) { movie in
                HStack {
                    ZStack(alignment: .bottomLeading) {
                        if let url = URL(string: "\(imageBaseUrl)\(movie.poster_path)") {
                            KFImage(url)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 150)
                        }
                        RatingView(value: movie.vote_average / 10.0)
                            .padding(4)
                    }
                    VStack(alignment: .leading) {
                        Text(movie.title)
                            .bold()
                        Text("Rating: \(movie.vote_average, specifier: "%.1f")")
                    }
                }
            }
        }
        .navigationBarTitle(playlist.name)
        .onAppear {
            updatedPlaylist = playlistManager.fetchPlaylist(id: playlist.id)
        }
    }
}
