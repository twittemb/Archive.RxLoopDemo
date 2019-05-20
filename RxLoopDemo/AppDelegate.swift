//
//  AppDelegate.swift
//  RxLoopDemo
//
//  Created by Thibault Wittemberg on 2019-05-16.
//  Copyright © 2019 WarpFactor. All rights reserved.
//

import RxFlow
import Swinject
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private let flowCoordinator = FlowCoordinator()
    
    private let injectionAssembler = Assembler([
        FlowAssembly(),
        RoutesAssembly(withBaseUrl: "api.themoviedb.org", apiKey: "3afafd21270fe0414eb760a41f2620eb"),
        ViewControllerAssembly(),
        ServiceAssembly()
        ])
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        guard let window = window else { return false }

        let appFlow = self.injectionAssembler.resolver.resolve(AppFlow.self)!

        // Setting the RootFlow's root ViewController as the window root ViewController
        Flows.whenReady(flow1: appFlow) { [window] (rootViewController) in
            window.rootViewController = rootViewController
        }

        // Starting Flow coordination
        self.flowCoordinator.coordinate(flow: appFlow, with: OneStepper(withSingleStep: AppStep.movieList))

        return true
    }
}
