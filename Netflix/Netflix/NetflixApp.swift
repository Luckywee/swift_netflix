//
//  NetflixApp.swift
//  Netflix
//
//  Created by digital on 04/04/2023.
//

import SwiftUI

@main
struct NetflixApp: App {
    @StateObject var movieViewModel = MovieViewModel()
    var body: some Scene {
        WindowGroup {
            MovieListView().environmentObject(movieViewModel)
        }
    }
}
