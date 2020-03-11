//
//  Queryable.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 11.03.2020.
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//

import Foundation


public protocol Queryable {
    associatedtype Query: QueryType
}

public protocol QueryType {
    var predicate: NSPredicate { get }
}
