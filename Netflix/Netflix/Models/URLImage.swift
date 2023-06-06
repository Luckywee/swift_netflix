//
//  URLImage.swift
//  Netflix
//
//  Created by digital on 17/04/2023.
//

import Foundation

import SwiftUI

struct URLImage: View {
    @ObservedObject private var imageLoader = ImageLoader()

    let url: String
    let placeholder: Image

    init(url: String, placeholder: Image = Image(systemName: "photo")) {
        self.url = url
        self.placeholder = placeholder
        self.imageLoader.load(url: url)
    }

    var body: some View {
        if let image = self.imageLoader.downloadedImage {
            return Image(uiImage: image)
                .resizable()
        } else {
            return placeholder
                .resizable()
        }
    }
}

class ImageLoader: ObservableObject {
    @Published var downloadedImage: UIImage?

    func load(url: String) {
        guard let imageURL = URL(string: url) else { return }
        URLSession.shared.dataTask(with: imageURL) { data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.downloadedImage = image
            }
        }.resume()
    }
}
