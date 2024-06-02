//
//  MovieDatabase.swift
//  MovieApp
//
//  Created by kadagarw on 31/05/24.
//

import Foundation

/// `Movie` is a Codable and Identifiable struct that represents a movie.
///
/// It includes properties for the movie's ID, title, vote average, and poster path.
struct Movie: Codable, Identifiable {
    let id: Int
    let title: String
    let vote_average: Double
    let poster_path: String?
}

/// `MovieResponse` is a Codable struct that represents a response from the movie database API.
///
/// It includes a property for an array of `Movie` objects.
struct MovieResponse: Codable {
    let results: [Movie]
}

/// `MovieEndpoint` is an enum that represents the different endpoints of the movie database API.
enum MovieEndpoint: String {
    case upcoming = "upcoming"
    case nowPlaying = "now_playing"
    case topRated = "top_rated"
    case trending = "trending"
}

/// `TrendingTimePeriod` is an enum that represents the different time periods for the trending endpoint of the movie database API.
enum TrendingTimePeriod: String {
    case day = "day"
    case week = "week"
}

/// `MovieDatabaseError` is an enum that represents the different errors that can occur when interacting with the movie database API.
enum MovieDatabaseError: Error {
    case invalidURL
}

/// `MovieDatabase` is a class that provides methods for fetching movies from the movie database API.
///
/// It includes a method for fetching movies from a specific endpoint and a specific time period (for the trending endpoint).
final class MovieDatabase {
    private let apiKey = "c77a451f55684047265eed8393fe387d"
    private let baseUrl = "https://api.themoviedb.org/3"
    
    func fetchMovies(endpoint: MovieEndpoint, timePeriod: TrendingTimePeriod?, completion: @escaping (Result<MovieResponse, Error>) -> Void) {
        let urlString: String
        switch endpoint {
        case .trending:
            guard let timePeriod = timePeriod else {return}
            urlString = "\(baseUrl)/\(endpoint.rawValue)/movie/\(timePeriod.rawValue)?api_key=\(apiKey)"
        default:
            urlString = "\(baseUrl)/movie/\(endpoint.rawValue)?api_key=\(apiKey)"
        }
        guard let url = URL(string: urlString) else {
            completion(.failure(MovieDatabaseError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(MovieDatabaseError.invalidURL))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let decodedResponse = try decoder.decode(MovieResponse.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
