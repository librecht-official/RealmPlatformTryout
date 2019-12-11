//
//  Pipe.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 10/12/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

precedencegroup Pipe {
    associativity: left
    lowerThan: MultiplicationPrecedence
}
infix operator |>: Pipe
func |> <A, B>(value: A, f: (A) -> B) -> B {
    return f(value)
}
