//
//  MovieDetail.swift
//  Netflix
//
//  Created by digital on 17/04/2023.
//

import Foundation
import SwiftUI


struct MovieDetailView: View {
    let movieID: Int
    @State private var showShareSheet = false
    @State private var movie: Movie?
    @EnvironmentObject var movieViewModel: MovieViewModel
    @Environment(\.openURL) private var openURL
    var body: some View {
        VStack {
            if let movie = movie {
                GeometryReader { geometry in
                    ZStack(alignment: .top) {
                        AsyncImage(url: URL(string: movie.backgroundImage), content: { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .overlay(
                                    LinearGradient(gradient: Gradient(colors: [Color.clear, Color.white.opacity(1)]), startPoint: .top, endPoint: .bottom)
                                )
                        }, placeholder: {
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundColor(.gray.opacity(0.3))
                        })
                    }
                    ScrollView {
                        VStack {
                            Text(movie.title)
                                .font(.title)
                                .padding(.top, 120)
                            Text(movie.releaseYear + " - " + minutesToHourString(minutes: movie.minuteLength))
                                .font(.headline)
                                .foregroundColor(.gray)
                            if hasLink(link: movie.link) {
                                Button(action: {
                                    if let url = URL(string: movie.link) {
                                        openURL(url)
                                    }}) {
                                        Text("movie.trailer")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 8)
                                            .background(Color.accentColor)
                                            .cornerRadius(8)
                                    }
                            }
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(movie.categories, id: \.self) { category in
                                        Text(category)
                                            .font(.subheadline)
                                            .foregroundColor(.white)
                                            .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                                            .background(randomPastelColor())
                                            .cornerRadius(10)
                                    }
                                }
                            }
                            Text(movie.desc)
                                .font(.body)
                                .padding(.top, 10)
                            SatisfactionView(score: movie.satisfaction)
                                .frame(width: 50, height: 50)
                                .padding(.top, 10)
                        }
                        .padding()
                    }
                }
            } else {
                Text("movie.looking")
            }
        }
        .onAppear {
            movieViewModel.fetchMovieDetails(id: movieID) { fetchedMovie in
                movie = fetchedMovie
            }
        }
        .navigationBarTitle(Text(movie?.title ?? ""), displayMode: .inline)
    }
}


struct SatisfactionView: View {
    let score: Double
    
    var body: some View {
        let percentage = score / 100.0
        let startColor = randomPastelColor()
        let endColor = randomPastelColor()
        
        ZStack {
            Circle()
                .stroke(lineWidth: 10)
                .opacity(0.3)
                .foregroundColor(Color.gray)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(percentage, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 10.0, lineCap: .round, lineJoin: .round))
                .fill(gradient(start: startColor, end: endColor, percentage: percentage))
                .rotationEffect(Angle(degrees: -90))
            
            Text(String(format: "%.0f%%", score))
                .font(.caption)
                .fontWeight(.bold)
        }
        .frame(width: 50, height: 50)
    }
    
    private func gradient(start: Color, end: Color, percentage: Double) -> LinearGradient {
        return LinearGradient(gradient: Gradient(colors: [start, end]), startPoint: .leading, endPoint: .trailing)
    }
}

func randomPastelColor() -> Color {
    let hue = Double.random(in: 0...1)
    let saturation = Double.random(in: 0.4...0.7)
    let brightness = Double.random(in: 0.6...0.85)
    
    return Color(hue: hue, saturation: saturation, brightness: brightness)
}

func minutesToHourString(minutes: Double) -> String {
    let totalHours = Int(minutes / 60)
    let remainingMinutes = Int(minutes.truncatingRemainder(dividingBy: 60))
    
    return "\(totalHours)h\(remainingMinutes)m"
}

func hasLink(link: String) -> Bool {
    print(link)
    return link.last != "="
}

