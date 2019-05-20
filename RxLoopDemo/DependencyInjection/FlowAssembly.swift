//
//  FlowAssembly.swift
//  RxLoopDemo
//
//  Created by Thibault Wittemberg on 2019-05-19.
//  Copyright © 2019 WarpFactor. All rights reserved.
//

import Swinject

final class FlowAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AppFlow.self) { resolver -> AppFlow in
            return AppFlow(with: resolver)
        }
    }
}
