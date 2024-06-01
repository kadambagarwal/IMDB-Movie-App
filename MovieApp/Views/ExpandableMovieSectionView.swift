//
//  ExpandableMovieSectionView.swift
//  MovieApp
//
//  Created by kadagarw on 01/06/24.
//

import SwiftUI

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
        self.loadMovies(endpoint)
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
    }
}
