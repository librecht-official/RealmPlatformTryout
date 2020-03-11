//
//  Order.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 31/10/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

import Foundation


struct Order {
    let id: String
    let code: String
    let productIds: [String]
    let createdAt: Date
    let status: OrderStatus
}

enum OrderStatus: String {
    case accepted = "Accepted"
    case processing = "Processing"
    case done = "Done"
    case unknown
}
