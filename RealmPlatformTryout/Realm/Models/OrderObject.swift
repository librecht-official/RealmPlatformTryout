//
//  OrderObject.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 31/10/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

import Foundation
import RealmSwift


final class OrderObject: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var code: String = ""
    let productIds = List<String>()
    @objc dynamic var createdAt: Date = Date()
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

extension Order: RealmPersistable {
    typealias ObjectType = OrderObject
    
    init(object: OrderObject) {
        self.init(
            id: object.id,
            code: object.code,
            productIds: Array(object.productIds),
            createdAt: object.createdAt
        )
    }
   
    func realmObject() -> OrderObject {
        let obj = OrderObject()
        obj.id = id
        obj.code = code
        obj.productIds.append(objectsIn: productIds) 
        obj.createdAt = createdAt
        return obj
    }
}
