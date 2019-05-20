//
//  MovieListUseCase.swift
//  RxLoopDemo
//
//  Created by Thibault Wittemberg on 2019-05-18.
//  Copyright © 2019 WarpFactor. All rights reserved.
//

import Foundation
import RxSwift

func movieListUseCase(networkService: NetworkService, route: Route<DiscoverMovieEndpoint>, intents: Observable<MovieListIntent>) -> Observable<MovieListMutation> {
    return intents.flatMap { (intent) -> Observable<MovieListMutation> in
        switch intent {
        case .viewLoaded:
            return fetchDiscoverMovies(networkService: networkService, route: route)
                .map { MovieListMutation.load(movies: $0) }
                .catchError { return .just(MovieListMutation.fail(error: $0)) }
                .startWith (MovieListMutation.startLoad)
        }
    }
}

private func fetchDiscoverMovies (networkService: NetworkService, route: Route<DiscoverMovieEndpoint>) -> Observable<[MovieListState.ViewItem]> {
    return networkService
        .fetch(route: route)
        .asObservable()
        .map { discoverMovieResponse -> [MovieListState.ViewItem] in
            discoverMovieResponse
                .movies
                .filter {$0.backdropPath != nil}
                .map { MovieListState.ViewItem(title: $0.name,
                                               overview: $0.overview,
                                               posterURL: URL(string: "https://image.tmdb.org/t/p/w154\($0.posterPath)")!) }
    }
}
