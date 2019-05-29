//
//  MovieListState.swift
//  RxLoopDemo
//
//  Created by Thibault Wittemberg on 2019-05-18.
//  Copyright © 2019 WarpFactor. All rights reserved.
//
import Foundation

enum MovieListState {
    case loading
    case loaded(movies: [MovieListState.ViewItem])
    case failed

    struct ViewItem {
        let id: Int
        let title: String
        let overview: String
        let posterURL: URL
    }
}
