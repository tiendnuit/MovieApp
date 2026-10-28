//
//  MovieDetailViewModel.swift
//  MovieApp
//
//  Created by Tien Doan on 10/28/26.
//
import Foundation
import Observation

@MainActor
@Observable
public final class MovieDetailViewModel {
    public let movie: Movie
    public private(set) var detail: Loadable<MovieDetail> = .idle

    @ObservationIgnored private let repository: any MovieRepository

    public init(movie: Movie, repository: any MovieRepository) {
        self.movie = movie
        self.repository = repository
    }

    public func loadIfNeeded() async {
        guard case .idle = detail else { return }
        await load()
    }
    
    public func load() async {
        detail = .loading

        let repository = repository
        let id = movie.id
        async let detailRequest = repository.fetchMovieDetail(id: id)

        do {
            detail = .loaded(try await detailRequest)
        } catch {
            detail = Task.isCancelled ? .idle : .failed(message: error.localizedDescription)
        }
    }
}
