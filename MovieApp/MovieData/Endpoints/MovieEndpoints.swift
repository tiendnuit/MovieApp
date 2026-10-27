//
//  MovieEndpoints.swift
//  MovieApp
//
//  Created by Tien Doan on 10/27/26.
//

import Foundation

struct ShowEndpoint: Endpoint {
    typealias Response = [ShowDTO]
    let page: Int
    var path: String { "shows" }
    var queryItems: [URLQueryItem] { [URLQueryItem(name: "page", value: String(page))] }
}

struct ShowDetailEndpoint: Endpoint {
    typealias Response = ShowDTO
    
    let id: Int
    var path: String { "shows/\(id)"}
}
