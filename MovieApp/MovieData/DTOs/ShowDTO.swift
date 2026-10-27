//
//  ShowDTO.swift
//  MovieApp
//
//  Created by Tien Doan on 10/27/26.
//

import Foundation

struct ShowDTO: Decodable, Sendable, Equatable {
    struct Rating: Decodable, Sendable, Equatable {
        let average: Double?
    }
    
    struct Image: Decodable, Sendable, Equatable {
        let medium: URL?
        let original: URL?
    }
    
    struct Network: Decodable, Sendable, Equatable {
        let name: String
    }
    
    let id: Int
    let name: String
    let genres: [String]
    let language: String?
    let runtime: Int?
    let premiered: String?
    let rating: Rating?
    let image: Image?
    let network: Network?
    let summary: String?
}
