//
//  MovieDetailState.swift
//  RxLoopDemo
//
//  Created by Thibault Wittemberg on 2019-05-26.
//  Copyright © 2019 WarpFactor. All rights reserved.
//
import Foundation

enum MovieDetailState {
    case loading
    case loaded (MovieDetailState.ViewItem)
    case failed

    struct ViewItem {
        let id: Int
        let title: String
        let overview: String
        let posterURL: URL
        let voteAverage: String
        let popularity: String
        let originalTitle: String
        let releaseDate: String
    }
}
