//
//  MovieService.swift
//  MovieApp
//
//  Created by kadagarw on 01/06/24.
//

import Foundation

/// `MovieService` is a class that provides methods for loading movies from different endpoints of the movie database API.
///
/// It includes properties for trending movies, now playing movies, popular movies, and top rated movies. These properties are marked with the `@Published` property wrapper, which means they can be used to create bindings in SwiftUI views.
class MovieService: ObservableObject {
    @Published var trendingMovies = [Movie]()
    @Published var nowPlayingMovies = [Movie]()
    @Published var popularMovies = [Movie]()
    @Published var topRatedMovies = [Movie]()
    private let movieDatabase = MovieDatabase()
    
    /// The `loadMovies` method loads movies from a specific endpoint. If the endpoint is the trending endpoint, a time period can be specified.
    func loadMovies(endpoint: MovieEndpoint) {
        loadMovies(endpoint: endpoint, timePeriod: nil)
    }
    
    /// The `loadMovies` method makes a request to the movie database API, decodes the response into a `MovieResponse` object, and assigns the movies to the appropriate property based on the endpoint. If an error occurs, it is printed to the console.
    func loadMovies(endpoint: MovieEndpoint, timePeriod: TrendingTimePeriod?) {
        movieDatabase.fetchMovies(endpoint: endpoint, timePeriod: timePeriod) { result in
            switch result {
            case .success(let movieResponse):
                DispatchQueue.main.async {
                    switch endpoint {
                    case .trending:
                        self.trendingMovies = movieResponse.results
                    case .nowPlaying:
                        self.nowPlayingMovies = movieResponse.results
                    case .upcoming:
                        self.popularMovies = movieResponse.results
                    case .topRated:
                        self.topRatedMovies = movieResponse.results
                    }
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}
