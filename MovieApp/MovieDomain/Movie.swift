//
//  Movie.swift
//  MovieApp
//
//  Created by Tien Doan on 10/27/26.
//

import Foundation

public struct Movie: Identifiable, Hashable, Sendable {
    public typealias ID = Int
    public let id: ID
    public let title: String
    public let subtitle: String
    public let thumbnailURL: URL?
    
    public init(id: ID, title: String, subtitle: String, thumbnailURL: URL?) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.thumbnailURL = thumbnailURL
    }
}

public struct MovieCategory: Identifiable, Hashable, Sendable {
    public let id: String
    public let title: String
    public let movies: [Movie]
    
    public init(id: String, title: String, movies: [Movie]) {
        self.id = id
        self.title = title
        self.movies = movies
    }
}

public struct MovieDetail: Identifiable, Hashable, Sendable {
    public let id: Movie.ID
    public let title: String
    public let subtitle: String
    public let overview: String
    public let posterURL: URL?
    public let genres: [String]
    public let rating: Double?
    public let runtimeMinutes: Int?
    public let releaseYear: Int?
    
    public init(id: Movie.ID,
                title: String,
                subtitle: String,
                overview: String,
                posterURL: URL?,
                genres: [String],
                rating: Double?,
                runtimeMinutes: Int?,
                releaseYear: Int?) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.overview = overview
        self.posterURL = posterURL
        self.genres = genres
        self.rating = rating
        self.runtimeMinutes = runtimeMinutes
        self.releaseYear = releaseYear
    }
}
