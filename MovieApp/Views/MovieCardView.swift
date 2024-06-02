//
//  MovieCardView.swift
//  MovieApp
//
//  Created by kadagarw on 01/06/24.
//

import SwiftUI
import Kingfisher

/// `MovieCardView` is a SwiftUI view that displays a movie card with a poster, title, and rating.
///
/// It includes a context menu that allows the user to add the movie to a playlist.
/// When the "Add to Playlist" button is clicked, an `AddToPlaylistView` is presented.
///
/// The `init` method initializes the view with a `Movie` object.
/// The `body` property defines the UI and the behavior of the view.
struct MovieCardView: View {
    @State private var showSheet = false
    var movie: Movie
    private let imageBaseUrl = "https://image.tmdb.org/t/p/w500"
    
    var body: some View {
        VStack {
            if let posterPath = movie.poster_path, let url = URL(string: "\(imageBaseUrl)\(posterPath)") {
                VStack {
                    ZStack(alignment: .bottomLeading) {
                        KFImage(url)
                            .resizable()
                            .scaledToFill()
                            .frame(width: (UIScreen.main.bounds.width - 100) / 3, height: 180)
                            .clipped()
                            .cornerRadius(10)
                            .shadow(radius: 10)
                            .contextMenu {
                                Button(action: {
                                    showSheet = true
                                }) {
                                    Text("Add to Playlist")
                                    Image(systemName: "plus")
                                }
                            }
                        RatingView(value: movie.vote_average / 10)
                            .padding(4)
                            .offset(y: 20)
                    }
                    .padding(.bottom, 20)
                    Text(movie.title)
                        .font(.system(size: 14))
                        .bold()
                        .lineLimit(2)
                        .frame(width: (UIScreen.main.bounds.width - 100) / 3, height: 40, alignment: .leading)
                }
            }
        }
        .sheet(isPresented: $showSheet) {
            AddToPlaylistView(movie: movie)
        }
    }
}
