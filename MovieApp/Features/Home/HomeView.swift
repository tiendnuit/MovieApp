//
//  HomeView.swift
//  MovieApp
//
//  Created by Tien Doan on 10/26/26.
//

import SwiftUI

public struct HomeView: View {
    @State private var viewModel: HomeViewModel
    private let onSelected: (Movie) -> Void
    
    init(viewModel: HomeViewModel, onSelected: @escaping (Movie) -> Void) {
        _viewModel = State(initialValue: viewModel)
        self.onSelected = onSelected
    }
    
    public var body: some View {
        content
            .navigationTitle("Movies")
            .task { await viewModel.loadIfNeeded() }
            .refreshable {
                await viewModel.reload()
            }
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            Text("Loading...!")
        case .loaded(let categories):
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 28) {
                    ForEach(categories) { category in
                        MovieCarousel(title: category.title, movies: category.movies, onSelect: onSelected)
                            .accessibilityIdentifier("category_\(category.id)")
                    }
                }
                .padding(.vertical)
            }
        case .failed(let message):
            ContentUnavailableView {
                Label("Something went wrong", systemImage: "wifi.exclamationmark")
            } description: {
                Text(message)
            } actions: {
                Button("Try Again") { Task { await viewModel.reload() }}
                    .buttonStyle(.borderedProminent)
            }
        }
    }
}
