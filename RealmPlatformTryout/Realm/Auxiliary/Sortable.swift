//
//  Sortable.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 12.03.2020.
//  Copyright © 2020 Vladislav Librekht. All rights reserved.
//

import Foundation


public protocol Sortable {
    associatedtype SortBy: SortByType
}

public protocol SortByType {
    var sortDescriptor: SortDescriptor { get }
}

public struct SortDescriptor {
    let keyPath: String
    let ascending: Bool
}
