//
//  AppFlow.swift
//  RxLoopDemo
//
//  Created by Thibault Wittemberg on 2019-05-19.
//  Copyright © 2019 WarpFactor. All rights reserved.
//

import UIKit
import RxLoop
import RxFlow
import RxSwift
import Swinject

final class AppFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }

    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        return viewController
    }()

    private let resolver: Resolver
    private let disposeBag = DisposeBag()

    init(with resolver: Resolver) {
        self.resolver = resolver
    }

    func navigate(to step: Step) -> FlowContributors {
        switch step {
        case AppStep.movieList:
            return self.navigateToMovieList()
        default:
            return .none
        }
    }

    private func navigateToMovieList () -> FlowContributors {
        let viewController = self.resolver.resolve(MovieListViewController.self)!
        let networkService = self.resolver.resolve(NetworkService.self)!
        let route = self.resolver.resolve(Route<DiscoverMovieEndpoint>.self)!

        let useCaseMutationEmitter = curry(f3: movieListUseCase)(networkService)(route)
        let mutationEmitter = compose(f1: viewController.emitIntents, f2: useCaseMutationEmitter)

        let movieListLoop = loop(mutationEmitter: mutationEmitter, reducer: movieListReducer)
        movieListLoop(.idle, viewController.render)
            .start()
            .disposed(by: self.disposeBag)

        self.rootViewController.pushViewController(viewController, animated: true)

        return .none
    }
}
