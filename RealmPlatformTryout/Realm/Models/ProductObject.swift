//
//  ProductObject.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 24/10/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

import Foundation
import RealmSwift


final class ProductObject: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var desc: String = ""
    @objc dynamic var imageURLPath: String = ""
    @objc dynamic var priceUSD: Double = 0
    @objc dynamic var priceRUB: Double = 0
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

extension Product: RealmPersistable, IdentityType {
    typealias ObjectType = ProductObject
    
    init(object: ProductObject) {
        self.init(
            id: object.id,
            name: object.name,
            desc: object.desc,
            priceUSD: Decimal(object.priceUSD),
            priceRUB: Decimal(object.priceRUB)
        )
    }
    
    func realmObject() -> ProductObject {
        let obj = ProductObject()
        obj.id = id
        obj.name = name
        obj.desc = desc
        obj.priceUSD = (priceUSD as NSDecimalNumber).doubleValue
        obj.priceRUB = (priceRUB as NSDecimalNumber).doubleValue
        return obj
    }
}

extension Product: PartialUpdatable {
    enum PropertyValue: PropertyValueType {
        case name(String)
        case desc(String)
        
        var propertyValuePair: PropertyValuePair {
            switch self {
            case let .name(name):
                return ("name", name)
            case let .desc(desc):
                return ("desc", desc)
            }
        }
    }
}
