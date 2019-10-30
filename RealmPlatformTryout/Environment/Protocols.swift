//
//  Protocols.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 30/10/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

import Foundation


protocol NoEnvironment {
}

protocol LoginAPIEnvironment {
    var loginAPI: LoginAPI { get }
}

protocol ProductsAPIEnvironment {
    var productsDAO: DAO<Product> { get }
}

protocol OrdersAPIEnvironment {
    var getOrdersDAO: AsyncDAOProviderType<Order> { get }
}

protocol DateEnvironment {
    func now() -> Date
}

typealias AuthorizedAppEnvironment = NoEnvironment
    & DateEnvironment
    & LoginAPIEnvironment
    & ProductsAPIEnvironment
    & OrdersAPIEnvironment
