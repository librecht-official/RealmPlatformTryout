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
    @objc dynamic var statusRaw: String = ""
    
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
            createdAt: object.createdAt,
            status: OrderStatus(rawValue: object.statusRaw) ?? .unknown
        )
    }
   
    func realmObject() -> OrderObject {
        let obj = OrderObject()
        obj.id = id
        obj.code = code
        obj.productIds.append(objectsIn: productIds) 
        obj.createdAt = createdAt
        obj.statusRaw = status.rawValue
        return obj
    }
}

extension Order: Sortable {
    enum SortBy: SortByType {
        case createdAt(asc: Bool)
        
        var sortDescriptor: SortDescriptor {
            switch self {
            case let .createdAt(asc):
                return SortDescriptor(keyPath: #keyPath(OrderObject.createdAt), ascending: asc)
            }
        }
    }
}
