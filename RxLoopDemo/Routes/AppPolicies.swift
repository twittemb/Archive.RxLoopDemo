//
//  AppPolicies.swift
//  ClearID
//
//  Created by Thibault Wittemberg on 18-09-24.
//  Copyright © 2018 Genetec. All rights reserved.
//

/// The Application's policies
enum AppPolicy: String {
    case unauthenticated
}

// MARK: - AppPolicies default implementation of CustomStringConvertible
extension AppPolicy: Policy {
    var description: String {
        return self.rawValue
    }
}

