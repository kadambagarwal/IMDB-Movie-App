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
                ZStack(alignment: .bottomLeading) {
                    KFImage(url)
                        .resizable()
                        .scaledToFill()
                        .frame(width: (UIScreen.main.bounds.width - 100) / 3, height: 180)
                        .clipped()
                        .cornerRadius(10)
                        .shadow(radius: 10)
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
}

struct RatingView: View {
    var value: Double
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: 40, height: 40)
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.value, 1.0)))
                .stroke(value >= 0.7 ? Color.green : (value >= 0.4 ? Color.yellow : Color.red), style: StrokeStyle(lineWidth: 6, lineCap: .round))
                .rotationEffect(Angle(degrees: -90))
                .frame(width: 40, height: 40)
            Text(String(format: "%.1f", min(self.value, 1.0)*10.0))
                .font(.footnote)
                .bold()
        }
    }
}
