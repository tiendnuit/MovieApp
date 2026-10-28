//
//  ImageLoader.swift
//  MovieApp
//
//  Created by Tien Doan on 10/27/26.
//

import SwiftUI
import UIKit

/// ImageLoader with an in-memory cache, `AsyncImage` doesnt cache across view re-creation
actor ImageLoader {
    static let shared = ImageLoader()
    
    private let session: URLSession
    private let cache = NSCache<NSURL, UIImage>()
    private var inFlight: [URL: Task<UIImage, any Error>] = [:]
    
    init(session: URLSession = .shared, limit: Int = 300) {
        self.session = session
        cache.countLimit = limit
    }
    
    func image(for url: URL) async throws -> UIImage {
        if let cached = cache.object(forKey: url as NSURL) {
            return cached
        }
        if let existing = inFlight[url] { return try await existing.value }
        
        let session = session
        let task = Task { try await Self.download(url, using: session) }
        inFlight[url] = task
        defer { inFlight[url] = nil }

        let image = try await task.value
        cache.setObject(image, forKey: url as NSURL)
        return image
    }
    
    @concurrent
    private static func download(_ url: URL, using session: URLSession) async throws -> UIImage {
        let (data, _) = try await session.data(from: url)
        guard let image = UIImage(data: data) else { throw URLError(.cannotDecodeContentData) }
        return await image.byPreparingForDisplay() ?? image
    }
}

extension EnvironmentValues {
    @Entry var imageLoader: ImageLoader = .shared
}
