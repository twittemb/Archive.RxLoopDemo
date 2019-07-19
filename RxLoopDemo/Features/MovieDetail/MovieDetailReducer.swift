//
//  MovieDetailReducer.swift
//  RxLoopDemo
//
//  Created by Thibault Wittemberg on 2019-05-26.
//  Copyright © 2019 WarpFactor. All rights reserved.
//

import RxSwift

func movieDetailReducer (state: MovieDetailState, mutation: MovieDetailMutation) -> MovieDetailState {
    switch (state, mutation) {
    case (_, .startLoad):
        return .loading
    case (.loading, .load(let movie)):
        return .loaded(movie)
    default:
        return .failed
    }
}
