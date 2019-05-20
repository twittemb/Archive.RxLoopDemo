//
//  MovieListReducer.swift
//  RxLoopDemo
//
//  Created by Thibault Wittemberg on 2019-05-18.
//  Copyright © 2019 WarpFactor. All rights reserved.
//

import RxSwift

func movieListReducer (stateAndMutation: Observable<(MovieListMutation, MovieListState)>) -> Observable<MovieListState> {

    return stateAndMutation.map {
        switch $0 {
        case (.startLoad, _):
            return .loading
        case (.load(let movies), .loading):
            return .loaded(movies: movies)
        default:
            return .failed
        }
    }
}
