//
//  CatalogMapper.swift
//  MovieApp
//
//  Created by Tien Doan on 10/27/26.
//

import Foundation

enum CatalogMapper {
    struct Limits: Sendable {
        var maxCategories = 8
        var maxMoviesPerCategory = 20
        var maxSuggestions = 15
    }
    
    static func categories(from shows: [ShowDTO], limits: Limits = .init()) -> [MovieCategory] {
        let byGenre = Dictionary(grouping: shows.flatMap { show in show.genres.map { ($0, show) } },
                                 by: \.0)
            .mapValues { $0.map(\.1)}
        
        return byGenre.sorted { lhs, rhs in
            lhs.value.count == rhs.value.count ? lhs.key < rhs.key : lhs.value.count > rhs.value.count
        }
        .prefix(limits.maxCategories)
        .map { genre, shows in
            MovieCategory(id: genre.lowercased(), title: genre, movies: shows.sorted(by: Self.byRating).prefix(limits.maxMoviesPerCategory).map(movie(from:)))
        }
    }
    
    static func suggestions(for id: Int, in shows: [ShowDTO], limits: Limits = .init()) -> [Movie] {
        []
    }
    
    static func movie(from dto: ShowDTO) -> Movie {
        Movie(id: dto.id, title: dto.name, subtitle: subtitle(for: dto), thumbnailURL: dto.image?.medium)
    }
    
    static func detail(from dto: ShowDTO) -> MovieDetail {
        MovieDetail(id: dto.id,
                    title: dto.name,
                    subtitle: subtitle(for: dto),
                    overview: plainText(fromHTML: dto.summary ?? ""),
                    posterURL: dto.image?.original ?? dto.image?.medium,
                    genres: dto.genres,
                    rating: dto.rating?.average,
                    runtimeMinutes: dto.runtime,
                    releaseYear: year(from: dto.premiered))
    }
    
    static func plainText(fromHTML html: String) -> String {
        let entities = ["&amp;": "&", "&quot;" : "\""]
        let stripped = html.replacing(/<[^>]+/, with: "")
        return entities.reduce(stripped) { $0.replacingOccurrences(of: $1.key, with: $1.value) }
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    static func year(from premiered: String?) -> Int? {
        premiered.flatMap { Int($0.prefix(4)) }
    }
    
    static func subtitle(for dto: ShowDTO) -> String {
        [year(from: dto.premiered).map(String.init), dto.network?.name, dto.genres.first]
            .compactMap(\.self)
            .joined(separator: " - ")
        
    }
    
    private static func byRating(_ lhs: ShowDTO, _ rhs: ShowDTO) -> Bool {
        let (l, r) = (lhs.rating?.average ?? 0, rhs.rating?.average ?? 0)
        return l == r ? lhs.id < rhs.id : l > r
    }
}
