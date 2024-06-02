//
//  PlaylistManager.swift
//  MovieApp
//
//  Created by kadagarw on 02/06/24.
//
import RealmSwift
import Foundation

class PlaylistManager: ObservableObject {
    let realm = try! Realm()
    @Published var playlists: [Playlist] = []
    
    func addMovieToPlaylist(playlistId: String, movie: PlaylistMovie) {
        if let playlist = realm.object(ofType: Playlist.self, forPrimaryKey: playlistId) {
            try! realm.write {
                playlist.movies.append(movie)
            }
        }
    }

    func createPlaylist(name: String, movie: PlaylistMovie) {
        let playlist = Playlist()
        playlist.name = name
        try! realm.write {
            playlist.movies.append(movie)
            realm.add(playlist)
        }
    }

    func getAllPlaylists() -> Results<Playlist> {
        return realm.objects(Playlist.self)
    }
    
    func fetchPlaylists() {
            let results = realm.objects(Playlist.self)
            playlists = Array(results)
    }
    func fetchPlaylist(id: String) -> Playlist? {
            return realm.object(ofType: Playlist.self, forPrimaryKey: id)
    }
    
    func movieToPlaylistMovie(movie: Movie) -> PlaylistMovie {
        let playlistMovie = PlaylistMovie()
        playlistMovie.title = movie.title
        playlistMovie.vote_average = movie.vote_average
        playlistMovie.poster_path = movie.poster_path ?? ""
        return playlistMovie
    }
}
