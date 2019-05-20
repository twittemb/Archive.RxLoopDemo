//
//  ServiceAssembly.swift
//  RxLoopDemo
//
//  Created by Thibault Wittemberg on 2019-05-19.
//  Copyright © 2019 WarpFactor. All rights reserved.
//

import Swinject

final class ServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AlamofireNetworkService.self) { _ -> AlamofireNetworkService in
            return AlamofireNetworkService()
            }.implements(NetworkService.self)
    }
}
