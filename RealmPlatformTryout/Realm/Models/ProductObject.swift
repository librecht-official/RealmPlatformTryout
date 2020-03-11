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
        return #keyPath(ProductObject.id)
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
                return (#keyPath(ProductObject.name), name)
            case let .desc(desc):
                return (#keyPath(ProductObject.desc), desc)
            }
        }
    }
}

// MARK: - Queryable

extension Product: Queryable {
    enum Query: QueryType {
        /// Diacritic and case insensitive
        case nameContains(String)
        
        var predicate: NSPredicate {
            switch self {
            case let .nameContains(search):
                return NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(ProductObject.name), search)
            }
        }
    }
}

// MARK: - Sortable

extension Product: Sortable {
    enum SortBy: SortByType {
        case name(asc: Bool)
        
        var sortDescriptor: SortDescriptor {
            switch self {
            case let .name(asc):
                return SortDescriptor(keyPath: #keyPath(ProductObject.name), ascending: asc)
            }
        }
    }
}
