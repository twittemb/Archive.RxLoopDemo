//
//  AppPaths.swift
//  ClearID
//
//  Created by Thibault Wittemberg on 18-09-24.
//  Copyright © 2018 Genetec. All rights reserved.
//

/// The Application's paths
enum AppPath {
    case discoverMovie
    case discoverTV
}

// MARK: - String representation of paths
extension AppPath: Path {
    var description: String {
        switch self {
        case .discoverMovie:
            return "/discover/movie"
        case .discoverTV:
            return "/discover/tv"
        }
    }
}
