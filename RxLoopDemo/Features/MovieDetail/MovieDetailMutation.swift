//
//  MovieDetailMutation.swift
//  RxLoopDemo
//
//  Created by Thibault Wittemberg on 2019-05-26.
//  Copyright © 2019 WarpFactor. All rights reserved.
//

enum MovieDetailMutation {
    case startLoad
    case load(movie: MovieDetailState.ViewItem)
    case fail(error: Error)
}
