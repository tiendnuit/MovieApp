//
//  AppConfiguration.swift
//  MovieApp
//
//  Created by Tien Doan on 10/27/26.
//

import Foundation

nonisolated enum AppEnvironment: String, Sendable, CaseIterable {
    case stage
    case prod
}

/// Runtime Configuration, built from the values in `Info.plist`
nonisolated struct AppConfiguration: Sendable, Equatable {
    nonisolated enum Key {
        static let environment = "AppEnvironment"
        static let apiBaseURL = "APIBaseURL"
        static let usesMockServer = "usesMockServer"
    }
    
    let environment: AppEnvironment
    let apiBaseURL: URL
    let usesMockServer: Bool
    
    init(environment: AppEnvironment, apiBaseURL: URL, usesMockServer: Bool) {
        self.environment = environment
        self.apiBaseURL = apiBaseURL
        self.usesMockServer = usesMockServer
    }
    
    /// Parses configs from Info.plist
    init(infoDictionary: [String: Any]) throws(ConfigurationError) {
        // Check Environment
        guard let rawValue = infoDictionary[Key.environment] as? String, !rawValue.isEmpty else {
            throw .missingValue(Key.environment)
        }
        guard let environment = AppEnvironment(rawValue: rawValue.lowercased()) else {
            throw .invalidValue(key: Key.environment, value: rawValue)
        }
        
        // Check apiBaseURL
        guard let rawURL = infoDictionary[Key.apiBaseURL] as? String, !rawURL.isEmpty else {
            throw .missingValue(Key.apiBaseURL)
        }
        guard let url = URL(string: rawURL), let scheme = url.scheme, ["http", "https"].contains(scheme), url.host() != nil else {
            throw .invalidValue(key: Key.apiBaseURL, value: rawURL)
        }
        
        let isMock = (infoDictionary[Key.usesMockServer] as? String)?.uppercased()
        self.init(environment: environment,
                  apiBaseURL: url,
                  usesMockServer: isMock == "YES" || isMock == "TRUE" )
    }
    
    /// Convenience for the app target
    static func load(from bundle: Bundle = .main) throws(ConfigurationError) -> AppConfiguration {
        try AppConfiguration(infoDictionary: bundle.infoDictionary ?? [:])
    }
}

nonisolated enum ConfigurationError: Error, Equatable, CustomStringConvertible {
    case missingValue(String)
    case invalidValue(key: String, value: String)
    
    var description: String {
        switch self {
        case .missingValue(let key): "Missing Info.plist value for \(key)"
        case .invalidValue(let key, let value): "Invalid value \(value) for \(key)"
        }
    }
}
