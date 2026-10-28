//
//  HomeViewModel.swift
//  MovieApp
//
//  Created by Tien Doan on 10/27/26.
//

import Observation
import Foundation

/// Presentation logic for the HomeView
///
/// - `@Observable` replaces `ObservableObject`/`@Published`. SwiftUI tracks only the properties
///  a view actually reads.
///  - `@MainActor`UI updates
@MainActor
@Observable
public final class HomeViewModel {
    public private(set) var state: Loadable<[MovieCategory]> = .idle
    @ObservationIgnored private let repository: any MovieRepository
    
    public init(repository: any MovieRepository) {
        self.repository = repository
    }
    
    public func loadIfNeeded() async {
        guard case .idle = state else {
            return
        }
        await reload()
    }
    
    public func reload() async {
        let previous = state.value
        if previous == nil { state = .loading }
        do {
            state = .loaded(try await repository.fetchCategories())
        } catch {
            state = previous.map(Loadable.loaded) ?? (Task.isCancelled ? .idle : .failed(message: error.localizedDescription))
        }
    }
}
