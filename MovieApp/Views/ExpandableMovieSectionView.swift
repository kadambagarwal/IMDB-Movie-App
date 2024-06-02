//
//  ExpandableMovieSectionView.swift
//  MovieApp
//
//  Created by kadagarw on 01/06/24.
//

import SwiftUI

/// `ExpandableMovieSectionView` is a SwiftUI view that displays a list of movies in a specific category (Upcoming/Top Rated/Now Playing).
///
/// It includes a title, a button for expanding and collapsing the section, and a horizontal scroll view that displays the movies in a lazy horizontal stack.
///
/// The `loadMovies` function is called when the view appears and whenever the section is expanded.
/// This function should fetch the movies for the specified endpoint and update the `movies` binding.
///
/// The `init` method initializes the view with a title, a binding to the movies array, a function for loading the movies, and an endpoint for fetching the movies.
struct ExpandableMovieSectionView: View {
    var title: String
    @Binding var movies: [Movie]
    var loadMovies: (MovieEndpoint) -> Void
    var endpoint: MovieEndpoint
    @State private var isExpanded = true
    
    init(title: String, movies: Binding<[Movie]>, loadMovies: @escaping (MovieEndpoint) -> Void, endpoint: MovieEndpoint) {
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
                        loadMovies(endpoint)
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
        .onAppear {
            loadMovies(endpoint)
        }
    }
}
