//
//  DTOTrailer.swift
//  Netflix
//
//  Created by digital on 18/04/2023.
//

import Foundation


struct DTOTrailer: Codable {
    let id: Int
    let results: [DTOTrailerResult]
    
}
