//
//  AppContainer.swift
//  MovieApp
//
//  Created by Tien Doan on 10/27/26.
//
import Foundation

/// Composition root, dependencies contruction injection
final class AppContainer {
    let configuration: AppConfiguration
    private let repository: any MovieRepository
    
    init(configuration: AppConfiguration, repository: any MovieRepository) {
        self.configuration = configuration
        self.repository = repository
    }
    
    static func live(bundle: Bundle = .main) -> AppContainer {
        let configuration: AppConfiguration
        do {
            configuration = try AppConfiguration.load(from: bundle)
        } catch {
            fatalError(error.description)
        }
        
        // Based on `usesMockServer` to inject MockServer or not
        let sessionConfigs: URLSessionConfiguration = configuration.usesMockServer ? .default : .default
        
        let client = APIClient(baseURL: configuration.apiBaseURL,
                               transport: URLSessionTransport(session: URLSession(configuration: sessionConfigs)))
        return AppContainer(configuration: configuration, repository: RemoteMovieRepository(client: client))
    }
    
    // MARK: Factories

    func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel(repository: repository)
    }
    
    func makeMovieDetailViewModel(movie: Movie) -> MovieDetailViewModel {
        MovieDetailViewModel(movie: movie, repository: repository)
    }
}


