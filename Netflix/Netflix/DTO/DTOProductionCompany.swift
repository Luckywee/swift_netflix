//
//  DTOProductionCompany.swift
//  Netflix
//
//  Created by digital on 18/04/2023.
//

import Foundation

struct DTOProductionCompany: Codable {
    let id: Int
    let logo_path: String?
    let name: String
    let origin_country: String
}
