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

    private let disposeBag = DisposeBag()

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
        let useCaseMutationEmitter = self.resolver.resolve(UseCaseMutationEmitter<MovieListIntent, MovieListMutation>.self)!

        // loop definition
        let movieListLoop = loop(mutationEmitter: compose(f1: viewController.emitIntents, f2: useCaseMutationEmitter),
                                 reducer: movieListReducer,
                                 interpreter: viewController.render,
                                 interpretationScheduler: MainScheduler.instance)

        // loop runtime
        _ = movieListLoop
            .take(until: viewController.rx.deallocating)
            .start(with: .idle)

        // view presentation
        self.rootViewController.pushViewController(viewController, animated: true)

        // flow coordinator contribution
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewController))
    }

    private func navigateToMovieDetail (with id: Int) -> FlowContributors {
        // dependencies resolution
        let viewController = self.resolver.resolve(MovieDetailViewController.self)!
        let useCaseMutationEmitter = self.resolver.resolve(UseCaseMutationEmitter<MovieDetailIntent, MovieDetailMutation>.self, argument: id)!

        // loop definition

        let movieDetailLoop = loop(mutationEmitter: compose(f1: viewController.emitIntents, f2: useCaseMutationEmitter),
                                   reducer: movieDetailReducer,
                                   interpreter: viewController.render,
                                   interpretationScheduler: MainScheduler.instance)

        // loop runtime
        _ = movieDetailLoop
            .take(until: viewController.rx.deallocating)
            .start(with: .idle)

        // view presentation
        self.rootViewController.pushViewController(viewController, animated: true)

        // flow coordinator contribution
        return .none
    }
}
