//
//  AddToPlaylistView.swift
//  MovieApp
//
//  Created by kadagarw on 02/06/24.
//

import SwiftUI

struct AddToPlaylistView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedPlaylistIndex = 0
    @State private var newPlaylistName = ""
    var movie: Movie
    let playlistManager = PlaylistManager()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Movie")) {
                    Text(movie.title)
                }
                Section(header: Text("Add to Existing Playlist")) {
                    Picker("Pick a playlist", selection: $selectedPlaylistIndex) {
                        ForEach(0..<playlistManager.getAllPlaylists().count) {
                            Text(self.playlistManager.getAllPlaylists()[$0].name)
                        }
                    }
                    Button("Add to Playlist") {
                        let playlist = playlistManager.getAllPlaylists()[selectedPlaylistIndex]
                            let playlistMovie = playlistManager.movieToPlaylistMovie(movie: movie)
                            playlistManager.addMovieToPlaylist(playlistId: playlist.id, movie: playlistMovie)
                            presentationMode.wrappedValue.dismiss()
                    }
                }
                Section(header: Text("Create New Playlist")) {
                    TextField("Enter Playlist Name", text: $newPlaylistName)
                    Button("Create Playlist") {
                        let playlistMovie = playlistManager.movieToPlaylistMovie(movie: movie)
                        playlistManager.createPlaylist(name: newPlaylistName, movie: playlistMovie)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .navigationBarTitle("Add to Playlist", displayMode: .inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
