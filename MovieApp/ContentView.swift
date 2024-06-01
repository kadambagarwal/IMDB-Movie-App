//
//  ContentView.swift
//  MovieApp
//
//  Created by kadagarw on 31/05/24.
//

import SwiftUI
import Kingfisher

struct MovieView: View {
    @State private var trendingMovies = [Movie]()
    private let imageBaseUrl = "https://image.tmdb.org/t/p/w500"
    private let movieDatabase = MovieDatabase()
    
    var body: some View {
        ScrollView {
            VStack {
                MovieSectionView(title: "Trending", movies: $trendingMovies, loadMovies: loadTrendingMovies)
            }
        }
        .onAppear(perform: { loadTrendingMovies(timePeriod: "Day") })
    }
    
    func loadTrendingMovies(timePeriod: String) {
        let endpoint: MovieEndpoint = timePeriod == "Day" ? .trendingToday : .trendingThisWeek
        movieDatabase.fetchMovies(endpoint: endpoint) { result in
            switch result {
            case .success(let movieResponse):
                DispatchQueue.main.async {
                    self.trendingMovies = movieResponse.results
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}

struct MovieSectionView: View {
    var title: String
    @Binding var movies: [Movie]
    @State private var timePeriod = "Day"
    var loadMovies: (String) -> Void
    
    init(title: String, movies: Binding<[Movie]>, loadMovies: @escaping (String) -> Void) {
        self.title = title
        self._movies = movies
        self.loadMovies = loadMovies
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor.systemTeal
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().backgroundColor = UIColor.white
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .font(.title2)
                    .bold()
                Spacer()
                Picker("", selection: $timePeriod) {
                    Text("Today").tag("Day")
                    Text("This week").tag("Week")
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 150)
                .onChange(of: timePeriod, perform: loadMovies)
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 20) {
                    ForEach(movies) { movie in
                        MovieCardView(movie: movie)
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}

struct MovieCardView: View {
    var movie: Movie
    private let imageBaseUrl = "https://image.tmdb.org/t/p/w500"
    
    var body: some View {
        if let posterPath = movie.poster_path, let url = URL(string: "\(imageBaseUrl)\(posterPath)") {
            VStack {
                KFImage(url)
                    .resizable()
                    .scaledToFill()
                    .frame(width: (UIScreen.main.bounds.width - 100) / 3, height: 180) // Adjust the width here
                    .clipped()
                    .cornerRadius(10)
                    .shadow(radius: 10)
                Text(movie.title)
                    .font(.system(size: 14))
                    .bold() // Make the title bold
                    .lineLimit(2)
                    .frame(width: (UIScreen.main.bounds.width - 100) / 3, height: 40, alignment: .leading) // Adjust the width here
            }
        }
    }
}

struct MovieView_Previews: PreviewProvider {
    static var previews: some View {
        MovieView()
    }
}
