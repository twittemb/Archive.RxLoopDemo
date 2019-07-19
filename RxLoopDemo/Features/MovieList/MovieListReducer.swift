//
//  MovieListReducer.swift
//  RxLoopDemo
//
//  Created by Thibault Wittemberg on 2019-05-18.
//  Copyright © 2019 WarpFactor. All rights reserved.
//

import RxSwift

func movieListReducer (state: MovieListState, mutation: MovieListMutation) -> MovieListState {
    switch (state, mutation) {
    case (_, .startLoad):
        return .loading
    case (.loading, .load(let movies)):
        return .loaded(movies: movies)
    default:
        return .failed
    }
}
