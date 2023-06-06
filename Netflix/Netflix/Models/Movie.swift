//
//  Movie.swift
//  Netflix
//
//  Created by digital on 17/04/2023.
//

import Foundation

struct Movie: Codable, Identifiable{
    var id = UUID()
    var idApi: Int
    var title: String
    var releaseYear: String
    var dateOut: Date
    var minuteLength: Double
    var categories: [String]
    var desc: String
    var poster: String
    var backgroundImage: String
    var link: String
    var satisfaction: Double
    var numRatings: Int
    
    init(from dtoMovie: DTOMovie) {
        self.title = dtoMovie.title ?? ""
        if let release_date = dtoMovie.release_date {
            self.releaseYear = String(release_date.prefix(4))
            self.dateOut = ISO8601DateFormatter().date(from: release_date) ?? Date()
        }
        else {
            self.releaseYear = "0000"
            self.dateOut = Date()
        }
        self.minuteLength = Double(dtoMovie.runtime ?? 0)
        self.categories = (dtoMovie.genres?.map { $0.name ?? "" }) ?? []
        self.desc = dtoMovie.overview ?? ""
        self.poster = "https://image.tmdb.org/t/p/w500\(dtoMovie.poster_path ?? "")"
        self.backgroundImage = "https://image.tmdb.org/t/p/w500\(dtoMovie.backdrop_path ?? "")"
        self.link = "https://www.youtube.com/watch?v="
        self.satisfaction = (dtoMovie.vote_average ?? 0.0)*10
        self.numRatings = dtoMovie.vote_count ?? 0
        self.idApi = dtoMovie.id
    }
}

