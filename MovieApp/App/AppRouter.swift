//
//  AppRouter.swift
//  MovieApp
//
//  Created by Tien Doan on 10/27/26.
//

import Foundation

enum AppRoute: Hashable {
    case movieDetail(Movie)
}

@Observable
final class AppRouter {
    var path: [AppRoute] = []
    
    func showDetail(for movie: Movie) {
        path.append(.movieDetail(movie))
    }
    
    func popToRoot() {
        path.removeAll()
    }
}
