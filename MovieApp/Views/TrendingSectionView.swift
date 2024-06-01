//
//  MovieSectionView.swift
//  MovieApp
//
//  Created by kadagarw on 01/06/24.
//

import SwiftUI

struct TrendingSectionView: View {
    var title: String
    @Binding var movies: [Movie]
    @State private var timePeriod = TrendingTimePeriod.day
    var loadMovies: (MovieEndpoint,TrendingTimePeriod) -> Void
    
    init(title: String, movies: Binding<[Movie]>, loadMovies: @escaping (MovieEndpoint, TrendingTimePeriod) -> Void) {
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
                    Text("Today").tag(TrendingTimePeriod.day)
                    Text("This week").tag(TrendingTimePeriod.week)
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 150)
                .onChange(of: timePeriod, perform: { value in
                    loadMovies(.trending, value)
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
        .onAppear {
            loadMovies(.trending, timePeriod)
        }
    }
}
