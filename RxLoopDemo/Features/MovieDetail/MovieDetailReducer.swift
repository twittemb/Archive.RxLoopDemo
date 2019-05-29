//
//  MovieDetailReducer.swift
//  RxLoopDemo
//
//  Created by Thibault Wittemberg on 2019-05-26.
//  Copyright © 2019 WarpFactor. All rights reserved.
//

import RxSwift

func movieDetailReducer (stateAndMutation: Observable<(MovieDetailMutation, MovieDetailState)>) -> Observable<MovieDetailState> {

    return stateAndMutation.map {
        switch $0 {
        case (.startLoad, _):
            return .loading
        case (.load(let movie), .loading):
            return .loaded(movie)
        default:
            return .failed
        }
    }
}
