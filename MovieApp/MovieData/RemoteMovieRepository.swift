//
//  RemoteMovieRepository.swift
//  MovieApp
//
//  Created by Tien Doan on 10/27/26.
//
import Foundation

private enum CatalogState {
    case loading(Task<[ShowDTO], any Error>)
    case loaded([ShowDTO])
}

public actor RemoteMovieRepository: MovieRepository {
    private let client: any HTTPClient
    private let limits: CatalogMapper.Limits
    
    private var catalogState: CatalogState?
    private var detailCache: [Movie.ID: MovieDetail] = [:]
    
    public init(client: any HTTPClient) {
        self.client = client
    }
    
    public init(client: any HTTPClient, limits: CatalogMapper.Limits) {
        self.client = client
        self.limits = limits
    }
    
    public func fetchCategories() async throws -> [MovieCategory] {
        let shows = try await catalog(forceRefresh: true)
        return CatalogMapper.categories(from: shows, limits: limits)
    }
    
    public func fetchMovieDetail(id: Movie.ID) async throws -> MovieDetail {
        if let cached = detailCache[id] { return cached }
        let dto = try await client.send(ShowDetailEndpoint(id: id))
        let detail = CatalogMapper.detail(from: dto)
        detailCache[id] = detail
        return detail
    }
    
    public func fetchSuggestions(for id: Movie.ID) async throws -> [Movie] {
        let shows = try await catalog(forceRefresh: false)
        return CatalogMapper.suggestions(for: id, in: shows, limits: limits)
    }
    
    // MARK: Private
    private func catalog(forceRefresh: Bool) async throws -> [ShowDTO] {
        switch catalogState {
        case .loading(let task):
            return try await task.value
        case .loaded(let shows) where !forceRefresh:
            return shows
        default:
            break
        }
        
        let client = client
        let task = Task { try await client.send(ShowEndpoint(page: 0))}
        catalogState = .loading(task)
        do {
            let shows = try await task.value
            if case .loading(task) = catalogState { catalogState = .loaded(shows) }
            return shows
        } catch {
            if case .loading(task) = catalogState { catalogState = nil }
            throw error
        }
    }
}
