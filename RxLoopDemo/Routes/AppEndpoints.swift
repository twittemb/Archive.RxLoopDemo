//
//  AppEndpoints.swift
//  ClearID
//
//  Created by Thibault Wittemberg on 18-09-24.
//  Copyright © 2018 Genetec. All rights reserved.
//

/// Represents the discover movie endpoint
struct DiscoverMovieEndpoint: Endpoint {
    typealias RequestModel = ApiKeyModel
    typealias ResponseModel = DiscoverMovieResponse

    let path: Path
    let prefixPath = "/3"
    let httpMethod = HTTPMethod.get
    let parameterEncoding = ParameterEncoding.url
    let policy: Policy = AppPolicy.unauthenticated
}

/// Represents the discover tv endpoint
struct DiscoverTVEndpoint: Endpoint {
    typealias RequestModel = ApiKeyModel
    typealias ResponseModel = DiscoverTVResponse

    let path: Path
    let prefixPath = "/3"
    let httpMethod = HTTPMethod.get
    let parameterEncoding = ParameterEncoding.url
    let policy: Policy = AppPolicy.unauthenticated
}
