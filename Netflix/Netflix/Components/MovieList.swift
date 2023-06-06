//
//  MovieList.swift
//  Netflix
//
//  Created by digital on 17/04/2023.
//

import Foundation
import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    @Binding var selectedGenre: Genre?
    @EnvironmentObject var movieViewModel: MovieViewModel
    
    var body: some View {
        HStack {
            TextField("movie.search", text: $text)
                .padding(8)
                .background(Color(.systemGray5))
                .cornerRadius(8)
                .padding(.horizontal, 8)
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                    movieViewModel.fetchMoviesByQuery(query: text)
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .imageScale(.medium)
                }
            }
            
            Button(action: {
                selectedGenre = Genre(id: -1, name: "movie.all_genres")
                movieViewModel.fetchMoviesByQuery(query: text)
            }) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .imageScale(.medium)
            }
        }
    }
}


struct MovieListView: View {
    @State private var searchText = ""
    @State private var showShareSheet = false
    @State private var selectedGenre: Genre?
    @EnvironmentObject var movieViewModel: MovieViewModel
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText, selectedGenre: $selectedGenre)
                    .environmentObject(movieViewModel)
                Picker("Genre", selection: $selectedGenre) {
                        Text("movie.all_genres").tag(Genre(id: -1, name: "movie.all_genres") as Genre?)
                        ForEach(movieViewModel.genres) { genre in
                            Text(genre.name ?? "").tag(genre as Genre?)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: selectedGenre) { genre in
                        if let genre = genre, genre.id != -1 {
                            searchText = ""
                            movieViewModel.fetchMoviesByGenres(genre:genre)
                        } else {
                            movieViewModel.fetchMovies()
                        }
                    }
                List {
                    ForEach(movieViewModel.movies) { movie in
                        NavigationLink(destination: MovieDetailView(movieID: movie.idApi)) {
                            HStack {
                                AsyncImage(url: URL(string: movie.poster), content: { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 70, height: 100)
                                        .clipped()
                                }, placeholder: {
                                    RoundedRectangle(cornerRadius: 5)
                                        .frame(width: 70, height: 100)
                                        .foregroundColor(.gray.opacity(0.3))
                                })
                                
                                VStack(alignment: .leading) {
                                    Text(movie.title)
                                        .font(.headline)
                                    Text(movie.releaseYear)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                }
                HStack {
                    Button(action: {
                        movieViewModel.fetchPreviousPage()
                    }) {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .frame(width: 10, height: 10)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                    }
                    .disabled(movieViewModel.page == 1)

                    Spacer()

                    Button(action: {
                        movieViewModel.fetchNextPage()
                    }) {
                        Image(systemName: "chevron.right")
                            .resizable()
                            .frame(width: 10, height: 10)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
            }
            .navigationBarTitle(Text("movie.title"))
        }
        .onAppear {
            movieViewModel.fetchMovies()
            movieViewModel.fetchGenres()
        }
    }
}




struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        let movieViewModel = MovieViewModel()
        movieViewModel.movies = [
        ]
        return MovieListView().environmentObject(movieViewModel)
    }
}

