//
//  MovieCard.swift
//  MovieApp
//
//  Created by Tien Doan on 10/27/26.
//

import SwiftUI

struct MovieCard: View {
    static let width: CGFloat = 120
    
    private let movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            RemoteImage(url: movie.thumbnailURL)
                .frame(width: Self.width, height: Self.width * 1.5)
                .clipShape(.rect(cornerRadius: 10))
            Text(movie.title)
                .font(.subheadline.weight(.semibold))
                .lineLimit(1)
            Text(movie.subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .frame(width: Self.width, alignment: .leading)
        .contentShape(.rect)
    }
}
