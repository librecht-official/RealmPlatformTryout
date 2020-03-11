//
//  AppEnvironment.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 24/10/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

import Foundation
import RealmSwift


class UnauthorizedRealmPlatformTryoutAppEnvironment: NoEnvironment {
    let loginAPI: LoginAPI
    
    init() {
        let realmAPIConfig = RealmDBClientConfig.default
        self.loginAPI = PublicRealmDBClient(configuration: realmAPIConfig)
    }
}

extension UnauthorizedRealmPlatformTryoutAppEnvironment: LoginAPIEnvironment {}

// MARK: - Authorized

final class AuthorizedRealmPlatformTryoutAppEnvironment: UnauthorizedRealmPlatformTryoutAppEnvironment {
    let productsDAO: DAO<Product>
    let getOrdersDAO: AsyncDAOProviderType<Order>
    
    init(user: User) {
        let realmAPIConfig = RealmDBClientConfig.default
        
        let config = user.syncUser.configuration(
            realmURL: realmAPIConfig.publicRealmURL,
            fullSynchronization: true
        )
        let realm = try! Realm(configuration: config)
        self.productsDAO = DAO(realm: realm)
        
        self.getOrdersDAO = asyncDAOProvider(
            configuration: .init(
                realmURL: realmAPIConfig.userRealmURL,
                firstLaunch: true,
                user: user
            )
        )
        super.init()
    }
}

extension AuthorizedRealmPlatformTryoutAppEnvironment: ProductsAPIEnvironment {}

extension AuthorizedRealmPlatformTryoutAppEnvironment: DateEnvironment {
    func now() -> Date {
        return Date()
    }
}

extension AuthorizedRealmPlatformTryoutAppEnvironment: OrdersAPIEnvironment {}

// MARK: - RealmDBClientConfig

extension RealmDBClientConfig {
    static let `default`: RealmDBClientConfig = RealmDBClientConfig(
        instanceAddress: realmInstanceAddress
    )
}
