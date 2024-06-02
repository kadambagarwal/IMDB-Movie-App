//
//  PlaylistDatabase.swift
//  MovieApp
//
//  Created by kadagarw on 02/06/24.
//
import RealmSwift
import Foundation

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

class Playlist: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    let movies = List<PlaylistMovie>()

    override static func primaryKey() -> String? {
        return "id"
    }
}

