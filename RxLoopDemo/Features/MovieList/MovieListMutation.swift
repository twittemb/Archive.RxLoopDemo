//
//  MovieListMutation.swift
//  RxLoopDemo
//
//  Created by Thibault Wittemberg on 2019-05-18.
//  Copyright © 2019 WarpFactor. All rights reserved.
//

enum MovieListMutation {
    case startLoad
    case load(movies: [MovieListState.ViewItem])
    case fail(error: Error)
}
