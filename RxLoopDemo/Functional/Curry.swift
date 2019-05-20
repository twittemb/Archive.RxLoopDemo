//
//  Curry.swift
//  RxLoopDemo
//
//  Created by Thibault Wittemberg on 2019-05-20.
//  Copyright © 2019 WarpFactor. All rights reserved.
//

func curry<A, B, C> (f2: @escaping (A, B) -> C) -> (A) -> (B) -> C {
    return { (a: A) -> (B) -> C in
        return { (b: B) -> C in
            return f2(a, b)
        }
    }
}

func curry<A, B, C, D> (f3: @escaping (A, B, C) -> D) -> (A) -> (B) -> (C) -> D {
    return { (a: A) -> (B) -> (C) -> D in
        return { (b: B) -> (C) -> (D) in
            return { (c: C) -> D in
                return f3(a, b, c)
            }
        }
    }
}
