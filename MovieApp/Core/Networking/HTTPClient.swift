//
//  HTTPClient.swift
//  MovieApp
//
//  Created by Tien Doan on 10/26/26.
//

import Foundation

public protocol HTTPTransport: Sendable {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

public struct URLSessionTransport: HTTPTransport {
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        try await session.data(for: request)
    }
}

public protocol HTTPClient: Sendable {
    func send<E: Endpoint>(_ endpoint: E) async throws(NetworkError) -> E.Response
}

public struct APIClient: HTTPClient {
    private let baseURL: URL
    private let transport: any HTTPTransport
    
    public init(baseURL: URL, transport: any HTTPTransport = URLSessionTransport()) {
        self.baseURL = baseURL
        self.transport = transport
    }
    
    public func send<E>(_ endpoint: E) async throws(NetworkError) -> E.Response where E : Endpoint {
        let request = endpoint.makeRequest(baseURL: baseURL)
        let data: Data
        let response: URLResponse
        
        do {
            (data, response) = try await transport.data(for: request)
        } catch let error as URLError where error.code == .cancelled {
            throw .cancelled
        } catch let error as URLError {
            throw .transport(error.code)
        } catch is CancellationError {
            throw .cancelled
        } catch {
            throw .transport(.unknown)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else { throw .invalidResponse }
        guard (200..<300).contains(httpResponse.statusCode) else { throw .httpStatus(httpResponse.statusCode)}
        
        return try await Self.decode(E.Response.self, from: data)
    }
    
    @concurrent
    private static func decode<T: Decodable & Sendable>(_ type: T.Type, from data: Data) async throws(NetworkError) -> T {
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
            throw .decoding(String(describing: error))
        }
    }
}
