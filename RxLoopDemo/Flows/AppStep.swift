//
//  AppStep.swift
//  RxLoopDemo
//
//  Created by Thibault Wittemberg on 2019-05-19.
//  Copyright © 2019 WarpFactor. All rights reserved.
//

import RxFlow

enum AppStep: Step {
    case movieList
    case movieDetail(id: Int)
    case movieDetailDone
}
