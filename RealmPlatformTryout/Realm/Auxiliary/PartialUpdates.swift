//
//  PartialUpdates.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 30/10/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

import Foundation


public typealias PropertyValuePair = (name: String, value: Any)

public protocol PropertyValueType {
    var propertyValuePair: PropertyValuePair { get }
}

public protocol PartialUpdatable {
    associatedtype PropertyValue: PropertyValueType
}
