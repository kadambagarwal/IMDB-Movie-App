//
//  PlaylistManager.swift
//  MovieApp
//
//  Created by kadagarw on 02/06/24.
//
import RealmSwift
import Foundation

/// `PlaylistManager` is a class that provides methods for managing playlists in a Realm database.
///
/// It includes methods for adding a movie to a playlist, creating a new playlist, fetching all playlists, fetching a specific playlist, and converting a `Movie` object to a `PlaylistMovie` object.
class PlaylistManager: ObservableObject {
    let realm = try! Realm()
    @Published var playlists: [Playlist] = []
    
    /// The `addMovieToPlaylist` method adds a `PlaylistMovie` object to an existing playlist with a specific ID.
    func addMovieToPlaylist(playlistId: String, movie: PlaylistMovie) {
        if let playlist = realm.object(ofType: Playlist.self, forPrimaryKey: playlistId) {
            try! realm.write {
                playlist.movies.append(movie)
            }
        }
    }
    
    /// The `createPlaylist` method creates a new playlist with a specific name and a `PlaylistMovie` object.
    func createPlaylist(name: String, movie: PlaylistMovie) {
        let playlist = Playlist()
        playlist.name = name
        try! realm.write {
            playlist.movies.append(movie)
            realm.add(playlist)
        }
    }
    
    /// The `getAllPlaylists` method returns all playlists in the database.
    func getAllPlaylists() -> Results<Playlist> {
        return realm.objects(Playlist.self)
    }
    
    /// The `fetchPlaylists` method fetches all playlists from the database and assigns them to the `playlists` property.
    func fetchPlaylists() {
        let results = realm.objects(Playlist.self)
        playlists = Array(results)
    }
    
    /// The `fetchPlaylist` method fetches a playlist with a specific ID from the database.
    func fetchPlaylist(id: String) -> Playlist? {
        return realm.object(ofType: Playlist.self, forPrimaryKey: id)
    }
    
    /// The `movieToPlaylistMovie` method converts a `Movie` object to a `PlaylistMovie` object.
    func movieToPlaylistMovie(movie: Movie) -> PlaylistMovie {
        let playlistMovie = PlaylistMovie()
        playlistMovie.title = movie.title
        playlistMovie.vote_average = movie.vote_average
        playlistMovie.poster_path = movie.poster_path ?? ""
        return playlistMovie
    }
}
