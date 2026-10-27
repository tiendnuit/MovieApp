//
//  NetworkError.swift
//  MovieApp
//
//  Created by Tien Doan on 10/26/26.
//

import Foundation

public enum NetworkError: Error, Equatable {
    case invalidResponse
    case httpStatus(Int)
    case decoding(String)
    case transport(URLError.Code)
    case cancelled
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidResponse: "The server returned an invalid response."
        case .httpStatus(404): "404 error!"
        case .httpStatus(let code): "The server responded with an error \(code)."
        case .decoding: "Something wrong with decoding data."
        case .transport(.timedOut): "The request timed out."
        case .transport: "A network error occurerd."
        case .cancelled: "The request was cancelled."
        }
    }
}
