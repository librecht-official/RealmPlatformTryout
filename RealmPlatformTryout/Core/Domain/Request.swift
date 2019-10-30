//
//  Request.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 27/10/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

import Foundation


struct Request<Value> {
    let timestamp = Date()
    let value: Value
    
    init(_ value: Value) {
        self.value = value
    }
}

extension Request: Equatable {
    static func == (lhs: Request<Value>, rhs: Request<Value>) -> Bool {
        return lhs.timestamp == rhs.timestamp
    }
}
