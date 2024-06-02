//
//  MyPlaylistsView.swift
//  MovieApp
//
//  Created by kadagarw on 02/06/24.
//
import SwiftUI
import Kingfisher

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
