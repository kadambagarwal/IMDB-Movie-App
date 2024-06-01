//
//  MovieService.swift
//  MovieApp
//
//  Created by kadagarw on 01/06/24.
//

import Foundation

class MovieService: ObservableObject {
    @Published var trendingMovies = [Movie]()
    @Published var nowPlayingMovies = [Movie]()
    @Published var popularMovies = [Movie]()
    @Published var topRatedMovies = [Movie]()
    private let movieDatabase = MovieDatabase()
    
    func loadMovies(timePeriod: String, endpoint: MovieEndpoint) {
        movieDatabase.fetchMovies(endpoint: endpoint) { result in
            switch result {
            case .success(let movieResponse):
                DispatchQueue.main.async {
                    switch endpoint {
                    case .trendingToday, .trendingThisWeek:
                        self.trendingMovies = movieResponse.results
                    case .nowPlaying:
                        self.nowPlayingMovies = movieResponse.results
                    case .popular:
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
