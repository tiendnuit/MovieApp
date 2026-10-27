//
//  Endpoint.swift
//  MovieApp
//
//  Created by Tien Doan on 10/26/26.
//

import Foundation

public enum HTTPMethod: String, Sendable {
    case get = "GET"
    case post = "POST"
}

public protocol Endpoint: Sendable {
    associatedtype Response: Decodable & Sendable
    
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem] { get }
    var headers: [String: String] { get }
}

public extension Endpoint {
    var method: HTTPMethod { .get }
    var queryItems: [URLQueryItem] { [] }
    var headers: [String: String] { [:] }
    
    func makeRequest(baseURL: URL, timeout: TimeInterval = 15) -> URLRequest {
        var url = baseURL.appending(path: path)
        if !queryItems.isEmpty {
            url.append(queryItems: queryItems)
        }
        
        var request = URLRequest(url: url, timeoutInterval: timeout)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        headers.forEach { request.setValue($1, forHTTPHeaderField: $0)}
        
        return request
    }
}
