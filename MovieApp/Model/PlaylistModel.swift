//
//  PlaylistDatabase.swift
//  MovieApp
//
//  Created by kadagarw on 02/06/24.
//
import RealmSwift
import Foundation

/// `PlaylistMovie` is a Realm model class that represents a movie in a playlist.
///
/// It includes properties for the movie's ID, title, vote average, and poster path.
/// It also includes a `LinkingObjects` collection for the playlists that the movie is a part of.
///
/// The `primaryKey` method returns the name of the primary key property.
class PlaylistMovie: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var title = ""
    @objc dynamic var vote_average = 0.0
    @objc dynamic var poster_path = ""
    
    let playlists = LinkingObjects(fromType: Playlist.self, property: "movies")
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

/// `Playlist` is a Realm model class that represents a playlist.
///
/// It includes properties for the playlist's ID and name, and a `List` collection for the movies in the playlist.
///
/// The `primaryKey` method returns the name of the primary key property.
class Playlist: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    let movies = List<PlaylistMovie>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

