//
//  MovieRepository.swift
//  MovieApp
//
//  Created by Tien Doan on 10/27/26.
//

public protocol MovieRepository: Sendable {
    func fetchCategories() async throws -> [MovieCategory]
    func fetchMovieDetail(id: Movie.ID) async throws -> MovieDetail
    func fetchSuggestions(for id: Movie.ID) async throws -> [Movie]
}
