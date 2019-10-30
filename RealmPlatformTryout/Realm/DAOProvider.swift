//
//  DAOProvider.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 31/10/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift


struct DataAccessConfiguration {
    let realmURL: URL
    let firstLaunch: Bool
    let user: User
}

typealias AsyncDAOProviderType<T: RealmPersistable> = () -> Single<DAO<T>>

func asyncDAOProvider<T: RealmPersistable>(configuration: DataAccessConfiguration) -> () -> Single<DAO<T>> {
    return {
        let config = configuration.user.syncUser.configuration(
            realmURL: configuration.realmURL,
            fullSynchronization: true
        )
        if configuration.firstLaunch {
            return Single.create { push -> Disposable in
                Realm.asyncOpen(configuration: config, callbackQueue: .main) { (realm, error) in
                    if let realm = realm {
                        let dao = DAO<T>(realm: realm)
                        push(.success(dao))
                    } else if let error = error {
                        push(.error(error))
                    }
                }
                return Disposables.create()
            }
        } else {
            do {
                let realm = try Realm(configuration: config)
                let dao = DAO<T>(realm: realm)
                return Single.just(dao)
            } catch {
                return Single.error(error)
            }
        }
    }
}
