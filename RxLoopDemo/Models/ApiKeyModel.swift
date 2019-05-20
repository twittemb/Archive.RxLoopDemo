//
//  ApiKeyModel.swift
//  RxLoopDemo
//
//  Created by Thibault Wittemberg on 2019-05-20.
//  Copyright © 2019 WarpFactor. All rights reserved.
//

struct ApiKeyModel: Encodable {
    let apiKey: String

    enum CodingKeys: String, CodingKey {
        case apiKey = "api_key"
    }
}
