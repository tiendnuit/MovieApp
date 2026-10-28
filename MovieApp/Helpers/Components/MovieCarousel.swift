//
//  MovieCarousel.swift
//  MovieApp
//
//  Created by Tien Doan on 10/27/26.
//
import SwiftUI

struct MovieCarousel: View {
    private let title: String
    private let movies: [Movie]
    private let onSelect: (Movie) -> Void

    init(title: String, movies: [Movie], onSelect: @escaping (Movie) -> Void) {
        self.title = title
        self.movies = movies
        self.onSelect = onSelect
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.title3.bold())
                .padding(.horizontal)

            ScrollView(.horizontal) {
                LazyHStack(alignment: .top, spacing: 12) {
                    ForEach(movies) { movie in
                        Button { onSelect(movie) } label: { MovieCard(movie: movie) }
                            .buttonStyle(.plain)
                    }
                }
                .scrollTargetLayout()
                .padding(.horizontal)
            }
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned)
        }
    }
}

