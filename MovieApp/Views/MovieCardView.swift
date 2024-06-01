//
//  MovieCardView.swift
//  MovieApp
//
//  Created by kadagarw on 01/06/24.
//

import SwiftUI
import Kingfisher

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
