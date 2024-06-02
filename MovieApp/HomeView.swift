//
//  ContentView.swift
//  MovieApp
//
//  Created by kadagarw on 31/05/24.
//
import SwiftUI

/// MainView is the root view of the application. It contains a TabView with two tabs: HomeView and MyPlaylistsView.
struct MainView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            
            MyPlaylistsView()
                .tabItem {
                    Image(systemName: "music.note.list")
                    Text("My Playlists")
                }
        }
    }
}

/// HomeView displays a list of movies in different categories: Trending, Now Playing, Upcoming, and Top Rated.
/// It uses the MovieService to fetch the movies from an API.
struct HomeView: View {
    @ObservedObject private var movieService = MovieService()
    
    var body: some View {
        ScrollView {
            VStack {
                TrendingSectionView(title: "Trending", movies: $movieService.trendingMovies, loadMovies: movieService.loadMovies)
                SectionSpacer()
                ExpandableMovieSectionView(title: "Now Playing", movies: $movieService.nowPlayingMovies, loadMovies: movieService.loadMovies, endpoint: .nowPlaying)
                SectionSpacer()
                ExpandableMovieSectionView(title: "Upcoming", movies: $movieService.popularMovies, loadMovies: movieService.loadMovies, endpoint: .upcoming)
                SectionSpacer()
                ExpandableMovieSectionView(title: "Top Rated", movies: $movieService.topRatedMovies, loadMovies: movieService.loadMovies, endpoint: .topRated)
            }
        }
    }
}

/// SectionSpacer is a helper view that provides a fixed amount of spacing between sections.
struct SectionSpacer: View {
    var body: some View {
        Spacer().frame(height: 20)
    }
}

/// MainView_Previews provides a preview of the MainView for the Xcode canvas.
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
