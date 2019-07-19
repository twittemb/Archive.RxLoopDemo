//
//  UseCaseAssembly.swift
//  RxLoopDemo
//
//  Created by Thibault Wittemberg on 2019-06-23.
//  Copyright © 2019 WarpFactor. All rights reserved.
//

import RxSwift
import Swinject

public typealias UseCaseMutationEmitter<Intent, Mutation> = (Observable<Intent>) -> Observable<Mutation>

final class UseCaseAssembly: Assembly {
    func assemble(container: Container) {
        container.register(UseCaseMutationEmitter<MovieListIntent, MovieListMutation>.self) { resolver -> UseCaseMutationEmitter<MovieListIntent, MovieListMutation> in
            let networkService = resolver.resolve(NetworkService.self)!
            let route = resolver.resolve(Route<DiscoverMovieEndpoint>.self)!
            let useCaseMutationEmitter = curry(f3: movieListUseCase)(networkService)(route)

            return useCaseMutationEmitter
        }

        container.register(UseCaseMutationEmitter<MovieDetailIntent, MovieDetailMutation>.self) { (resolver: Resolver, movieId: Int) -> UseCaseMutationEmitter<MovieDetailIntent, MovieDetailMutation> in
            let networkService = resolver.resolve(NetworkService.self)!
            let route = resolver.resolve(Route<MovieDetailEndpoint>.self, argument: movieId)!

            let useCaseMutationEmitter = curry(f3: movieDetailUseCase)(networkService)(route)

            return useCaseMutationEmitter
        }
    }
}
