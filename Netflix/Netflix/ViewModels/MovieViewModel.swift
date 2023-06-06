//
//  MovieViewModel.swift
//  Netflix
//
//  Created by digital on 17/04/2023.
//

import Foundation

class MovieViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var genres: [Genre] = []
    var lastUrl = ""
    var page = 1
    private let baseURL = "https://api.themoviedb.org/3/movie/"
    private let searchURL = "https://api.themoviedb.org/3/search/movie"
    private let searchGenresURL = "https://api.themoviedb.org/3/discover/movie"
    private let genreURL = "https://api.themoviedb.org/3/genre/movie/list"
    private let apiKey = "9a8f7a5168ace33d2334ba1fe14a83fb"
    private let language = Locale.preferredLanguages[0]
    
    func fetchMovies() {
        let movieURL = "\(self.baseURL)now_playing?api_key=\(self.apiKey)&language=\(self.language)"
        self.lastUrl = movieURL
        self.page = 1
        self.fetchListMovie(urlString: movieURL)
    }
    
    func fetchGenres() {
        let genresURL = "\(self.genreURL)?api_key=\(self.apiKey)&language=\(self.language)"
        guard let url = URL(string: genresURL) else {
            print("Invalid URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                        print("Failed to fetch data: \(error?.localizedDescription ?? "Unknown error")")
                        return
                    }
                let decoder = JSONDecoder()

                do {
                    let decodedResponse = try decoder.decode(DTOGenres.self, from: data)
                    DispatchQueue.main.async {
                        self.genres = decodedResponse.genres.map { Genre(from: $0) }
                    }
                } catch {
                    print("Failed to decode JSON: \(error)")
                }
        }

        task.resume()
    }
    
    func fetchMovieDetails(id: Int, completion: @escaping (Movie?) -> Void) {
        let movieDetailsURL = "\(self.baseURL)\(id)?api_key=\(self.apiKey)&language=\(self.language)"

        guard let url = URL(string: movieDetailsURL) else {
            print("Invalid URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                        print("Failed to fetch data: \(error?.localizedDescription ?? "Unknown error")")
                        DispatchQueue.main.async {
                            completion(nil)
                        }
                        return
                    }
                let decoder = JSONDecoder()

                do {
                    let dtoMovie = try decoder.decode(DTOMovie.self, from: data)
                    var movie = Movie(from: dtoMovie)
                    
                    // Fetch trailer information and update movie object
                    let trailerURL = "\(self.baseURL)\(id)/videos?api_key=\(self.apiKey)&language=\(self.language)"
                    guard let url = URL(string: trailerURL) else {
                        print("Invalid URL for trailer")
                        DispatchQueue.main.async {
                            completion(nil)
                        }
                        return
                    }
                    URLSession.shared.dataTask(with: url) { data, response, error in
                        if let data = data {
                            do {
                                let dtoTrailer = try decoder.decode(DTOTrailer.self, from: data)
                                if let trailer = dtoTrailer.results.filter({ $0.site == "YouTube" }).first {
                                    movie.link += trailer.key
                                }
                            } catch {
                                print("Failed to decode trailer JSON: \(error)")
                            }
                        } else {
                            print("Failed to fetch trailer data: \(error?.localizedDescription ?? "Unknown error")")
                        }
                        DispatchQueue.main.async {
                            completion(movie)
                        }
                    }.resume()
                    
                } catch {
                    print("Failed to decode JSON: \(error)")
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            
        }

        task.resume()
    }
    
    func fetchMoviesByQuery(query: String) {
        if query.isEmpty{
            fetchMovies()
            return
        }
        let newQuery = query.replacingOccurrences(of: " ", with: "+")
        let movieURL = "\(self.searchURL)?api_key=\(self.apiKey)&language=\(self.language)&query=\(newQuery)"
        self.lastUrl = movieURL
        self.page = 1
        self.fetchListMovie(urlString: movieURL)
    }
    
    func fetchMoviesByGenres(genre: Genre) {
        let genreString = genre.id ?? 0
        let movieURL = "\(self.searchGenresURL)?api_key=\(self.apiKey)&language=\(self.language)&with_genres=\(genreString)"
        self.lastUrl = movieURL
        self.page = 1
        self.fetchListMovie(urlString: movieURL)
    }
    
    func fetchPreviousPage(){
        if (self.page == 1) {
            return
        }
        self.page = self.page - 1
        let newUrl = self.lastUrl + "&page=" + String(self.page)
        self.fetchListMovie(urlString: newUrl)
    }
    
    func fetchNextPage(){
        self.page = self.page + 1
        let newUrl = self.lastUrl + "&page=" + String(self.page)
        self.fetchListMovie(urlString: newUrl)
    }
    
    private func fetchListMovie(urlString: String){
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                        print("Failed to fetch data: \(error?.localizedDescription ?? "Unknown error")")
                        return
                    }
                let decoder = JSONDecoder()

                do {
                    let decodedResponse = try decoder.decode(DTOSearchMovies.self, from: data)
                    DispatchQueue.main.async {
                        self.movies = decodedResponse.results.map { Movie(from: $0) }
                    }
                } catch {
                    print("Failed to decode JSON: \(error)")
                }
            
        }
        task.resume()
    }
}
