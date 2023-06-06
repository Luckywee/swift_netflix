//
//  Genre.swift
//  Netflix
//
//  Created by digital on 22/05/2023.
//

import Foundation

struct Genre: Codable, Identifiable, Hashable {
    let id: Int?
    let name: String?
    
    init(from dtoGenre: DTOGenre) {
        self.id = dtoGenre.id
        self.name = dtoGenre.name
    }
    
    init(id: Int?, name: String?) {
            self.id = id
            self.name = name
    }
}
