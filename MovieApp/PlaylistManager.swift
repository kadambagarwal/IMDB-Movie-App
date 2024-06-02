//
//  PlaylistManager.swift
//  MovieApp
//
//  Created by kadagarw on 02/06/24.
//
import RealmSwift

class PlaylistManager {
    let realm = try! Realm()

    func addMovieToPlaylist(playlistId: String, movie: PlaylistMovie) {
        if let playlist = realm.object(ofType: Playlist.self, forPrimaryKey: playlistId) {
            try! realm.write {
                playlist.movies.append(movie)
            }
        }
    }

    func createPlaylist(name: String) {
        let playlist = Playlist()
        playlist.name = name

        try! realm.write {
            realm.add(playlist)
        }
    }

    func getAllPlaylists() -> Results<Playlist> {
        return realm.objects(Playlist.self)
    }
    
    func movieToPlaylistMovie(movie: Movie) -> PlaylistMovie {
        let playlistMovie = PlaylistMovie()
        playlistMovie.title = movie.title
        playlistMovie.vote_average = movie.vote_average
        playlistMovie.poster_path = movie.poster_path ?? ""
        return playlistMovie
    }
}
