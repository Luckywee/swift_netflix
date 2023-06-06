//
//  DTOTrailerResult.swift
//  Netflix
//
//  Created by digital on 18/04/2023.
//

import Foundation


struct DTOTrailerResult: Codable {
    let iso_639_1: String
    let iso_3166_1: String
    let name: String
    let key: String
    let site: String
    let size: Int
    let type: String
    let official: Bool
    let published_at: String
    let id: String
}
