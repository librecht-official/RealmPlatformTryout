//
//  RealmPersistable.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 30/10/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

import RealmSwift


public protocol RealmPersistable {
    associatedtype ObjectType: Object
    
    init(object: ObjectType)
    func realmObject() -> ObjectType
}
