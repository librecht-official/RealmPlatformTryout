//
//  DAO.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 30/10/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

import Foundation
import RealmSwift


/// Opened Realm data access object
public final class DAO<T: RealmPersistable> {
    private let realm: Realm
    
    public init(realm: Realm) {
        self.realm = realm
    }
    
    public func fetch() -> FetchResults<T> {
        return FetchResults(realm.objects(T.ObjectType.self))
    }
    
    public func add(_ value: T, update: Bool = true) -> Result<T, RealmError> {
        return self.write { () -> T in
            realm.add(value.realmObject(), update: update ? .all : .error)
            return value
        }
    }
    
    public func add<S: Sequence>(_ values: S, update: Bool = true) -> Result<S, RealmError> where S.Element == T {
        return self.write { () -> S in
            realm.add(values.map { $0.realmObject() }, update: update ? .all : .error)
            return values
        }
    }
    
    public func delete(_ value: T) -> Result<Void, RealmError> {
        return self.write { () -> Void in
            realm.delete(value.realmObject())
        }
    }
    
    public func delete<S: Sequence>(_ values: S) -> Result<Void, RealmError> where S.Element == T {
        return self.write { () -> Void in
            realm.delete(values.map { $0.realmObject() })
        }
    }
}

// MARK: - Identity search

extension DAO where T: IdentityType {
    public func fetch(id: T.ID) -> T? {
        return realm.object(ofType: T.ObjectType.self, forPrimaryKey: id).map { T(object: $0) }
    }
}

// MARK: - Partial Updates

extension DAO where T: PartialUpdatable, T: IdentityType {
    public func update(_ id: T.ID, properties: [T.PropertyValue]) -> Result<T, RealmError> {
        do {
            var result: T?
            try realm.write {
                var dictionary: [String: Any] = [idPropertyName: id]
                
                properties.forEach {
                    let pair = $0.propertyValuePair
                    dictionary[pair.name] = pair.value
                }
                
                let obj = realm.create(T.ObjectType.self, value: dictionary, update: .modified)
                result = T(object: obj)
            }
            return .success(result!)
        } catch {
            return .failure(.writeTransactionFailed(error))
        }
    }
}

// MARK: - Private

private extension DAO {
    func write<R>(_ transaction: () -> R) -> Result<R, RealmError> {
        do {
            var result: R?
            if realm.isInWriteTransaction {
                result = transaction()
            } else {
                try realm.write {
                    result = transaction()
                }
            }
            return .success(result!)
        } catch {
            return .failure(.writeTransactionFailed(error))
        }
    }
}
