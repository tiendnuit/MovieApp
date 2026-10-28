//
//  MovieDetailView.swift
//  MovieApp
//
//  Created by Tien Doan on 10/28/26.
//

import SwiftUI

/// Movie detail with description
public struct MovieDetailView: View {
    @State private var viewModel: MovieDetailViewModel

    public init(viewModel: MovieDetailViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                header
                overview
            }
            .padding(.vertical)
        }
        .navigationTitle(viewModel.movie.title)
        .navigationBarTitleDisplayMode(.inline)
        .task { await viewModel.loadIfNeeded() }
    }

    // MARK: Sections

    private var header: some View {
        HStack(alignment: .top, spacing: 16) {
            RemoteImage(url: viewModel.movie.thumbnailURL)
                .frame(width: 140, height: 210)
                .clipShape(.rect(cornerRadius: 12))
                .shadow(radius: 6, y: 3)

            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.movie.title)
                    .font(.title2.bold())
                    .accessibilityAddTraits(.isHeader)
                Text(viewModel.movie.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                if let detail = viewModel.detail.value {
                    MetadataView(detail: detail)
                }
            }
        }
        .padding(.horizontal)
    }

    @ViewBuilder
    private var overview: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Overview")
                .font(.title3.bold())
                .accessibilityAddTraits(.isHeader)

            switch viewModel.detail {
            case .idle, .loading:
                Text(String(repeating: "Placeholder overview text. ", count: 8))
                    .redacted(reason: .placeholder)
            case .loaded(let detail):
                Text(detail.overview.isEmpty ? "No description available." : detail.overview)
                    .foregroundStyle(detail.overview.isEmpty ? .secondary : .primary)
                    .accessibilityIdentifier("movie_overview")
            case .failed(let message):
                ContentUnavailableView {
                    Label("Something went wrong", systemImage: "wifi.exclamationmark")
                } description: {
                    Text(message)
                } actions: {
                    Button("Try Again") { Task { await viewModel.load() }}
                        .buttonStyle(.borderedProminent)
                }
            }
        }
        .padding(.horizontal)
    }
}

private struct MetadataView: View {
    let detail: MovieDetail

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 12) {
                if let rating = detail.rating {
                    Label(rating.formatted(.number.precision(.fractionLength(1))), systemImage: "star.fill")
                        .foregroundStyle(.yellow)
                }
                if let runtime = detail.runtimeMinutes {
                    Label("\(runtime) min", systemImage: "clock")
                }
            }
            .font(.footnote.weight(.medium))

            Text(detail.genres.joined(separator: ", "))
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }
}
