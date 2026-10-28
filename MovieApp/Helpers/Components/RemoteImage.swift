//
//  RemoteImage.swift
//  MovieApp
//
//  Created by Tien Doan on 10/27/26.
//

import SwiftUI

struct RemoteImage: View {
    private enum Phase {
        case empty
        case success(UIImage)
        case failure
    }
    
    @Environment(\.imageLoader) private var loader
    @State private var phase: Phase = .empty
    private let url: URL?
    
    init(url: URL?) {
        self.url = url
    }
    
    var body: some View {
        Rectangle()
            .fill(Color.secondary.opacity(0.2))
            .overlay {
                switch phase {
                case .success(let image):
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .transition(.opacity)
                case .failure:
                    Image(systemName: "photo")
                        .foregroundStyle(.secondary)
                case .empty:
                    EmptyView()
                }
            }
            .clipped()
            .task(id: url) { await load() }
    }
    
    private func load() async {
        guard let url else {
            phase = .failure
            return
        }
        do {
            let image = try await loader.image(for: url)
            withAnimation(.easeOut(duration: 0.2)) { phase = .success(image) }
        } catch {
            if !Task.isCancelled { phase = .failure }
        }
    }
}
