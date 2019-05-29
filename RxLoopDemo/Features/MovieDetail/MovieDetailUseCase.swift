//
//  MovieDetailUseCase.swift
//  RxLoopDemo
//
//  Created by Thibault Wittemberg on 2019-05-26.
//  Copyright © 2019 WarpFactor. All rights reserved.
//

import Foundation
import RxSwift

func movieDetailUseCase(networkService: NetworkService, route: Route<MovieDetailEndpoint>, intents: Observable<MovieDetailIntent>) -> Observable<MovieDetailMutation> {
    return intents.flatMap { (intent) -> Observable<MovieDetailMutation> in
        switch intent {
        case .viewWillAppear:
            return fetchDetailMovie(networkService: networkService, route: route)
                .map { MovieDetailMutation.load(movie: $0) }
                .catchError { return .just(MovieDetailMutation.fail(error: $0)) }
                .startWith (MovieDetailMutation.startLoad)
        }
    }
}

private func fetchDetailMovie (networkService: NetworkService, route: Route<MovieDetailEndpoint>) -> Observable<MovieDetailState.ViewItem> {
    return networkService
        .fetch(route: route)
        .asObservable()
        .map { MovieDetailState.ViewItem(
            id: $0.id,
            title: $0.name,
            overview: $0.overview,
            posterURL: URL(string: "https://image.tmdb.org/t/p/w780\($0.posterPath)")!,
            voteAverage: "\($0.voteAverage)",
            popularity: "\($0.popularity)",
            originalTitle: $0.originalName,
            releaseDate: $0.releaseDate)
    }
}
