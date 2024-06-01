//
//  MovieDatabase.swift
//  MovieApp
//
//  Created by kadagarw on 31/05/24.
//

import Foundation

struct Movie: Codable, Identifiable {
    let id: Int
    let title: String
    let vote_average: Double
    let poster_path: String?
}

struct MovieResponse: Codable {
    let results: [Movie]
}

enum MovieEndpoint: String {
    case popular = "popular"
    case nowPlaying = "now_playing"
    case topRated = "top_rated"
    case trendingToday = "trending/movie/day"
    case trendingThisWeek = "trending/movie/week"
}

enum MovieDatabaseError: Error {
    case invalidURL
}

final class MovieDatabase {
    private let apiKey = "c77a451f55684047265eed8393fe387d"
    private let baseUrl = "https://api.themoviedb.org/3"
    
    func fetchMovies(endpoint: MovieEndpoint, completion: @escaping (Result<MovieResponse, Error>) -> Void) {
        let urlString: String
        switch endpoint {
        case .trendingToday, .trendingThisWeek:
            urlString = "\(baseUrl)/\(endpoint.rawValue)?api_key=\(apiKey)"
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
