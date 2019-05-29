//
//  RoutesAssembly.swift
//  RxLoopDemo
//
//  Created by Thibault Wittemberg on 2019-05-18.
//  Copyright © 2019 WarpFactor. All rights reserved.
//

import Swinject

final class RoutesAssembly: Assembly {

    private let baseUrl: String
    private let apiKey: String

    init(withBaseUrl baseUrl: String, apiKey: String) {
        self.baseUrl = baseUrl
        self.apiKey = apiKey
    }

    func assemble(container: Container) {
        container.register(Route<DiscoverMovieEndpoint>.self) { (_) -> Route<DiscoverMovieEndpoint> in
            let route = Route(withBaseUrl: self.baseUrl,
                              endpoint: DiscoverMovieEndpoint(),
                              scheme: .https)
            route.set(parameter: ApiKeyModel(apiKey: self.apiKey))
            return route
        }

        container.register(Route<MovieDetailEndpoint>.self) { (_, movieId: Int) -> Route<MovieDetailEndpoint> in
            let route = Route(withBaseUrl: self.baseUrl,
                              endpoint: MovieDetailEndpoint(path: AppPath.detailMovie(id: movieId)),
                              scheme: .https)
            route.set(parameter: ApiKeyModel(apiKey: self.apiKey))
            return route
        }

        container.register(Route<DiscoverTVEndpoint>.self) { (_) -> Route<DiscoverTVEndpoint> in
            let route = Route(withBaseUrl: self.baseUrl,
                              endpoint: DiscoverTVEndpoint(),
                              scheme: .https)
            route.set(parameter: ApiKeyModel(apiKey: self.apiKey))
            return route
        }
    }
}
