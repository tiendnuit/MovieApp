//
//  Loadable.swift
//  MovieApp
//
//  Created by Tien Doan on 10/27/26.
//

/// A State machine for async content, every state must be handled.

nonisolated public enum Loadable<Value> {
    case idle
    case loading
    case loaded(Value)
    case failed(message: String)
    
    public var value: Value? {
        if case .loaded(let value) = self {
            value
        } else {
            nil
        }
    }
    
    public var isLoading: Bool {
        if case .loading = self { true } else { false }
    }
}

extension Loadable: Equatable where Value: Equatable {}
extension Loadable: Sendable where Value: Sendable {}
