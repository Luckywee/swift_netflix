//
//  DTOBelongsToCollection.swift
//  Netflix
//
//  Created by digital on 18/04/2023.
//

import Foundation


struct DTOBelongsToCollection: Codable {
    let id: Int
    let name: String
    let poster_path: String?
    let backdrop_path: String?
}
