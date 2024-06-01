//
//  ContentView.swift
//  MovieApp
//
//  Created by kadagarw on 31/05/24.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject private var movieService = MovieService()
    
    var body: some View {
        ScrollView {
            VStack {
                TrendingSectionView(title: "Trending", movies: $movieService.trendingMovies, loadMovies: movieService.loadMovies)
                SectionSpacer()
                ExpandableMovieSectionView(title: "Now Playing", movies: $movieService.nowPlayingMovies, loadMovies: movieService.loadMovies, endpoint: .nowPlaying)
                SectionSpacer()
                ExpandableMovieSectionView(title: "Upcoming", movies: $movieService.popularMovies, loadMovies: movieService.loadMovies, endpoint: .popular)
                SectionSpacer()
                ExpandableMovieSectionView(title: "Top Rated", movies: $movieService.topRatedMovies, loadMovies: movieService.loadMovies, endpoint: .topRated)
            }
        }
    }
}

struct SectionSpacer: View {
    var body: some View {
        Spacer().frame(height: 20)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
