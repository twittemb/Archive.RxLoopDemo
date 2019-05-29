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

    init(with resolver: Resolver) {
        self.resolver = resolver
    }

    func navigate(to step: Step) -> FlowContributors {
        switch step {
        case AppStep.movieList:
            return self.navigateToMovieList()
        case AppStep.movieDetail(let id):
            return self.navigateToMovieDetail(with: id)
        case AppStep.movieDetailDone:
            self.rootViewController.presentedViewController?.dismiss(animated: true)
            return .none
        default:
            return .none
        }
    }

    private func navigateToMovieList () -> FlowContributors {
        // dependencies resolution
        let viewController = self.resolver.resolve(MovieListViewController.self)!
        let networkService = self.resolver.resolve(NetworkService.self)!
        let route = self.resolver.resolve(Route<DiscoverMovieEndpoint>.self)!

        // loop definition
        let useCaseMutationEmitter = curry(f3: movieListUseCase)(networkService)(route)
        let mutationEmitter = compose(f1: viewController.emitIntents, f2: useCaseMutationEmitter)

        let movieListLoop = loop(mutationEmitter: mutationEmitter, reducer: movieListReducer)
        _ = movieListLoop(.loading, viewController.render)
            .take(until: viewController.rx.deallocating)
            .start()

        // view presentation
        self.rootViewController.pushViewController(viewController, animated: true)

        // flow coordinator contribution
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewController))
    }

    private func navigateToMovieDetail (with id: Int) -> FlowContributors {
        print (id)
        // dependencies resolution
        let viewController = self.resolver.resolve(MovieDetailViewController.self)!
        let networkService = self.resolver.resolve(NetworkService.self)!
        let route = self.resolver.resolve(Route<MovieDetailEndpoint>.self, argument: id)!

        // loop definition
        let useCaseMutationEmitter = curry(f3: movieDetailUseCase)(networkService)(route)
        let mutationEmitter = compose(f1: viewController.emitIntents, f2: useCaseMutationEmitter)

        let movieListLoop = loop(mutationEmitter: mutationEmitter, reducer: movieDetailReducer)
        _ = movieListLoop(.loading, viewController.render)
            .take(until: viewController.rx.deallocating)
            .start()

        // view presentation
        self.rootViewController.present(viewController, animated: true)

        // flow coordinator contribution
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewController))
    }
}
