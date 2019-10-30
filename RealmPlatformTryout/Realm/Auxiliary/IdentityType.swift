//
//  IdentityType.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 31/10/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

public protocol IdentityType {
    associatedtype ID : Hashable
    var id: Self.ID { get }
}

let idPropertyName = "id"
