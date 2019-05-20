//
//  ViewControllerAssembly.swift
//  RxLoopDemo
//
//  Created by Thibault Wittemberg on 2019-05-19.
//  Copyright © 2019 WarpFactor. All rights reserved.
//

import Swinject

final class ViewControllerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(MovieListViewController.self) { _ -> MovieListViewController in
            return MovieListViewController.instantiate()
        }
    }
}
