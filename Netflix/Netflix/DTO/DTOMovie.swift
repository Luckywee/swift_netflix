//
//  DTOMovie.swift
//  Netflix
//
//  Created by digital on 17/04/2023.
//

import Foundation

struct DTOMovie: Codable {
    let adult: Bool?
    let backdrop_path: String?
    let belongs_to_collection: DTOBelongsToCollection?
    let budget: Int?
    let genres: [DTOGenre]?
    let homepage: String?
    let id: Int
    let imdb_id: String?
    let original_language: String?
    let original_title: String?
    let overview: String?
    let popularity: Double?
    let poster_path: String?
    let production_companies: [DTOProductionCompany]?
    let production_countries: [DTOProductionCountry]?
    let release_date: String?
    let revenue: Int?
    let runtime: Int?
    let spoken_languages: [DTOSpokenLanguage]?
    let status: String?
    let tagline: String?
    let title: String?
    let video: Bool?
    let vote_average: Double?
    let vote_count: Int?
}
