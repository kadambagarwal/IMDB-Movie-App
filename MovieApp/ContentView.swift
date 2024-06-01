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
    @State private var nowPlayingMovies = [Movie]()
    @State private var popularMovies = [Movie]()
    @State private var topRatedMovies = [Movie]()
    private let imageBaseUrl = "https://image.tmdb.org/t/p/w500"
    private let movieDatabase = MovieDatabase()
    
    var body: some View {
        ScrollView {
            VStack {
                MovieSectionView(title: "Trending", movies: $trendingMovies, loadMovies: { timePeriod in
                                    let endpoint: MovieEndpoint = timePeriod == "Day" ? .trendingToday : .trendingThisWeek
                                    self.loadMovies(timePeriod: timePeriod, endpoint: endpoint)
                                })
                ExpandableMovieSectionView(title: "Now Playing", movies: $nowPlayingMovies, loadMovies: loadMovies, endpoint: .nowPlaying)
                ExpandableMovieSectionView(title: "Popular", movies: $popularMovies, loadMovies: loadMovies, endpoint: .popular)
                ExpandableMovieSectionView(title: "Top Rated", movies: $topRatedMovies, loadMovies: loadMovies, endpoint: .topRated)
            }
        }
        .onAppear(perform: { loadMovies(timePeriod: "Day", endpoint: .trendingToday) })
    }
    
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

struct ExpandableMovieSectionView: View {
    var title: String
    @Binding var movies: [Movie]
    var loadMovies: (String, MovieEndpoint) -> Void
    var endpoint: MovieEndpoint
    @State private var isExpanded = false
    
    init(title: String, movies: Binding<[Movie]>, loadMovies: @escaping (String, MovieEndpoint) -> Void, endpoint: MovieEndpoint) {
        self.title = title
        self._movies = movies
        self.loadMovies = loadMovies
        self.endpoint = endpoint
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .font(.title2)
                    .bold()
                Spacer()
                Button(action: {
                    isExpanded.toggle()
                    if isExpanded {
                        loadMovies("Day", endpoint)
                    }
                }) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                }
            }
            .padding(.horizontal)
            
            if isExpanded {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 20) {
                        ForEach(movies) { movie in
                            MovieCardView(movie: movie)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .shadow(radius: 10)
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
                .onChange(of: timePeriod, perform: { value in
                                    loadMovies(value)
                                })
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
