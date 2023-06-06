//
//  DTOSearchMovies.swift
//  Netflix
//
//  Created by digital on 18/04/2023.
//

import Foundation

struct DTOSearchMovies: Codable {
    let page: Int?
    let results: [DTOMovie]
    let total_pages: Int?
    let total_results: Int?
}
